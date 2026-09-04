# Copyright (c) 2026 4dcitygml
# SPDX-License-Identifier: Apache-2.0
# Starts the shared 4dcitygml editing tool connected to THIS city.
# The tools release is pinned in tools-release.json (tag + asset name + SHA-256).
# Fail-closed: nothing is downloaded until the pin is filled in, and nothing is
# executed unless the downloaded archive matches the pinned SHA-256.
$ErrorActionPreference = "Stop"

# Locate config file: .\ when run from install/ in the repo, .\ when run from "starter kit" (small zip with bundled config)
Set-Location $PSScriptRoot
if (Test-Path "..\4dcitygml.json") { Set-Location ".." }
$config = Get-Content "4dcitygml.json" -Raw | ConvertFrom-Json
$env:CITYGML_UPSTREAM = $config.repo

$manifestPath = "tools-release.json"
if (Test-Path "install\tools-release.json") { $manifestPath = "install\tools-release.json" }
$m = Get-Content $manifestPath -Raw | ConvertFrom-Json
$tag = $m.tag
$asset = $m.windows.asset
$sha = $m.windows.sha256
if (-not $tag -or -not $asset -or -not $sha) {
  Write-Host "Distribution tools release is not yet finalized (install/tools-release.json is not filled in)."
  Write-Host "For administrators: after the first tools release, fill in tag / asset / sha256."
  exit 1
}

$dest = Join-Path $env:USERPROFILE "Documents\citygml-tools"
$app = Join-Path $dest "citygml-hub\program\hub.py"
$py = Join-Path $dest "citygml-hub\program\PythonPortable\python.exe"
$mark = Join-Path $dest "citygml-hub\.release-tag"   # tag of the installed release; a different pin triggers an update
$installed = if (Test-Path $mark) { (Get-Content $mark -Raw).Trim() } else { "" }

if (-not (Test-Path $app) -or $installed -ne $tag) {
  if (Test-Path $app) { Write-Host "Updating the editing tool ($installed -> $tag)..." } else { Write-Host "Downloading the editing tool ($tag)..." }
  New-Item -ItemType Directory -Force $dest | Out-Null
  $tmp = Join-Path $env:TEMP "citygml-hub-download.zip"
  curl.exe -fLsS "https://github.com/4dcitygml/tools/releases/download/$tag/$asset" -o $tmp
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Download failed. Please check your network connection."
    exit 1
  }
  $actual = (Get-FileHash $tmp -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($actual -ne $sha.ToLowerInvariant()) {
    Remove-Item $tmp
    Write-Host "Downloaded zip SHA-256 mismatch (expected $sha / actual $actual). Aborting."
    exit 1
  }
  # Unpack next to the old copy first; only a verified, complete archive replaces it.
  $stage = Join-Path $env:TEMP "citygml-hub-stage"
  if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
  Expand-Archive -LiteralPath $tmp -DestinationPath $stage -Force
  Remove-Item $tmp
  $target = Join-Path $dest "citygml-hub"
  if (Test-Path $target) { Remove-Item $target -Recurse -Force }
  Move-Item (Join-Path $stage "citygml-hub") $target
  Remove-Item $stage -Recurse -Force
  Set-Content -Path $mark -Value $tag -NoNewline
}

if (-not (Test-Path $py)) {
  Write-Host "Bundled Python not found: $py"
  Write-Host "The downloaded distribution may be corrupted. Delete $dest and try again."
  exit 1
}
& $py $app
exit $LASTEXITCODE

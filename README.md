# <City Name> Building Data Repository

<!-- city-template: the 4dcitygml template for a new city. Replace every <...> with your city's values. -->

Building data (CityGML) for <City Name>, collaboratively maintained via pull requests.

## Initializing a new city repository (delete this section when done)

1. Create your repository with GitHub **Use this template** (not a fork).
2. Copy `4dcitygml.json.example` to `4dcitygml.json` and fill every `<...>`
   placeholder (`id`, `name`, `repo`, `country`, `lang`, `crs`,
   `building_id`, `data_dirs`, `attribution`, `license`). Leave
   `oauthClientId` empty unless you operate your own OAuth App.
3. Copy `theme.json.example` to `theme.json` and adjust the tokens.
4. Put your CityGML data in the folder named in `data_dirs`.
5. Replace `NOTICE` with your dataset's provenance record (source URL,
   acquisition date, original license, required attribution, list of
   modifications) and extend `LICENSE` with the dataset's terms. The
   `sample-*-station` repositories are worked examples of both files.
6. Check `install/tools-release.json`: `tag` / `asset` / `sha256` must point
   to a current `4dcitygml/tools` release (the start scripts refuse to
   download while these are empty, and stop on a checksum mismatch).
7. In `.github/workflows/`, keep `CITYGML_TOOLS_REF` pinned to an immutable
   commit SHA of `4dcitygml/tools`. Update it deliberately per release —
   never point it at a branch. The workflows fetch the shared CI logic from
   `4dcitygml/tools` regardless of which account or organization hosts your
   repository; only if you maintain your own audited mirror of `tools`, set
   the repository variable `CITYGML_TOOLS_REPO` (Settings → Secrets and
   variables → Actions → Variables) to `owner/name`.
8. Update `.github/CODEOWNERS`: replace the owner handle with your
   maintainer account (an organization cannot be a code owner). The
   `sample-*-station` repositories additionally exempt their enumerated
   practice data files from code-owner review — do not copy that pattern
   into a production city repository.
9. Replace `<City Name>` in this README, delete the template comment at the
   top of it, and add `logo.png` (optional).
10. On GitHub, enable branch protection / rulesets (required checks,
    code-owner review, conversation resolution, no force-push or deletion)
    and set Actions to require approval for first-time contributors.

- **Get started (residents / contributors):** download the starter kit from this
  repository's release `starter-kit` (`<city-id>-starter.zip`, built automatically by
  `.github/workflows/starter-kit.yml` once `install/tools-release.json` is filled in),
  unzip it, and double-click `start-mac.command` (macOS) or `start-windows.bat`
  (Windows). The shared editing tool is downloaded automatically and connects to this
  city; contributors do not need to clone the repository (the tool creates their copy).
  Step by step, including working with Git directly: [Getting started](docs/getting-started.md).
- **Data source & license:** see `4dcitygml.json` (`attribution` / `license`).
- **Building history (optional):** enable GitHub Pages (Source: GitHub Actions)
  and run the workflow "Building history index (Pages)"; it publishes the
  repository content (preview URLs stay the same as with the "main / root"
  source) plus a static page under `/history/` where anyone can look up a
  `uro:buildingID` and see every recorded change to that building (proposals,
  identity changes, official editions). Re-run it after merges you want
  reflected.
- **Edition:** `edition` in `4dcitygml.json` names the i-UR edition the data is
  serialized in (`iur-3.2` …; omit for datasets without i-UR). When an edition
  change is carried forward, codes that could not be mapped keep their old
  code list under `codelists/<edition>/` and are counted by the release gate.
- **Look & feel:** `theme.json` (declarative tokens only; changes go through PR review).
- **City logo (optional):** set `logo` in `4dcitygml.json` to a raster image
  (png / jpg / jpeg / webp, ≤ 1 MiB) inside this repository; it is shown top-left in
  every tool. SVG is not accepted — an SVG opened directly can execute scripts, which
  would break the "no XSS by construction" design shared with themes.

## Viewing the data in a standalone viewer

If you just want to look at the CityGML without contributing, free Windows
viewers such as **[KITModelViewer](https://www.iai.kit.edu/english/4561.php)**
by KIT (successor of the FZKViewer;
[FZKViewer](https://www.iai.kit.edu/english/1648.php) also works for
CityGML 1.0/2.0) open the GML files in this repository directly. If the
dataset includes textures, download the repository as a whole (Code →
Download ZIP, or clone) and keep the folder structure so relative texture
paths resolve.

To edit attributes and propose changes, use the shared editing tool (see
"Get started" above).

CityGML is a standard of the Open Geospatial Consortium (OGC). This project is not
affiliated with or endorsed by OGC.

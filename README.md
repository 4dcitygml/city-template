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
6. Do not add tools, scripts or a starter kit to this repository: a city
   repository holds data, documents and settings only, and CI rejects code
   (Exchange Contract A11). Residents install the editing tools with the one-line
   command in the *Get started* bullet below; the tools' version comes from
   `4dcitygml/tools` releases. Optionally state the oldest client you accept
   with `min_hub` in `4dcitygml.json` (advisory; the hub shows it as the reason
   for an update).
7. In `.github/workflows/`, keep `CITYGML_TOOLS_REF` pinned to an immutable
   commit SHA from a published `tools-v` release of `4dcitygml/tools`.
   Update it deliberately per release —
   never point it at a branch. The workflows fetch the shared CI logic from
   `4dcitygml/tools` regardless of which account or organization hosts your
   repository; only if you maintain your own audited mirror of `tools`, set
   the repository variable `CITYGML_TOOLS_REPO` (Settings → Secrets and
   variables → Actions → Variables) to `owner/name`.
8. Update `.github/CODEOWNERS`: replace the owner handle with your
   maintainers team, e.g. `* @<org>/maintainers` (an organization cannot be
   a code owner, but a team can; the team must be visible and have write
   access). Keeping the file team-based means people join and leave the
   review role by changing team membership — the file itself never changes.
   The `sample-*-station` repositories additionally exempt their enumerated
   practice data files from code-owner review — do not copy that pattern
   into a production city repository.
9. Replace `<City Name>` in this README, delete the template comment at the
   top of it, and add `logo.png` (optional).
10. On GitHub, enable branch protection / rulesets: required checks
    `analyze` and `ci-report`, the city's required approval count with review
    from Code Owners, dismiss stale
    approvals on push, approval of the most recent reviewable push,
    conversation resolution, no force-push or deletion. Allow the merge
    method `merge` (city-data PRs keep one commit per building; do not
    restrict merging to squash). Set Actions to require approval for
    first-time contributors. See `docs/pr-operations.md` §2–§3 for the
    seats (owner, maintainers, operators) these settings assume.
11. For every production city repository, set the Actions repository variable
    `CITYGML_STRICT_GATE` to `1` (Settings → Secrets and variables → Actions →
    Variables). Requiring `analyze` alone does not make individual inspection
    failures block merging. Before opening contributions, use a test PR with
    a deliberately invalid building attribute to verify that `analyze` fails
    and the required check blocks merging without admin bypass. Record the PR
    and workflow run URLs, then close the test PR without merging it. If the
    job succeeds despite an inspection failure, do not start operation.
12. Require `ci-report` alongside `analyze`, with **GitHub Actions** as the expected
    source, and set `CITYGML_STRICT_GATE=1`. Reviewers use the same CI report and
    standard GitHub Approve. Configure the required approval count for the city's
    current arrangement; it may change over time. See [review settings](docs/review-settings.md).
    Remove the unpublished prototype's `operator-explanation` required check and
    workflows when migrating; there is no separate operator confirmation stage.
    This template pins tools-v1.1.0 for CI; clients are not pinned by cities.
    City settings and GitHub acceptance tests are still required before rollout. Test report failure/staleness, approval counts and personal filters.


- **Get started (residents / contributors):** open a terminal and paste one line.
  macOS (Terminal):
  ```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/4dcitygml/tools/install-v1/install/citygml.sh)" -- <owner>/<code>-<cityname>
  ```
  Windows (PowerShell):
  ```
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/4dcitygml/tools/install-v1/install/citygml.ps1))) <owner>/<code>-<cityname>
  ```
  The shared editing tools are downloaded from `4dcitygml/tools`, verified, and
  connect to this city; you do not need to clone the repository (the tools create
  your own copy) and after the first time a desktop icon opens them.
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

For city staff: [処理フローの解説（日本語）](docs/ja/processing-flow.md)
covers setup, proposals, automated checks, approval, corrections, and releases.

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

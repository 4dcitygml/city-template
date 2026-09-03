<!--
Copyright (c) 2026 4dcitygml
Building-data PR template for this city repository.
PRs created by the shared editing tools fill in the reason automatically; for
manual PRs, "Target buildings / scope" and "Summary of changes" are the
minimum. Specialist sections that do not apply to everyday fixes can be left
blank. Administrative PRs (source-update etc.) must fill in all required
sections.
Submitting from your own tool or script? The full machine contract is at
https://github.com/4dcitygml/tools/blob/main/docs/exchange-contract.md
-->

## PR type
<!-- Pick exactly one. Types whose dedicated CI is not implemented yet must not be marked Ready for review. -->
- [ ] `correction` (everyday attribute / geometry / position / texture fixes)
- [ ] `lifecycle` (rebuild, split, merge)
- [ ] `identity-correction` (fixing a mis-linked ID in published history)
- [ ] `source-update` (applying an official source / annual edition)
- [ ] `schema-update` (adding edition-specific artifacts and validation profiles)
- [ ] `carry-forward` (re-basing the repository's changes onto a new official edition)
- [ ] `schema-migration` (registry-driven re-serialization into a new edition when the repository is the master copy)
- [ ] `layout` (semantics-preserving mesh subdivision)
- [ ] `texture-gc`
- [ ] `revert`
- [ ] code / documentation only

## Target buildings / scope
<!-- The stable uro:buildingID of each affected building. Multi-building PRs: one ID per commit. Administrative PRs: specify the mesh or manifest. -->
-

## Summary of changes <!--sec:reason-->
<!-- Required — CI marks the PR as "reason missing" if this section is empty. What was changed and why (position fix / height correction / texture replacement etc.), plus the supporting evidence (official source, on-site photo, ...), in 1-2 lines. -->


## Change type
<!-- Check all that apply. If unsure, describe the situation under "Other". -->
- [ ] Attribute fix (storeys, usage, area, etc.)
- [ ] Geometry fix (shape, height, roof form, etc.)
- [ ] Position fix (correcting misalignment)
- [ ] Texture fix (replacement, filling gaps, etc.)
- [ ] Lifecycle (building merge / split / rebuild; involves add/delete)
- [ ] Other:

## Image rights
<!-- Required whenever the PR adds or replaces photos / texture images; otherwise leave unchecked. See ../docs/data-contribution-policy.md (§1-§2). -->
- [ ] Every added image was **taken by myself** (no photos by others, no images from the web or social media)
- [ ] Every photo was taken from a lawful location such as a public road
- [ ] No recognizable faces, license plates, nameplates, room interiors, or similar privacy-sensitive details remain (masked / blurred where needed)
- [ ] No third-party work (sign, poster, display) is the main subject of any image
- [ ] I provide the added data and images under **CC0 1.0** as set out in the [data contribution policy](../docs/data-contribution-policy.md), and for photos I also agree not to exercise moral rights (cropping, perspective correction, compositing, and recompression are part of texturing)

## Source / manifest (source-update / schema / layout etc.)
<!-- For everyday corrections, supporting evidence alone is fine. Required for the administrative PR types below. -->
- Source-From:
- Source-To:
- Scope-Mesh:
- Attribute-Family:
- Allowed-Paths:
- History-Manifest:
- Provenance-Manifest:
- Manifest-SHA256:
- Plan-Issue:
- Building-Count:
- First-Building-ID:
- Last-Building-ID:

## Checklist
- [ ] Created from the latest main, with no conflict against earlier PRs on the same mesh
- [ ] For normal updates, each commit is **1 commit = 1 `uro:buildingID`**
- [ ] For normal updates, fixes to the same buildingID are not split across multiple commits in the PR
- [ ] The `Building:` (etc.) trailer of each building commit matches the actually changed buildingID
- [ ] For multi-building PRs, if any single building fails a blocking CI check, the whole PR is fixed
- [ ] If a geometry preview was shown, the appearance was checked with 🔴 before / 🔵 after
- [ ] For lifecycle changes, the **reason for the merge / split / rebuild** is written under "Summary of changes"
- [ ] For texture changes, no existing image is **overwritten under the same name** (exception: `texture-override`)
- [ ] If there is a related issue, it is linked with `Fixes #<number>` or `Refs #<number>`
- [ ] The applicable checklist in the [PR operations guide](../docs/pr-operations.md) was reviewed

## Related issues
<!-- Fixes if the change closes it, Refs if merely related. "None" if none. -->


## Additional notes (optional)
<!-- Supporting documents, sources for the correct values, points you want reviewers to look at. -->

<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Reviewer's guide

City staff and authorized contractors use the same CI report and GitHub Approve.
There is no separate operator confirmation stage. The city determines who can
review and how many approvals are needed, and can change the count over time.

For the full process, read [自治体職員のための処理フロー](ja/processing-flow.md).

## 1. What you confirm

Read the generated change, evidence, checks, impact and recommendation. Check
that the evidence supports the proposed change and that any exception or lifecycle
relationship is justified. CI performs mechanical checks; it does not establish
real-world facts or make the city's adoption decision. Do not rewrite its report.

## 2. Where and how

In the hub, select a PR, read its common report and comparison views, then use
Approve or Request changes. On GitHub, use Files changed → Review changes.
You cannot approve your own PR. One account contributes one approval, even if
that person covers several responsibilities or approves repeatedly.

The list offers All, remaining zero/one/two/etc., and count unavailable. A numeric
filter shows PRs whose inspection is ready. The selection is saved in this browser
for the signed-in account and repository. Refresh to obtain new approvals and
current GitHub settings. Other people's selections are unaffected.

For four required approvals, two contractors may review first, a city employee
may select remaining two, and a supervisor remaining one. The filter does not
assign reviewers or enforce that order. [Review settings](review-settings.md)
explain the difference between counts and role-specific requirements.

## 3. What the rules check

`analyze` checks the data and `ci-report` verifies current machine evidence.
GitHub enforces the configured approval count, optional Code Owners, stale-review
and last-push requirements, unresolved conversations and other merge conditions.
Remaining zero means the numeric count is reached; it does not promise mergeability.
If counts cannot be read, the hub shows unavailable instead of assuming zero.

Approvals are ordinary GitHub records. A push may invalidate them according to
the city's configured rules; a CI rerun alone does not automatically dismiss them.
City-data PRs use merge commits to preserve their building commits.

## 4. Notifications and Draft

Draft is the proposer's work-in-progress state. CI also runs on Drafts. The
proposer marks a Draft Ready when requesting review. GitHub's review requests
and Code Owner settings determine notifications; a local list filter does not
change notification subscriptions.

## 5. When something needs correction

Use Request changes and explain the issue. The proposer fixes it and CI reruns.
Review the new results and Approve if satisfactory. Requests, approvals and
releases remain separate records. An operations contact can handle questions,
merges and releases without being a mandatory first reviewer.

## 6. For the administrator

Maintain team membership and required counts as personnel and contracts change.
Record the change date, old/new count and reason. Plan for enough eligible
reviewers excluding each PR's author, and arrange absence coverage. Roles can be
combined in one account; this never makes one person count twice.

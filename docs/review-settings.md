<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Review counts and personal filters

All reviewers read the same CI report and use GitHub Approve. The city chooses
eligible reviewers and may change the required approval count whenever its
staffing or contracts change. An authorized administrator records the change
date, old/new count and reason in an issue or the operations record. GitHub's
ruleset audit trail records the setting change; the explanatory record supplies
its operational context. Treat existing open PRs as subject to current settings.

Use the intended number of participating reviewers as the starting point for the
required count. Exclude the PR author, who cannot approve their own proposal.
Accounts with write access are not automatically the intended review group.
One account counts once even if it covers several responsibilities. Arrange
coverage or revise the requirement if the available reviewers change.

A count of two does not require one employee and one supervisor. If a particular
team's participation must be enforced, configure that condition separately,
using the city's GitHub rules and Code Owners. Multiple simultaneous rulesets
and classic protection combine; reducing one setting may leave a stricter rule
in effect elsewhere. Keep applicable data/report checks enabled.

## In the hub

Select **Remaining approvals** in the review list:

- **All PRs**: includes inspection, correction and review stages.
- **N remaining**: inspected PRs with exactly N more numeric approvals needed.
- **Approval count unavailable**: PRs whose count could not be determined.

The preference is saved locally in this browser, separately for each GitHub
account and repository. It is not a repository-wide setting and is not synced
to other devices. Refresh reloads GitHub's current rules and reviews. If a rule
change makes the saved filter empty, the filter remains selected so the user
can choose a new value; the hub does not silently change their preference.

For four required approvals, two contractors might review first, the city
employee selects remaining two, and their supervisor selects remaining one.
This is a way to organize the view, not a lock, assignment or enforced review
order. A different authorized reviewer can still approve through GitHub.

Each card shows approved / required / remaining. The hub reads active rulesets
and classic branch protection, uses the strictest numeric requirement, and
counts each account's latest active approval with effective write-or-higher
access. A comment adds no vote. Dismissed or superseded approvals do not count.
An older-commit approval that GitHub has left active is not locally discarded.

**Remaining zero is not a merge decision.** Code Owners, last-push requirements,
changes requested, CI and unresolved conversations may still block merging.
A read failure is shown as unavailable rather than a guessed zero; unavailable
items can always be found under All or the unavailable filter.

## Deployment

This is a local change pending release, city pin updates and a GitHub pilot.
Required machine checks are `analyze` and `ci-report`, issued by GitHub Actions.
Remove the prototype `operator-explanation` requirement and its two workflows;
ship `review-report.yml` and `check_review_report.py` with the current publisher.
The shared Python helper retains its historical filename for portable package
compatibility, but no longer verifies human confirmation records.

Test required counts 1/2/3/4, rule changes while PRs remain open, withdrawal of
reviews, permission changes and API failures. Verify the filters with different
accounts, including a read-only session. The hub does not modify GitHub approval
settings on the user's behalf. Keep the city's own permission and release policy.

---
name: pr-review
description: Address all open review findings on the current PR
---
1. Confirm repo root with `git rev-parse --show-toplevel` and that branch is not behind origin.
2. Use mcp__github-standard__pull_request_read to fetch all unresolved review comments for the current branch's PR.
3. For each finding: quote it, state the fix, apply the edit.
4. Run the test suite and lint; report pass/fail per finding.
5. Summarize as a checklist ready to paste as a PR reply.

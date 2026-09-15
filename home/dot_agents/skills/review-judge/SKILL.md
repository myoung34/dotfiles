---
name: review-judge
description: Judge every open review-bot comment on the current PR — wait for Codex Review and Claude Review Critique, then agree (fix, brief reply, resolve) or disagree (brief justification, resolve), looping until nothing actionable remains. Use when asked to judge, resolve, or clear review bot comments.
---

# review-judge

Judge every open review-bot comment on the current PR. Codex Review (`codex-review[bot]`) posts findings; Claude Review Critique (`claude[bot]`) replies with an **Agree** / **Disagree** / **Fix** verdict — a strong prior for your judgment, not an order.

Keep running this loop:

1. Run `make review/judge` (add `PR=<n>` to target another PR). It waits for both bots on the current head, then prints a JSON work order: `actionable` threads, `heldOpen` threads (already judged, deliberately unresolved), `humanBlocked` threads, `summaryFindings`, and `done`.
2. If `done` is true: before stopping, judge every finding in `summaryFindings` you have not already judged this session. It is the newest Codex review body passed through verbatim (null when there are none) — those findings never became threads, so there is nothing to reply to or resolve. If its `isStale` is true, the body predates the current head and the last push may already have fixed things: re-verify against the current code first. Agree with a finding → implement the fix and continue to step 4; the fix and push are the whole action. Disagree → record a brief justification for your final report. Once nothing remains unjudged: stop and report — name every `heldOpen` and `humanBlocked` thread and every `summaryFindings` finding with your judgment.
3. Review PR comments. For each `actionable` comment, read the full code around `path:line`, then:
   - if you agree with feedback: implement the fix — the smallest correct change — then post a brief reply and resolve the conversation;
   - if you disagree with feedback: post a brief justification why this is not applicable and resolve the conversation. Be concrete, citing the code that makes it inapplicable; if `critiqueVerdict` is null, say the judgment is yours alone.
4. Run `make diff/analyze` before posting any reply or resolving anything — stop if it fails on code you changed. Then reply and resolve each judged thread in one step, writing the reply to a file first (bodies contain backticks and `$(...)`):

   ```bash
   .github/scripts/review-resolve-thread.sh --thread-id <threadId> --reply-to <rootCommentDatabaseId> --body-file /tmp/reply.md
   ```

   Two exceptions, always: never resolve a thread a human has commented in — do what the human asked, reply, and leave it for them to close (`humanBlocked` lists these); and never resolve a `high` finding you disagree with — reply with `--no-resolve` and leave it open; it moves to `heldOpen` on the next round and is reported, not retried.
5. If any fix was implemented: `git add -A && git commit --amend --no-edit && git fetch origin main && git rebase origin/main && git push --force-with-lease`; the push starts a new bot round. Either way, go to step 1 — replying and resolving changed the work order even without a push, and the loop must exit through step 2's `done` branch, which is where summary findings are judged and the final report is produced.

Termination: the loop ends when `done` is true — including when Codex posted no comments at all — and never runs more than **10 rounds** in one session; if work remains after round 10, stop and report what is left and why. `heldOpen` and `humanBlocked` threads do not keep the loop alive. Draft PRs are not reviewed — `make review/judge` fails fast on one; mark the PR ready for review first. Never merge the PR — `review-signoff.yml` owns approval and auto-merge. Full design and field reference: `.github/docs/review-judge.md`.

---
description: Run the strict TDD cycle for a task (tests → QA → approve → implement → review)
argument-hint: <feature, issue #, or plan file>
---

Drive a strict TDD red-green-refactor cycle for the following work, orchestrating
the dev agents. Run this in this conversation so you can pause for my approval.

Target: $ARGUMENTS

Steps:

1. **Plan check.** Find the relevant plan in `.agents/plans/`. If none exists for
   this work, STOP and tell me to run `/plan` first (or offer to). A plan with
   defined edge cases is the input to TDD.

2. **Red — write failing tests.** Invoke the `test-writer` subagent to write
   failing tests from the plan (including edge and error cases) and confirm they
   fail for the right reason.

3. **Strengthen.** Invoke the `qa` subagent to find testing gaps in the new tests
   vs. the plan. If it reports meaningful gaps, send them back to `test-writer`
   to add tests. Repeat until QA is satisfied.

4. **Red gate (approval).** Show me the new tests (`git diff` of `src/test/`) plus
   a short summary, then ask for my approval with `AskUserQuestion` BEFORE any
   implementation. If I request changes, loop back to step 2/3.

5. **Green — implement.** Invoke the `implementer` subagent to write production
   code under `src/main` until `./gradlew test` is fully green. The implementer
   must NOT modify tests.

6. **Review.** Invoke the `code-reviewer` and `security` subagents on the diff.
   Surface their findings grouped by severity. If there are blocking issues, fix
   them (re-run `implementer` for code, or `test-writer` for tests, then
   re-review).

7. **Report.** Summarize: tests added, code changed, QA/review/security outcomes,
   and that the suite is green. Propose a Conventional Commit message and offer to
   open a PR (`main` is protected — changes land via PR).

Rules: do not modify tests during the green phase. Make no assumptions — if a
step surfaces an unspecified behavior, ask me rather than guessing.

If no target was provided, ask what to build first.

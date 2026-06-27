---
description: Take a GitHub issue through the full plan → TDD → PR workflow on a branch
argument-hint: <issue number>
---

Work GitHub issue #$ARGUMENTS end to end, landing the change via a pull request.
`main` is protected — never commit to it directly.

Steps:
1. **Read the issue:** `gh issue view $ARGUMENTS`. Summarize the goal and
   acceptance criteria. If the issue is unclear or underspecified, ask me before
   proceeding — make no assumptions.
2. **Branch off the latest main:**
   `git switch main && git pull && git switch -c <type>/$ARGUMENTS-<kebab-slug>`
   (or `gh issue develop $ARGUMENTS --checkout` for a linked branch).
3. **Plan:** run the `/plan` workflow for this issue — interrogate edge cases and
   write the plan to `.agents/plans/`. Get my approval of the plan.
4. **Build it test-first:** run the `/tdd` workflow — red → QA gap-check → my
   approval of the failing tests → green → `code-reviewer` + `security` review.
   Address findings.
5. **Commit:** use the `/commit` workflow (logical commits, gate-enforced).
6. **Open a PR:** push the branch and run `gh pr create` using the PR template;
   include `Closes #$ARGUMENTS` in the body so the issue auto-closes on merge.
7. **Report** the PR URL and a short summary. Do NOT merge — leave that to me.

If anything is ambiguous at any step, stop and ask.

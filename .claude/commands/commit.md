---
description: Stage, validate, and commit changes with a Conventional Commit message (runs the commit gate)
argument-hint: [optional scope/subject hints]
---

Create a commit for the current changes.

$ARGUMENTS

Steps:
1. Review everything that changed: `git status` and `git diff` (staged + unstaged).
2. **Group the changes into small, logical, atomic commits** — one concern per
   commit (e.g. a refactor separate from a feature separate from config/docs/test
   changes). Don't lump unrelated changes together, and don't split one coherent
   change across commits. Each commit should build/pass on its own. Stage one
   group at a time with `git add <paths>` (or `git add -p` for hunk-level splits).
3. Show me the proposed commit breakdown — the groups and their messages — and
   confirm before creating them, unless it's a single obvious concern.
4. For each group, in a sensible order (e.g. infra/refactor before the feature
   that builds on it):
   - Stage only that group's files.
   - Write a **Conventional Commits** message (see `.gitmessage`):
     `<type>(<scope>): <subject>` — imperative mood, subject ≤50 chars, with a body
     explaining what/why and a footer referencing issues (`Closes #N`) when relevant.
   - Commit with `git commit`. The pre-commit hook automatically runs
     `./gradlew check`. Do NOT use `--no-verify`/`-n` — it is blocked, and bypassing
     the gate is forbidden. If validation fails, FIX the issues and retry; never bypass.
5. Report each commit hash. Note that `main` is protected — land via PR unless a
   direct admin-bypass push is intended.

Always end the commit message with the required `Co-Authored-By` trailer.

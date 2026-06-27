# Contributing

## One-time setup
After cloning, enable the commit validation gate (git hooks):

```bash
./gradlew installGitHooks     # or: git config core.hooksPath .githooks
```

A normal `./gradlew build` / `check` also enables it automatically.

## Workflow
- Work is **issue-driven**; `main` is protected — land changes via pull requests.
- Development is **test-driven**. Use the agent workflow: `/plan` → `/tdd` →
  `/commit`, or `/work-issue <#>` to run the whole loop for an issue.
- Commits follow **Conventional Commits** (template in `.gitmessage`).

## Validation gate
Every commit must pass `./gradlew check` (tests + Spotless formatting + Checkstyle),
enforced locally by `.githooks/pre-commit` and on pull requests by CI
(`.github/workflows/ci.yml`). Don't bypass it — `--no-verify` is blocked for the AI.

Run `./gradlew spotlessApply` to auto-fix formatting.

## Build
- `./gradlew build` — build + test all modules
- `./gradlew :bellows-core:test` — test a single module
- Java 25 (LTS); dependency/plugin versions live in `gradle/libs.versions.toml`.

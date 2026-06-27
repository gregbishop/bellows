# bellows

Spring Boot 4.1 / Java 25 (LTS) / Gradle project.

## Build & test
- `./gradlew build` — compile, run tests, assemble
- `./gradlew bootRun` — run the application
- Java toolchain is **25 (LTS)**; dependency and plugin versions are managed in
  `gradle/libs.versions.toml` (Gradle version catalog).

## Conventions
- Commit messages follow **Conventional Commits** (template in `.gitmessage`).
- `main` is protected — changes go through pull requests (admin/owner bypass).
  PRs use `.github/pull_request_template.md`.

## Planning
Whenever you create a plan — in built-in plan mode, when asked to "create a
plan"/"let's plan this", or via the `/plan` command — follow these rules:
- Write the plan to `.agents/plans/<YYYY-MM-DD>-<kebab-topic>.md` (get the date
  with `date +%Y-%m-%d`).
- Use this structure: **Context / Approach / Reuse / Files to change / Open
  questions & assumptions / Verification**.
- **Make no assumptions — interrogate the requirements first.** Before writing a
  plan, grill the user with pointed clarifying questions (use `AskUserQuestion`)
  about scope, edge cases (empty/null/boundary/large/duplicate inputs), failure
  and error behavior, concurrency, performance limits, security/validation, and
  testing expectations. Iterate until there are no blocking unknowns. Never guess
  to fill a gap; anything left undecided goes under "Open questions &
  assumptions", flagged. (A spawned subagent can't ask interactively, so
  interactive planning must run in the main conversation — the `/plan` command or
  simply asking to plan.)
- **Optimize for reuse** — search for existing code, utilities, and patterns and
  prefer reusing/extending them over new code; justify any new abstraction.
- **Follow software best practices** — DRY, SOLID, separation of concerns,
  testability, and consistency with existing conventions.
- Plans are design artifacts — do not modify source code while planning.
- The `/plan` command (`.claude/commands/plan.md`) runs this interactive workflow;
  conversational planning and built-in plan mode (shift+tab) follow these same
  CLAUDE.md rules.

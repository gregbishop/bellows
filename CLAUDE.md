# bellows

Spring Boot 4.1 / Java 25 (LTS) / Gradle **multi-module** project.

## Modules
- `bellows-core` — core **library** (plain `jar`, `bootJar` disabled). Holds the
  code for now; a runnable application module will be added later.

## Build & test
- `./gradlew build` — build + test all modules
- `./gradlew :bellows-core:test` — build/test a single module
- Root `build.gradle` is the aggregator and holds shared config (Java toolchain,
  repositories, plugins) applied to every module via `subprojects {}`. Per-module
  dependencies and packaging live in each module's own `build.gradle`.
- Java toolchain is **25 (LTS)**; dependency and plugin versions are managed in
  `gradle/libs.versions.toml` (Gradle version catalog).

## Conventions
- Commit messages follow **Conventional Commits** (template in `.gitmessage`).
- `main` is protected — changes go through pull requests (admin/owner bypass).
  PRs use `.github/pull_request_template.md`.
- **Every commit must pass the validation gate.** A git `pre-commit` hook
  (`.githooks/pre-commit`, enabled via `git config core.hooksPath .githooks`)
  runs `./gradlew check` and aborts the commit on failure. Add future checks
  there (or wire them into the Gradle `check` task). **Never bypass the gate** —
  `--no-verify`/`-n` and `core.hooksPath` overrides are blocked for the AI by a
  Claude `PreToolUse` hook (`.claude/hooks/block-commit-bypass.sh`). If
  validation fails, fix it. Use the `/commit` command for an ergonomic,
  gate-respecting commit.
- **Development is test-driven (TDD).** Write a failing test first, implement to
  green, then refactor. Production code is only written to satisfy a failing test.

## Development workflow (TDD)
Drive feature work with the `/tdd <task>` command, which orchestrates the dev
agents through a strict red-green-refactor cycle:

1. **Plan** — `/plan` produces an interactive, edge-case-grilled plan in
   `.agents/plans/` (input to TDD).
2. **Red** — `test-writer` writes failing tests under a module's `src/test/`
   (e.g. `bellows-core/src/test/`); never touches `src/main/`. `qa` checks the
   suite for gaps and loops back to add tests.
3. **Approve** — you review and approve the failing tests before any code.
4. **Green** — `implementer` writes module `src/main/` code until
   `./gradlew test` is green; it must NEVER modify tests.
5. **Refactor/verify** — `code-reviewer` (correctness + reuse/cleanup) and
   `security` (vulnerabilities) review the diff.

### Agents (`.claude/agents/`)
| Agent | Role | Writes |
| --- | --- | --- |
| `test-writer` | TDD red — failing tests | `**/src/test/**` only |
| `implementer` | TDD green — make tests pass | `**/src/main/**` only, never tests |
| `qa` | finds testing gaps | read-only |
| `code-reviewer` | correctness + reuse/cleanup review | read-only |
| `security` | security review | read-only |

The test/code separation is the core guardrail: the agent that writes code
cannot rewrite tests to pass. This is currently enforced by each agent's
instructions (prompt-level), not a hard sandbox.

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

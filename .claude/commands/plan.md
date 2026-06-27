---
description: Interactively plan a task — interrogate requirements & edge cases, then write a plan to .agents/plans/
argument-hint: <what to plan>
---

Plan the following task. Run this **interactively in this conversation** — your
job is to interrogate the requirements with me *before* writing anything. Do not
delegate this to a subagent (a subagent can't ask me questions).

Task: $ARGUMENTS

Process:

1. **Explore** the codebase read-only to ground yourself in what already exists.
   Actively prefer reusing existing code, utilities, and patterns.

2. **Grill me.** Before writing the plan, ask pointed clarifying questions (use
   the `AskUserQuestion` tool, batching related questions) until there are no
   blocking unknowns. Make NO assumptions — if you would otherwise have to
   guess, ask instead. Cover, where relevant:
   - Scope & success criteria — what is explicitly in and out of scope
   - Inputs/outputs and their contracts
   - Edge cases — empty/null/missing values, boundaries, large inputs, duplicates
   - Failure behavior — invalid input, downstream/timeout failures, retries
   - Concurrency, ordering, idempotency
   - Performance/scale expectations and limits
   - Security, authorization, validation, handling of sensitive data
   - Persistence/state and any migration or backward-compatibility concerns
   - Observability (logging/metrics) and testing expectations

   Iterate — ask follow-ups based on my answers. Don't stop after one round if
   gaps remain. Keep going until the design has no blocking ambiguity.

3. **Write the plan** only once requirements are clear, to
   `.agents/plans/<YYYY-MM-DD>-<kebab-topic>.md` (get the date with
   `date +%Y-%m-%d`), using this structure:
   Context / Approach / Reuse / Files to change / Open questions & assumptions /
   Verification. Apply software best practices (DRY, SOLID, separation of
   concerns, testability, consistency with existing conventions).

4. Do NOT modify source code — this is planning only. When done, report the plan
   file path and a 2–4 sentence summary.

If no task was provided above, ask me what to plan first.

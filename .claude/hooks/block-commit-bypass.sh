#!/usr/bin/env bash
#
# Claude Code PreToolUse hook (Bash). Prevents the AI from bypassing the commit
# validation gate (.githooks/pre-commit). Denies any `git commit` that skips
# hooks via --no-verify / -n, or overrides core.hooksPath.
#
# Exit 2 = block the tool call and surface stderr to the model.
#
input="$(cat)"

cmd="$(printf '%s' "$input" | python3 -c 'import sys, json
try:
    print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))
except Exception:
    print("")')"

# Only inspect git commit invocations.
if printf '%s' "$cmd" | grep -Eq '\bgit\b.*\bcommit\b'; then
	# Strip quoted strings so a commit message can't trigger a false positive.
	stripped="$(printf '%s' "$cmd" | sed -E "s/'[^']*'//g; s/\"[^\"]*\"//g")"
	if printf '%s' "$stripped" | grep -Eq '(--no-verify|(^|[[:space:]])-[A-Za-z]*n[A-Za-z]*([[:space:]]|$)|core\.hooksPath)'; then
		echo "Commit blocked: bypassing the validation gate is not allowed (--no-verify/-n or a core.hooksPath override). Commit normally so .githooks/pre-commit (./gradlew check) runs, or use the /commit skill. If validation fails, fix it — never bypass." >&2
		exit 2
	fi
fi

exit 0

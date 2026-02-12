---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Hardening

Securing the Claude Code environment. These are guardrails that prevent
costly mistakes — both accidental and from prompt injection.

## Quick Reference

1. **Block destructive commands** in settings.json deny rules
2. **Block access to sensitive files** — credentials, keys, wallets
3. **Fix every warning.** If you can't fix it, add an inline ignore with a justification
4. **Justify every new dependency.** Each one is attack surface and maintenance burden
5. **Use hooks to enforce rules** that shouldn't rely on the model's compliance

## Permission Deny Rules

Claude Code's `settings.json` supports deny rules that block specific
tool invocations. These are enforced before the model can act — they
don't depend on the model choosing to comply.

### Destructive Commands to Block

```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf *)",
      "Bash(rm -fr *)",
      "Bash(sudo *)",
      "Bash(mkfs *)",
      "Bash(dd *)",
      "Bash(curl *|bash*)",
      "Bash(wget *|bash*)",
      "Bash(git push --force*)",
      "Bash(git push *--force*)",
      "Bash(git reset --hard*)"
    ]
  }
}
```

These block the most common ways to irreversibly destroy data or escalate
privileges. The `curl|bash` and `wget|bash` patterns prevent piping
untrusted remote scripts directly into a shell.

### Sensitive Files to Block

```json
{
  "permissions": {
    "deny": [
      "Edit(~/.bashrc)",
      "Edit(~/.zshrc)",
      "Edit(~/.ssh/**)",

      "Read(~/.ssh/**)",
      "Read(~/.gnupg/**)",
      "Read(~/.aws/**)",
      "Read(~/.azure/**)",
      "Read(~/.config/gh/**)",
      "Read(~/.git-credentials)",
      "Read(~/.docker/config.json)",
      "Read(~/.kube/**)",
      "Read(~/.npmrc)",
      "Read(~/.pypirc)",
      "Read(~/.gem/credentials)"
    ]
  }
}
```

This prevents the model from reading credentials, cloud provider configs,
container orchestration configs, and package registry tokens. It also
prevents editing shell profiles, which could be used for persistence.

Adapt this list to your environment. If you use other credential stores
or tools with sensitive config files, add them.

## Pre-Tool-Use Hooks

Deny rules use glob patterns which can miss variations. Hooks run shell
commands that can do more sophisticated matching.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE 'rm[[:space:]]+-[^[:space:]]*r[^[:space:]]*f'; then echo 'BLOCKED: Use trash instead of rm -rf' >&2; exit 2; fi"
          },
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE 'git[[:space:]]+push.*(main|master)'; then echo 'BLOCKED: Use feature branches, not direct push to main' >&2; exit 2; fi"
          },
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE 'git[[:space:]]+commit[[:space:]]+--amend'; then echo 'BLOCKED: Do not amend commits. Create a new commit instead' >&2; exit 2; fi"
          },
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE '--no-verify'; then echo 'BLOCKED: Do not bypass pre-commit hooks' >&2; exit 2; fi"
          },
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE 'git[[:space:]]+(checkout|restore)[[:space:]]+\\.'; then echo 'BLOCKED: Wholesale discard of working changes. Use git stash or revert specific files' >&2; exit 2; fi"
          }
        ]
      }
    ]
  }
}
```

What each hook catches:

- **Dangerous deletions**: `rm -rf` regardless of flag ordering
- **Direct push to main**: Forces use of feature branches
- **Amending commits**: After a hook failure, amending modifies the *previous* commit instead of creating a new one. This silently destroys work
- **Bypassing hooks**: `--no-verify` should never be used
- **Discarding all changes**: `git checkout .` and `git restore .` wholesale discard working changes. Use `git stash` or revert specific files instead

## Verification

After setting up deny rules and hooks, test them. Ask the model to read a
blocked file (e.g. `~/.ssh/id_ed25519`) and confirm it's rejected. The
error should say "File is in a directory that is denied by your permission
settings" — the read is blocked before it reaches the filesystem.

One gotcha: hooks match against the full command string, including string
literals. A command like `echo 'rm -rf /tmp/test'` will trigger the
`rm -rf` hook even though it's just printing text. This is a minor
inconvenience when testing, but safe — false positives are better than
false negatives for destructive operations.

### Deny Rules and Allow Lists

Deny rules take precedence over project-level allow rules. A project can
have broad allows like `Bash(rm:*)` for routine file cleanup while global
deny rules still catch dangerous variants like `rm -rf`. This means you
can set up deny rules once globally and they'll protect every project,
regardless of how permissive that project's allow list is.

## Zero Warnings Policy

Fix every warning from every tool — linters, type checkers, compilers,
tests. A clean output is the baseline. Warnings that persist become
invisible, and real problems hide in the noise.

If a warning genuinely can't be fixed (rare), add an inline ignore with
a comment explaining why:

```python
x = something()  # noqa: E501 - URL too long to wrap
```

```rust
#[allow(clippy::too_many_arguments)]  // CLI flags map 1:1 to params
fn run(/* ... */) { }
```

Never leave warnings unaddressed. Never add blanket ignores at the project
level to suppress categories of warnings.

## Dependency Discipline

Every dependency is:
- **Attack surface** — a compromised or malicious package has access to
  everything your code does
- **Maintenance burden** — it needs updating, can introduce breaking changes,
  and may be abandoned
- **Complexity** — it adds to build times, lock file churn, and cognitive load

Before adding a dependency, ask:
1. Can this be done with the standard library in a reasonable amount of code?
2. Is this dependency well-maintained and widely used?
3. What's the transitive dependency tree? A "small" package with 50 transitive
   dependencies is not small
4. Do we actually need the full package, or just one function from it?

For security-sensitive projects, pin exact versions and verify hashes.
Run dependency audit tools (`pip-audit`, `pnpm audit`, `cargo deny`)
before deploying.

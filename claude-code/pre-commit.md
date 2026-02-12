---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Pre-Commit Checklist

Run through this before every commit.

## The Checklist

1. **Run the tests.** All of them. Not just the ones you think are relevant
2. **Read your diff** (`git diff --staged`). Look at every changed line. Are there changes you didn't intend?
3. **Check for unrelated changes.** If you fixed a typo you noticed while working, that's a separate commit
4. **Check for debugging leftovers.** Console.log, print statements, TODO comments you added while working, commented-out code
5. **Check for sensitive data.** No API keys, tokens, credentials, or .env files
6. **Does the commit message accurately describe what changed and why?** "Fix bug" is not a commit message. Neither is "update code"
7. **Are you on the right branch?**

## Commit Scope

Each commit should represent one coherent change. If you did three things, that's three commits. This makes history useful and reverts possible.

Good commit scope:
- "Add validation to user registration endpoint"
- "Fix off-by-one error in pagination"
- "Refactor database connection pool configuration"

Bad commit scope:
- "Various fixes and improvements"
- "Address review comments" (split by what each comment addressed)
- One commit with a new feature, a bug fix, and a refactor

## When Tests Fail

If tests fail, the commit doesn't happen. Don't skip tests to commit "work in progress" — use a WIP branch and commit with a clear WIP message that notes what's broken and why.

If a pre-commit hook fails, fix the issue and make a new commit. Don't amend the previous commit (which is a different commit entirely) and never bypass hooks.

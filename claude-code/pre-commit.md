---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Pre-Commit Checklist

Self-review discipline and the checklist to run before every commit.

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

## Self-Review

Before presenting your work, review it as if someone else wrote it. This is
different from the commit checklist — it's about the quality and correctness
of the work itself, not just the mechanics of committing.

### Did You Solve the Right Problem?

Re-read the original request. Does your change actually address what was asked?
It's easy to drift during implementation — solving a related problem, or
solving the right problem but with unnecessary extras. Compare your diff
against the original ask.

### Read Your Own Code Critically

Read every line of your diff and ask:

- Would this make sense to someone seeing it for the first time?
- Is there a simpler way to achieve the same thing?
- Are there edge cases you haven't considered?
- Did you match the surrounding code's patterns and style?
- Are your names clear and accurate?

### Check Your Scope

A common failure is delivering more than was asked for — extra error handling,
additional abstractions, "while I'm here" improvements. Each addition is a
potential source of bugs and review burden. If it wasn't asked for, take it
out.

### Verify, Don't Assume

If your change depends on how a library or API behaves, did you verify that
behaviour or assume it? If you refactored something, did you confirm all
callers still work? If you changed a test, did you verify it actually fails
without your fix?

"I think this works" is not the same as "I tested this and it works."

### The Final Question

Before declaring done, ask: "If I were reviewing this PR from someone else,
would I approve it?" If the honest answer is "I'd have questions," address
those questions first.

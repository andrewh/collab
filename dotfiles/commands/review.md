@description Self-review your changes before committing.

Review all staged and unstaged changes systematically. Do not skip steps.

## 1. Gather the changes

Run `git diff` and `git diff --staged` to see everything that will be committed. Read every changed file in full if you haven't read it recently.

## 2. Review in order

Evaluate in this order, from most expensive to fix to least:

### Architecture
- Is each change in the right place? Does it respect existing boundaries and patterns?
- Are there changes that should be in a different layer or module?

### Code quality
- Is the code clear, simple, and well-named?
- Is there duplication that should be factored out?
- Are there unnecessary abstractions or over-engineering?
- Does the style match the surrounding code?

### Tests
- Do tests cover the changes? Do they test behaviour, not implementation?
- Would the tests fail if the implementation were broken?
- Is test output clean?

### Performance
- Any obvious inefficiencies? Unnecessary allocations, N+1 queries, missing indexes?

## 3. Run the checklist

- [ ] No unrelated changes in the diff
- [ ] No debugging leftovers (print statements, console.log, TODO comments)
- [ ] No sensitive data (API keys, tokens, credentials)
- [ ] No commented-out code
- [ ] Commit message accurately describes what changed and why
- [ ] On the correct branch

## 4. Report

Summarise findings. For each issue found, state the file, the problem, and the fix. Then ask whether to fix the issues and commit, or just commit as-is.

---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Testing

How to write tests that actually catch bugs, and how to follow TDD without
cutting corners.

## Quick Reference

1. **Write the test first.** Run it. Watch it fail. Then write the code
2. **Test behaviour, not implementation.** If you can refactor without breaking tests, your tests are good
3. **Mocks isolate dependencies, not the thing under test.** If your test passes with the implementation deleted, it tests nothing
4. **One assertion per concept.** A test that checks five things is five tests crammed together
5. **Test output must be clean.** Expected errors must be captured and verified, not left spilling into logs

## TDD In Practice

The cycle is simple. The discipline is hard.

### 1. Write a Failing Test

Write a test that expresses what you want the code to do. Run it. It must
fail. If it passes, either your test is wrong or the feature already exists.

The failing test is your specification. It defines done.

### 2. Write the Minimum Code to Pass

Not the elegant code. Not the general code. The minimum code that makes
the red test green. Resist the urge to write ahead — the next test will
drive the next piece of design.

### 3. Refactor

Now that the test is green, clean up. Remove duplication, improve names,
simplify structure. Run the test after each change to make sure it stays
green.

### Where This Goes Wrong

**Skipping the failing test**: Writing the code first and then writing a test
that passes. This confirms the code does what it does, not what it should do.
If the code has a bug, the test will enshrine that bug.

**Writing too much test at once**: A test that checks an entire feature is
hard to write before the code exists. Start with the smallest piece of
behaviour. "Returns empty list when no items match" before "Full search with
pagination, filtering, and sorting."

**Writing too much code at once**: The test says "return the sum of two
numbers" and you build a generic calculator framework. Write exactly enough
to pass. The design will emerge from multiple small tests.

## What Makes a Good Test

### Tests Behaviour, Not Implementation

A good test describes what the code does from the outside, not how it
does it internally. It should survive refactoring — if you change the
implementation but the behaviour is the same, the test should still pass.

Bad: "calls the `processItem` method three times"
Good: "returns three processed results"

Bad: "stores data in the `_cache` dictionary"
Good: "returns cached result on second call without hitting the database"

### Has a Clear Name

The test name should describe the scenario and expected outcome. When it
fails, someone should understand what's broken from the name alone.

Bad: `test_process`
Good: `test_process_returns_error_when_input_is_empty`

Bad: `test_auth`
Good: `test_expired_token_is_rejected`

### Is Independent

Tests must not depend on each other or on execution order. Each test sets
up its own state, runs, and cleans up. Shared mutable state between tests
is a source of flaky failures and debugging nightmares.

### Fails for the Right Reason

When your initial test fails (before writing the implementation), read the
failure message. Is it failing because the behaviour is missing (correct) or
because of a setup error, import issue, or wrong assertion (incorrect)? A
test that fails for the wrong reason will pass for the wrong reason too.

## Mocking

Mocks are the most abused tool in testing. Used correctly, they isolate the
code under test from its dependencies. Used incorrectly, they replace the
code under test with a simulation of itself.

### When to Mock

- External services (HTTP APIs, databases, file systems) that are slow,
  unreliable, or have side effects
- Dependencies that are hard to set up but not what you're testing
- Boundaries between major components when testing one component in isolation

### When Not to Mock

- The thing you're testing. Ever
- Internal implementation details of the code under test
- Simple value objects, data structures, or pure functions
- Everything. If a test is 80% mock setup and 20% assertions, it's not
  testing your code

### The Litmus Test

Delete the implementation of the function under test and replace it with
`return None` (or equivalent). If your test still passes, it's testing the
mock, not the code.

## Testing Anti-Patterns

### Testing Mock Behaviour

```python
# Bad: this test proves the mock works, not the code
mock_db.get_user.return_value = User(name="Alice")
result = service.get_user(1)
assert result.name == "Alice"  # just echoes the mock setup
```

The assertion is checking that the mock returned what you told it to return.
The actual `get_user` implementation could be completely broken and this test
passes.

### Fragile Tests

Tests coupled to implementation details break every time you refactor, even
when behaviour is unchanged. This trains people to distrust and disable tests
— the opposite of their purpose.

Signs of fragility:
- Test breaks when you rename a private method
- Test checks exact call counts on internal methods
- Test asserts on specific log messages or output formatting
- Test depends on dictionary ordering or filesystem state

### Tests That Never Fail

A test that passes regardless of what the code does provides false
confidence. This often happens with overly broad assertions (`assert result
is not None`) or with tests that catch and swallow exceptions.

If you can't imagine a reasonable bug that would make your test fail, the
test isn't specific enough.

## Clean Test Output

Test output should be clean when tests pass. If expected errors show up in
the logs during test runs, either:

1. Capture and assert on them (proving the error handling works)
2. Suppress them explicitly in the test setup

Noisy test output hides real problems. When every test run produces a wall
of expected error messages, actual unexpected errors get lost in the noise.

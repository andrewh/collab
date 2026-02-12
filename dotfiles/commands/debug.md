@description Reset your debugging approach when stuck.

You are stuck. Stop what you're doing and follow this process from the top. Do not skip steps.

## 1. Stop and revert

If you have any failed fixes in the code, revert them now. Get back to a clean state where the only problem is the original bug.

Run `git diff` to confirm you're working from a clean baseline.

## 2. State the problem

Write out in plain language:
- What is the expected behaviour?
- What is the actual behaviour?
- What is the exact error message, if any? Copy it in full

## 3. Read the error

Read the complete error output again. Read stack traces bottom-to-top. Read any warnings that appeared before the error. Summarise what the error is actually telling you.

## 4. Reproduce

Confirm you can reproduce the issue reliably. If there's no minimal test case, write one now.

## 5. Find working examples

Search the codebase for similar working code. Compare it with the broken code. What's different?

## 6. Form one hypothesis

State a single, specific hypothesis: "the error is caused by X because Y."

Make the smallest possible change to test it. Run the test.

- If it works: clean up and move on
- If it doesn't: revert the change and return to step 5 with a new hypothesis

## 7. If two hypotheses have failed

Your mental model is wrong. Stop guessing and instead:
- Re-read the error message
- Check recent git history for what changed
- Read the relevant source code rather than guessing
- Ask for help: "I don't understand what's happening here"

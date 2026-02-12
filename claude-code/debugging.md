---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Debugging

How to debug effectively without spiralling.

## Quick Reference

1. **Read the error message.** Actually read it. The answer is often right there
2. **Reproduce it** reliably before investigating
3. **One hypothesis, one change, verify.** Never stack fixes
4. **If your fix didn't work, revert it** and re-analyse. Don't leave failed attempts in the code
5. **If you're stuck after two failed hypotheses**, stop and reconsider your mental model

## The Core Problem

The most common debugging failure is: make a guess, it doesn't work, make another guess on top of it, that doesn't work either, keep layering guesses until the code is an unrecognisable mess and you've lost track of what you were even trying to fix.

This happens because it *feels* productive to keep trying things. It isn't. Every failed fix you leave in place makes the next attempt harder.

## The Process

### 1. Actually Understand the Error

Read the full error output. Read stack traces bottom-to-top. Read log messages. Read warnings that appeared before the error. Don't skip past output because you think you already know the problem — you probably don't, or you'd have fixed it already.

### 2. Reproduce Consistently

If you can't reproduce it, you can't verify your fix. Write a minimal test case if one doesn't exist. If the issue is intermittent, figure out what makes it intermittent before trying to fix it.

### 3. Find Working Examples

Before forming a hypothesis, look for similar working code in the same codebase. Compare it with the broken code. The difference between working and broken is usually the answer, and it's far more reliable than guessing.

### 4. One Change at a Time

Form a single, specific hypothesis: "the error is caused by X because Y." Make the smallest possible change to test that hypothesis. Run the test. Did it work?

- **Yes**: You're done. Clean up and move on
- **No**: **Revert your change.** Your hypothesis was wrong. Leaving a wrong fix in place will confuse everything that follows

### 5. Know When to Stop and Rethink

If two hypotheses have failed, your mental model of the problem is likely wrong. Stop trying fixes and instead:

- Re-read the error message (it may mean something different now)
- Check what changed recently (git diff, git log)
- Question your assumptions about how the system works
- Read the relevant source code instead of guessing about its behaviour
- Ask for help. Saying "I don't understand what's happening here" is vastly better than a third guess

## Common Traps

**"I'll just add some defensive code"**: This is almost always a band-aid over a root cause. If something is null that shouldn't be null, find out why it's null. Don't add a null check and move on.

**"The tests are wrong"**: Sometimes they are. But if a test was passing before your change and fails after, the test is probably right. Understand what the test expects and why before deciding it's wrong.

**"It works on my machine"**: Look at environment differences. Dependencies, configuration, file paths, OS differences, timing issues. The code that "works" probably has a latent bug that only manifests in certain conditions.

**"Let me rewrite this whole thing"**: This is the nuclear option and it's almost never the right call during debugging. You'll introduce new bugs and lose whatever correctness existed. Fix the specific problem.

## Recovering from a Wrong Approach

Sometimes the problem isn't a bug — it's that you've gone down the wrong
path entirely. The design doesn't work, the approach was flawed, or you've
made a mess trying to force something that doesn't fit. The instinct is to
keep patching. The right move is to back out cleanly.

### Recognise When You're in a Hole

Signs that you should abandon the current approach rather than keep fixing it:

- You're fixing your fixes. Each change creates a new problem
- The code has grown significantly more complex than the task warrants
- You can no longer clearly explain what the code is doing or why
- You keep discovering new things that need to change to make it work

### Back Out Cleanly

If you've been committing frequently (and you should be), you have save
points:

- `git stash` or `git diff > backup.patch` if you want to preserve the
  work for reference
- `git checkout -- .` to return to the last commit (confirm with the user
  first — this discards uncommitted changes)
- `git log` to find the last known good state if you need to go further back

If you haven't been committing, the mess is harder to undo. This is why
frequent commits matter — they're not just for history, they're save points
you can revert to.

### Restart with What You Learned

A failed approach isn't wasted time if you learned something. Before
restarting, note:

- What specifically didn't work and why
- What you now understand about the problem that you didn't before
- What constraints the new approach needs to respect

Then start fresh from clean code. Don't carry forward fragments of the
failed attempt — they'll pull you back toward the same wrong path.

### The Hardest Part

The hardest part of recovery is admitting the approach is wrong. Twenty
minutes of work feels like too much to throw away. But twenty more minutes
of patching a broken approach is worse than restarting from a clean state
with better understanding. Cut your losses early.

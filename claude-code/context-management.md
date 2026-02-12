---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Context Management

How to stay effective across long sessions. This is one of the most
model-specific operational concerns — context window management directly
affects output quality.

## Quick Reference

1. **Read files before editing them.** Every time, no exceptions
2. **Don't hold code in your head.** Re-read it when you need it
3. **Use your tools to offload memory.** Todo lists, journal, git status — these are your external memory
4. **When things feel confused, stop and re-orient.** Re-read your task list, check git state, summarise where you are

## The Core Issue

Opus 4.6 has a large context window, but quality degrades as it fills. Early parts of the conversation become harder to draw on accurately. This isn't a catastrophic failure — it's a gradual drift where details get fuzzy, earlier decisions get forgotten, and you start reasoning from vague recollection instead of actual information.

The practical effect: in the first 20 minutes of a session, you're sharp and accurate. After 90 minutes of dense file reads and edits, you're working from increasingly unreliable memory of what you read earlier.

## Strategies That Actually Help

### Don't Trust Your Memory of File Contents

If you read a file 30 turns ago, you don't reliably remember its contents. Re-read it before editing. This feels wasteful but prevents a class of errors where you edit based on what you think the file looks like rather than what it actually says.

The same applies to test output, error messages, and command results from earlier in the session. If you need to reference them, re-run the command.

### Keep Context Clean

- Read only the files you need, not entire directories out of curiosity
- When exploring a codebase, use targeted searches (grep, glob) rather than reading everything
- If you've read a large file but only need a few lines, note the specific lines rather than keeping the whole file in working memory

### Use External Memory Aggressively

Your working memory is unreliable across a long session. Your tools are not:

- **Todo list**: Track what you're doing, what's done, what's next. Check it regularly
- **Journal**: Write down decisions, hypotheses, and observations before you forget them
- **Git**: Commit frequently. `git status` and `git diff` tell you the actual state of things, not what you remember the state being
- **Auto-memory files**: Record cross-session insights so future instances don't repeat your mistakes

### Recognise When You're Degrading

Signs that you're losing the thread:
- You're about to edit a file you haven't read recently
- You can't clearly state what the current task is
- You're making changes that feel right but you can't explain why
- You're repeating an approach that already failed earlier in the session
- You're confused about what state the code is in

When you notice these signs, stop and re-orient:
1. Check git status
2. Re-read your todo list
3. Re-read the most recent relevant files
4. Summarise where you are and what's next before continuing

## Parallel Tool Use

Opus 4.6 can make multiple independent tool calls simultaneously. Use this:

- Read multiple files at once when exploring
- Run independent commands in parallel (e.g. git status and git log)
- Search with multiple patterns simultaneously

But don't parallelise dependent operations — if you need one result to inform the next call, do them sequentially.

## When to Suggest a Fresh Session

Sometimes the most productive thing is to acknowledge that a session has become too long and cluttered. If you've been working for a long time and things are getting confused, say so. A fresh session with a clear brief is often faster than continuing to fight context degradation.

Before ending, make sure your state is captured: commit work in progress, update your todo list, write notes about where you are and what's next.

---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Tool Use Patterns

Concrete patterns for using Claude Code's tools effectively. The difference
between a productive session and a frustrating one often comes down to
disciplined tool use.

## Quick Reference

1. **Always read before editing.** No exceptions
2. **Use dedicated tools, not bash workarounds.** Read not cat, Edit not sed, Grep not grep
3. **Run tests after every meaningful change.** Don't batch changes and test at the end
4. **Search before writing.** Check for existing patterns, utilities, and conventions
5. **Parallelise independent operations.** Read multiple files at once, run independent commands together

## Read Before Edit — The Non-Negotiable Rule

Never edit a file you haven't read in the current session. Never edit a file based on memory of what it contains from earlier in the session if significant work has happened since.

This prevents:
- Editing code that has changed since you last looked at it
- Writing edits based on incorrect assumptions about indentation, variable names, or structure
- Failing edits because the string you're trying to replace doesn't match

## Search Before Write

Before writing new code, always search for:
- **Existing utilities** that do what you're about to implement
- **Existing patterns** for the kind of thing you're building (how does the codebase handle errors? How are tests structured? How are configs loaded?)
- **Naming conventions** so your additions are consistent

Use Grep for content searches, Glob for file pattern searches. For broader exploration, use the Explore agent. The few seconds spent searching saves minutes of writing code that doesn't fit.

## Test Continuously

Run tests after every meaningful change, not after a batch of changes. When multiple changes are stacked up and a test fails, you don't know which change broke it.

The cycle should be:
1. Make one change
2. Run relevant tests
3. If tests pass, continue
4. If tests fail, fix before making more changes

## Use the Right Tool

Opus 4.6 has access to dedicated tools that are better than their bash equivalents:

| Instead of | Use |
|---|---|
| `cat`, `head`, `tail` | Read tool |
| `sed`, `awk` | Edit tool |
| `grep`, `rg` | Grep tool |
| `find`, `ls` | Glob tool |
| `echo >`, heredoc | Write tool |

The dedicated tools handle permissions correctly, integrate with the conversation context, and don't pollute the context window with raw command output.

## Effective Searching

### Targeted Searches

Start narrow and widen if needed:
1. If you know the filename: `Glob` with specific pattern
2. If you know a string in the file: `Grep` with literal string
3. If you need to understand a subsystem: Explore agent with a clear question

### Avoid Reading Everything

It's tempting to read lots of files "for context." Resist this. Each file you read consumes context window and dilutes your focus. Read what you need for the specific task.

## Git as a Safety Net

Use git operations liberally:
- `git status` to verify your understanding of what's changed
- `git diff` to review changes before committing (catches unintended modifications)
- `git stash` when you need to check something on a clean tree
- Frequent commits as save points you can return to

## Subagents

The Task tool launches sub-agents — workers that run within your session
with their own context window. They do work and report results back.

| Type | Use for |
|---|---|
| **Explore** | Broad codebase search and understanding |
| **Plan** | Designing implementation approaches |
| **Bash** | Shell operations (builds, system commands) |
| **go-expert-developer** | Go-specific implementation and review |
| **paranoid-pr-reviewer** | Thorough code review after writing code |
| **general-purpose** | Multi-step tasks that don't fit other types |

Launch multiple sub-agents in the same message to run them in parallel.
This is valuable for parallel research, isolating verbose output from
your main context, and investigating competing hypotheses.

Don't use sub-agents for simple, directed searches — a single Grep or
Glob call is faster and keeps the result in your main context.

For parallelising implementation work across multiple agents, see
[parallel-work.md](parallel-work.md).

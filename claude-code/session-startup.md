---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Session Startup

What to do in the first few minutes of any project session.

## Quick Reference

1. **Check git state** before touching anything: `git status`, `git branch`, `git log --oneline -5`
2. **If there's uncommitted work or untracked files**, stop and ask how to handle them
3. **Read project docs**: CLAUDE.md, README, and any contributing guides
4. **Find the build/test/lint commands** and confirm they work. Run the tests once to establish a baseline
5. **Understand where you are**: what branch, what's the current state of work, is there a PR in flight?
6. **If there's no git repo**, ask before initialising one
7. **If there's no clear branch for your task**, create one before making changes

## Why This Matters

The most expensive mistakes happen in the first few minutes. Starting to code without orienting leads to:
- Overwriting someone's uncommitted work
- Building on a broken baseline without realising it
- Duplicating effort that's already in progress on another branch
- Making changes on the wrong branch

## Orienting on an Unfamiliar Codebase

When you're new to a project, resist the urge to start reading every file. Instead:

1. Read the CLAUDE.md and README first — they exist to save you time
2. Look at the project structure: what's the language, what's the build tool, where are the tests?
3. Run the tests. If they pass, you have a working baseline. If they fail, that's critical information
4. Look at recent git history to understand what's been worked on and the style of commit messages
5. Find one representative feature or module and read it end-to-end to understand the patterns

Don't try to understand everything before starting. Understand enough to avoid breaking things, then learn as you go.

## Starting a Task

Before writing any code:

1. Make sure you understand what's being asked. If anything is ambiguous, ask
2. Check whether there are existing tests, patterns, or utilities relevant to your task
3. Think about the smallest change that achieves the goal
4. If the task is non-trivial, think through your approach before writing code. For significant work, propose a plan and get agreement before implementing

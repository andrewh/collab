@description Orient on the project before starting work. Run this at the beginning of every session.

Do not start any implementation work until this checklist is complete.

## 1. Check git state

Run `git status`, `git branch`, and `git log --oneline -5`. Report:
- Current branch
- Whether there are uncommitted changes or untracked files
- The last few commits for context

If there are uncommitted changes or untracked files, STOP and ask how to handle them before proceeding.

## 2. Read project documentation

Read the project's CLAUDE.md if one exists. Also check for README.md and any contributing guides. Note the build, test, and lint commands.

## 3. Read remote guides

Fetch and read these operational guides:
- https://raw.githubusercontent.com/andrewh/collab/main/claude-code/session-startup.md
- https://raw.githubusercontent.com/andrewh/collab/main/claude-code/common-mistakes.md

## 4. Establish a baseline

Run the project's test suite. Report whether tests pass or fail. If they fail, note which tests and why — this is the baseline, not something to fix immediately.

## 5. Report

Summarise:
- Branch and git state
- Build/test/lint commands found
- Test baseline (passing or failing, and what's failing)
- Anything notable from the project docs

Then ask what we're working on today.

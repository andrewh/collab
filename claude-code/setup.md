---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Setup

How to use these guides in your projects.

## Quick Start

Add this to your project's CLAUDE.md:

```markdown
## Remote Guides

At the start of each session, read the following files from the collaboration
repo for operational guidance:

- https://raw.githubusercontent.com/andrewh/collab/main/claude-code/session-startup.md
- https://raw.githubusercontent.com/andrewh/collab/main/claude-code/common-mistakes.md

Follow the session startup checklist before beginning work.
```

Claude Code will fetch and read these URLs when instructed. Pick the files
relevant to your workflow — you don't need to load all of them every session.

## Recommended Loadouts

### Every Session
- `session-startup.md` — Orient before coding
- `common-mistakes.md` — Know the failure patterns

### For Longer or Complex Sessions
Add:
- `context-management.md` — Manage degradation over time
- `debugging.md` — When things go wrong

### For Writing CLAUDE.md Files or Agent Instructions
- `prompting.md` — What linguistic patterns work with Opus 4.6

### For Reviewing Work
- `pre-commit.md` — Before committing
- `tool-use.md` — Effective tool patterns

## Alternative: Git Submodule

If you want the files available locally without network fetches:

```bash
git submodule add https://github.com/andrewh/collab.git .collab
```

Then reference them in your CLAUDE.md:

```markdown
## Remote Guides

Read the following files at the start of each session:
- .collab/claude-code/session-startup.md
- .collab/claude-code/common-mistakes.md
```

To update: `git submodule update --remote`

## Alternative: Local Clone

Clone the repo to a fixed location and reference it by absolute path:

```bash
git clone https://github.com/andrewh/collab.git ~/src/collab
```

```markdown
## Remote Guides

Read the following files at the start of each session:
- ~/src/collab/claude-code/session-startup.md
- ~/src/collab/claude-code/common-mistakes.md
```

This is the simplest option if you work on one machine and want all projects
to share the same guides without submodules.

## Notes

- You don't need to load every file every session. Pick what's relevant
- Loading too many files at session start consumes context window — be selective
- The guides are written to be useful both as startup checklists (skim the quick reference) and mid-session course corrections (read the detail)
- If you're using these with a model other than Opus 4.6, the operational guides (debugging, pre-commit, session startup) are model-agnostic. The prompting and context management guides are Opus 4.6-specific

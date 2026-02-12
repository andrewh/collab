# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A public repository of collaboration notes and instructions for AI agents (Claude Code, Codex, Copilot, Amp, etc.). It is consumed live by agents during sessions across other projects.

The goal is consistent agent session setup across projects, with improvements saved and compounded over time.

## Structure

This is a documentation-only repository. There is no build system, no tests, and no application code.

- `claude-code/` — Operational guides for Claude Code sessions
  - `session-startup.md` — What to do in the first few minutes of a session
  - `debugging.md` — How to debug without spiralling
  - `pre-commit.md` — Self-review and checklist before every commit
  - `common-mistakes.md` — Patterns Claude Code actually falls into, with corrections
  - `context-management.md` — Managing context window and working memory across long sessions
  - `tool-use.md` — Patterns for effective tool use in Claude Code
  - `prompting.md` — Linguistic patterns that work (and don't) with Opus 4.6
  - `testing.md` — TDD discipline, mocking, and testing anti-patterns
  - `communication.md` — When to ask vs. proceed, reporting progress, pushing back
  - `creativity.md` — Getting past the default convergent mode into genuine exploration
  - `working-with-models.md` — Matching models to tasks and adapting instructions by capability
  - `hardening.md` — Securing the Claude Code environment: deny rules, hooks, warnings, dependencies
  - `writing-claude-md.md` — How to write effective CLAUDE.md files
  - `setup.md` — How to use these guides in your projects

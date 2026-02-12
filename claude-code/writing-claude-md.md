---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Writing CLAUDE.md Files

How to write a CLAUDE.md that actually makes Claude Code more effective on
your project. Most of the value comes from a small amount of well-chosen
information. Most of the bloat comes from including things the model can
figure out on its own.

## Quick Reference

1. Build, test, and lint commands — the single most valuable thing you can include
2. Project-specific conventions that aren't obvious from the code
3. Architectural context that requires reading multiple files to understand
4. Keep it under 150 lines. Link to separate files for detail
5. Leave out anything Claude Code can discover by reading the codebase

## What to Include

### Build, Test, and Lint Commands

This is the highest-value content in any CLAUDE.md. Without it, Claude Code
has to guess or search for how to build and test your project. Include:

- How to build the project
- How to run the full test suite
- How to run a single test (this is used constantly and often non-obvious)
- How to lint or format
- Any setup steps required before the above work (installing dependencies, etc.)

Be specific. Not "run the tests" but the actual command:

```markdown
## Commands

- Build: `make build`
- Test all: `go test ./...`
- Test single: `go test ./pkg/auth/ -run TestTokenExpiry`
- Lint: `golangci-lint run`
- Format: `gofmt -w .`
```

If different parts of the project have different commands (e.g. a Go backend
and a TypeScript frontend), list them separately with clear labels.

### Project Conventions That Aren't Obvious

Things that a competent developer wouldn't know just from reading the code:

- Error handling patterns specific to this project
- How configuration is loaded and where it lives
- Naming conventions that differ from language defaults
- Where new files of a given type should go
- How the project handles database migrations
- Environment variables required for development

Don't include conventions that are obvious from the language or framework
(e.g. "use camelCase in JavaScript" or "put tests in `_test.go` files").

### Architectural Context

The "big picture" that requires reading multiple files to understand:

- How the main components connect (e.g. "the CLI calls the API client, which
  calls the service layer, which calls the repository")
- Where the important boundaries are (e.g. "the `internal/` package is not
  meant to be imported by external consumers")
- Non-obvious data flow (e.g. "events are published to the queue by the API
  and consumed by the worker service")
- Key design decisions and their rationale, if not obvious

Keep this to a few sentences or a short list. If the architecture is complex
enough to need a full document, put that in a separate file and link to it.

### Gotchas and Traps

Things that will bite Claude Code if not warned about:

- Files or directories that look editable but are generated
- Tests that require specific setup or environment (e.g. a running database)
- Packages with confusingly similar names
- Areas of the codebase that are particularly fragile

## What to Leave Out

### Anything Discoverable from the Code

Claude Code can read your files. It doesn't need you to list every directory,
describe what each module does, or explain standard patterns. It will figure
these out by reading the code — and the description in the CLAUDE.md will be
less accurate than the code itself.

### Generic Development Practices

"Write clean code", "handle errors properly", "write tests for new features"
— these add noise without information. If you have specific standards (e.g.
"all errors must be wrapped with `fmt.Errorf` and include context"), include
those. Otherwise, leave general practices out.

### Redundant Information from README

If your README already explains setup, don't repeat it in CLAUDE.md. Either
reference the README or move the developer-facing commands into CLAUDE.md and
keep the README for human-facing documentation.

### Overly Detailed Style Guides

"Use 2-space indentation, always use trailing commas, prefer const over let"
— this is what linters and formatters are for. If you have a linter config,
Claude Code will learn the style from linter output. If you don't, Claude Code
will match the existing code style. A page of formatting rules in CLAUDE.md is
wasted context.

The exception: style choices that a linter can't enforce, like naming patterns
or code organisation preferences.

## Structure

### Ordering

Put the most frequently needed information first:

1. **Commands** (build, test, lint) — used every session
2. **Key conventions** — needed when writing code
3. **Architecture overview** — needed when orienting
4. **Gotchas** — needed when things go wrong

### Length

Aim for under 150 lines. Every line competes for attention in the context
window. A 300-line CLAUDE.md means the instructions at the bottom get
significantly less weight than those at the top (see prompting.md for why).

If you need more detail, use separate files:

```markdown
## Architecture

See [docs/architecture.md](docs/architecture.md) for detailed system design.
```

### Layering

Claude Code supports CLAUDE.md files at multiple levels:

- **Global** (`~/.claude/CLAUDE.md`): Personal preferences that apply to all projects
- **Project root** (`CLAUDE.md`): Project-specific guidance
- **Subdirectories** (`frontend/CLAUDE.md`): Component-specific guidance

Use this to keep each file focused. Your global file handles your personal
style preferences; the project file handles build commands and architecture;
subdirectory files handle component-specific conventions.

Don't duplicate between layers. If your global file says "use British English
spelling", the project file doesn't need to repeat it.

## A Minimal Example

```markdown
# CLAUDE.md

## Commands

- Install: `npm install`
- Dev server: `npm run dev`
- Test all: `npm test`
- Test single: `npm test -- --grep "test name"`
- Lint: `npm run lint`
- Format: `npm run format`

## Architecture

Express API server with React frontend. API routes are in `src/routes/`,
business logic in `src/services/`, database access in `src/repositories/`.

The frontend is a separate build in `frontend/` that talks to the API.
Auth uses JWT tokens stored in httpOnly cookies.

## Conventions

- All API errors return `{ error: string, code: string }` shape
- Database queries go through repositories, never called directly from routes
- Environment config is loaded in `src/config.ts` — add new variables there
- Migration files in `migrations/` are generated with `npm run migrate:create`

## Gotchas

- `src/generated/` is auto-generated from the OpenAPI spec — don't edit directly
- Integration tests require `docker compose up -d` for the test database
```

That's about 30 lines and covers everything Claude Code needs to be productive
immediately.

## See also

- [Setup](setup.md) — how to deploy and use these guides across your projects
- [Prompting](prompting.md) — linguistic patterns that work well with Claude models; relevant for phrasing CLAUDE.md instructions effectively
- [Context Management](context-management.md) — managing context window usage; CLAUDE.md length and organisation affect how well instructions land

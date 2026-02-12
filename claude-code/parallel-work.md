---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Parallel Work

How to run work concurrently in Claude Code. There are three approaches,
from lightweight to fully independent, and choosing the right one matters
more than the parallelism itself.

## Quick Reference

1. **Pick the right mechanism.** Sub-agents for research and exploration, agent teams for complex implementation, manual worktrees for fully independent work
2. **When creating issues, think parallel by default.** Consider how the work could be split across concurrent instances
3. **Each work item must touch different files.** Shared files cause merge conflicts (worktrees and agent teams) or confused state (sub-agents writing to the same file)
4. **Define interfaces up front.** Parallel work that integrates later needs agreed contracts
5. **Work items must be self-contained.** Include enough context to work autonomously
6. **Integration is its own task.** Don't assume parallel work will merge cleanly

## Choosing an Approach

| | Sub-agents | Agent teams | Manual worktrees |
|---|---|---|---|
| **What** | Task tool workers within one session | Multiple Claude Code instances with shared task list | Separate Claude Code sessions on separate branches |
| **Concurrency** | Parallel within one conversation | Independent processes, can message each other | Fully independent, no communication |
| **File writes** | Share the working directory — coordinate carefully | Each gets its own worktree | Each gets its own worktree |
| **Context** | Report results back to the parent | Shared task list, separate contexts | No shared state |
| **Best for** | Research, exploration, isolating verbose output | Complex multi-part implementation | Independent features, different repos |
| **Limitations** | Write conflicts if not careful; sub-agent results are summarised, not verbatim | Experimental; requires careful task decomposition | No communication during execution |

### Use sub-agents when...

- You need to research multiple things at once (check docs, search code, read files)
- You want to isolate verbose output from your main context (large search results, long build output)
- You're exploring multiple hypotheses and want to pursue them in parallel
- The work is primarily reading and analysis, not writing files

### Use agent teams when...

- You need multiple instances writing code in parallel on the same project
- The work is complex enough that each part needs its own full context window
- You want instances to coordinate via a shared task list
- You're comfortable with an experimental feature

### Use manual worktrees when...

- Work items are fully independent and don't need coordination
- You're working across different repositories
- You want the simplest mental model: separate branches, separate sessions, merge later

## Sub-agents

Sub-agents are workers you launch with the Task tool. They run within
your session, can use most tools, and report results back. They're the
lightest-weight parallelism option.

### How they work

Each sub-agent gets its own context window and tool access. You describe
what you want, it does the work, and returns a summary. Multiple
sub-agents can run concurrently — launch them in the same message.

```
# Launch two research tasks in parallel (single message, two Task calls)
Task: "Search for all usages of validateToken across the codebase"
Task: "Read the auth middleware and summarise how sessions are managed"
```

### Practical patterns

**Parallel research**: When you need to understand multiple parts of a
codebase before making changes, launch Explore agents for each area
simultaneously rather than searching sequentially.

**Isolating verbose output**: Sub-agent results are summarised before
returning. This is useful when a search would return hundreds of matches
— the sub-agent reads them all but only the relevant findings enter your
context.

**Competing hypotheses**: When debugging, you can launch multiple agents
to investigate different theories in parallel. The one that finds the
answer reports back; the others' work doesn't clutter your context.

**Pre-implementation review**: Before a complex change, launch a
paranoid-pr-reviewer agent to audit your plan while you continue other
preparation work.

### Sub-agent types

| Type | Use for |
|---|---|
| **Explore** | Codebase search and understanding. Fast, read-only |
| **Plan** | Designing implementation approaches |
| **Bash** | Shell operations (builds, deployments, system commands) |
| **go-expert-developer** | Go-specific implementation and review |
| **paranoid-pr-reviewer** | Thorough code review |
| **general-purpose** | Multi-step tasks that don't fit other types |

### When sub-agents don't help

- **Writing to the same files**: Sub-agents share the working directory.
  Two agents editing the same file will produce unpredictable results.
  If sub-agents need to write, give each one distinct files
- **Dependent operations**: If task B needs the output of task A, they
  can't run in parallel. Launch A, wait for results, then launch B
- **Small tasks**: A single Grep or Glob call is faster than spawning a
  sub-agent for it. Don't add overhead for trivial lookups

## Agent Teams

Agent teams are multiple Claude Code instances that share a task list
and can send messages to each other. Each instance gets its own worktree,
avoiding file conflicts.

**Status**: This feature is experimental. The interface may change.

### How they work

You decompose work into tasks using TaskCreate, then launch additional
Claude Code instances that pick up tasks from the shared list. Instances
coordinate through the task list (TaskCreate, TaskUpdate, TaskList) and
can leave notes for each other in task descriptions.

### When to use them

- Implementing a feature that spans multiple modules where each module
  needs significant work
- Exploring competing approaches where each approach requires building
  a prototype
- Cross-layer work (frontend, backend, database) where each layer is
  substantial enough to warrant its own context window

### Key considerations

- Decompose tasks clearly — each task should specify exactly what files
  to create or modify and what interfaces to follow
- All the decomposition guidance in this document applies to agent teams
- Tasks need enough context to be worked independently, since each
  instance has its own context window
- Plan for integration — work done in separate worktrees still needs to
  be merged

## Manual Worktrees

The most independent approach: separate Claude Code sessions working on
separate git worktrees. No shared state, no communication during
execution.

### Setup

Each parallel instance must work in isolation:

- **Separate branches**: Each item gets its own branch from the same base
- **Worktrees** (preferred): `git worktree add ../project-item-1 -b feat/item-1`
  lets each instance have its own working directory without cloning
- **Never share a working directory**: Two instances modifying the same
  checkout will corrupt each other's state

After parallel work completes, merge branches sequentially and resolve
any conflicts in the integration task.

## Decomposing Work

The decomposition guidance below applies to all three approaches. Even
sub-agents benefit from clear scoping, though the stakes are lower
since they typically read rather than write.

### The Core Constraint

Parallel instances can't communicate with each other during execution.
They can't ask "what did you name that function?" or "did you change the
config format?" Every decision that affects another instance's work must
be made before the work begins.

This means the decomposition phase is critical. Time spent on good work
item design is repaid many times over in avoided conflicts and rework.

### Find Natural Boundaries

Good parallel splits follow existing architectural boundaries:

- **By module or package**: Instance A works on auth, instance B works on billing
- **By layer**: Instance A works on the API endpoints, instance B works on the database migrations
- **By feature area**: Instance A adds the search UI, instance B adds the export endpoint
- **By type of work**: Instance A writes the implementation, instance B writes the tests (only when the interface is already defined)

### Identify Shared Files

Before splitting work, identify files that multiple items would need to
modify. Common culprits:

- **Config files**: `package.json`, `pyproject.toml`, `go.mod`
- **Route registrations**: Central routers or app setup files
- **Type definitions**: Shared types, interfaces, or schemas
- **Test fixtures**: Shared test setup or factory files
- **Index files**: Barrel exports, `__init__.py`, module registries

If two work items need to modify the same file, either:
1. Assign that file to one item and have the other work around it
2. Create a preceding task that makes the shared changes first
3. Combine the items — they're not truly independent

### Define Contracts

When parallel work will integrate later, define the integration points
before starting:

- Function signatures and return types
- API endpoint paths and request/response shapes
- Database table schemas and column names
- Event names and payload formats
- File paths and naming conventions

Write these contracts down in the work items. "Instance A will export a
`validateToken(token: string): Promise<User | null>` from
`src/auth/validate.ts`" is specific enough to build against. "Instance A
will handle auth validation" is not.

### Writing Good Parallel Work Items

Every work item for parallel execution should include:

1. **Clear scope**: Exactly which files to create or modify
2. **Context**: What the broader task is and how this item fits in
3. **Contracts**: Any interfaces, types, or conventions to follow
4. **Constraints**: What not to touch, to avoid conflicts with other items
5. **Verification**: How to test this item independently (it must be testable in isolation)

### Example: Good Decomposition

Task: "Add user profile editing with avatar upload"

**Item 1: Avatar storage service** (branch: `feat/avatar-storage`)
- Create `src/services/avatar.ts`
- Create `src/services/avatar.test.ts`
- Exports: `uploadAvatar(userId: string, file: Buffer): Promise<string>` (returns URL)
- Exports: `deleteAvatar(userId: string): Promise<void>`
- Uses S3 bucket configured via `AVATAR_BUCKET` env var
- Do not modify any existing files

**Item 2: Profile API endpoints** (branch: `feat/profile-api`)
- Create `src/routes/profile.ts`
- Create `src/routes/profile.test.ts`
- `PUT /api/profile` — update name, bio, email
- `POST /api/profile/avatar` — calls avatar service (import from `src/services/avatar.ts`)
- Assumes avatar service exports the signatures above
- Do not modify existing route files; integration into the router will be done separately

**Item 3: Profile edit UI** (branch: `feat/profile-ui`)
- Create `src/components/ProfileEditor.tsx`
- Create `src/components/ProfileEditor.test.tsx`
- Calls `PUT /api/profile` and `POST /api/profile/avatar`
- Do not modify existing components

**Item 4: Integration** (after items 1-3 merge)
- Register profile routes in `src/routes/index.ts`
- Add `AVATAR_BUCKET` to `.env.example`
- Add navigation link in `src/components/Nav.tsx`
- Run full test suite

### Example: Bad Decomposition

**Item 1**: "Build the backend for profiles"
**Item 2**: "Build the frontend for profiles"

This fails because: no contracts defined, both items probably need to
modify shared config, scope is vague, and "backend" likely includes
route registration which conflicts with any other backend work.

## Think Parallel When Creating Issues

Whenever you're asked to create GitHub issues or break down a task into
work items, consider parallelism as part of the decomposition. Don't
just list what needs doing — think about which items could run
concurrently and structure them accordingly.

This means:
- Label which issues can be worked in parallel vs. which are sequential
- Include the contracts and file boundaries in the issue descriptions
- Call out the integration step explicitly as its own issue
- Note dependencies between issues so the execution order is clear

Even if parallel execution isn't the immediate plan, issues structured
this way are clearer and better scoped than a flat task list.

## When Not to Parallelise

Some tasks are inherently sequential:

- **Exploratory work**: You don't know enough to decompose yet
- **Tightly coupled changes**: A database migration and the code that depends on it
- **Refactoring**: Changes that ripple across the codebase
- **Debugging**: You need to understand the problem before you can split the fix

If you find yourself writing elaborate contracts and constraints to make
a split work, the task probably shouldn't be parallelised. The overhead
of coordination can exceed the time saved.

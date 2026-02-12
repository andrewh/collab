---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Parallel Work

How to decompose tasks so multiple Claude Code instances can work
concurrently without conflicts. This applies whether you're creating
GitHub issues, todo items, or any other work breakdown for parallel
execution.

## Quick Reference

1. **When creating issues, think parallel by default.** Consider how the work could be split across concurrent instances
2. **Each work item must touch different files.** Shared files cause merge conflicts
3. **Define interfaces up front.** Parallel work that integrates later needs agreed contracts
4. **Each instance needs its own branch or worktree.** Never share a working directory
5. **Work items must be self-contained.** Include enough context to work autonomously
6. **Integration is its own task.** Don't assume parallel work will merge cleanly

## The Core Constraint

Parallel instances can't communicate with each other during execution.
They can't ask "what did you name that function?" or "did you change the
config format?" Every decision that affects another instance's work must
be made before the work begins.

This means the decomposition phase is critical. Time spent on good work
item design is repaid many times over in avoided conflicts and rework.

## Decomposing Work

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

## Writing Good Parallel Work Items

### What Each Item Needs

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

## Branch and Worktree Strategy

Each parallel instance must work in isolation:

- **Separate branches**: Each item gets its own branch from the same base
- **Worktrees** (preferred): `git worktree add ../project-item-1 -b feat/item-1`
  lets each instance have its own working directory without cloning
- **Never share a working directory**: Two instances modifying the same
  checkout will corrupt each other's state

After parallel work completes, merge branches sequentially and resolve
any conflicts in the integration task.

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

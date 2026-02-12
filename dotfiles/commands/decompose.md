@description Break a task into parallel work items for concurrent Claude Code instances.
@arguments $TASK: Description of the task to decompose

Analyse the following task and produce a set of work items that can be executed by parallel Claude Code instances.

Task: $TASK

## 1. Understand the scope

Read relevant code to understand the codebase structure, existing patterns, and architectural boundaries. Identify the files and modules involved.

## 2. Identify shared files

List every file that multiple work items would need to modify. These are conflict points:
- Config files, route registrations, type definitions
- Test fixtures, index/barrel files, module registries
- Any file that acts as a central registry or entry point

## 3. Define the split

Break the task into independent work items along natural boundaries (by module, layer, or feature area). Each item MUST:
- Touch different files from every other item
- Be testable in isolation
- Include enough context to work autonomously

If two items need to modify the same file, either assign that file to one item, create a preceding task for the shared changes, or combine the items.

## 4. Define contracts

For each integration point between items, specify:
- Function signatures and return types
- API endpoint paths and request/response shapes
- Database schemas
- File paths and naming conventions

## 5. Output

For each work item, produce:

```
### Item N: [title]
Branch: [branch name]
Files to create/modify: [list]
Do not touch: [list of files reserved for other items]
Contract: [interfaces this item must satisfy]
Tests: [how to verify in isolation]
Description: [what to implement and how]
```

Then list:
- Which items can run in parallel
- Which items depend on others (and why)
- An integration item that merges everything and handles shared files

## 6. Sanity check

For each item, confirm: could a Claude Code instance complete this with no access to the other items' branches and no ability to ask questions? If not, add the missing context.

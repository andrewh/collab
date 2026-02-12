---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Working With Different Models

How to match models to tasks and adapt your instructions accordingly.
Written from Opus 4.6's perspective — the Claude model comparisons are
first-hand, the cross-family observations are informed but less
authoritative.

## Quick Reference

1. **Match the model to the task.** Don't use Opus for simple lookups; don't use Haiku for architecture
2. **Simpler models need more structured instructions.** What Opus infers, Haiku needs spelled out
3. **All models benefit from the same fundamentals**: clear instructions, concrete examples, structured format
4. **Switch models when you notice diminishing returns**, not as a first resort

## Claude Model Comparison

### Opus

Best for tasks requiring deep reasoning, nuance, and complex
multi-step work.

**Strengths:**
- Complex architectural decisions with many trade-offs
- Debugging subtle issues that require understanding multiple interacting systems
- Tasks requiring careful judgement (code review, design evaluation)
- Long, multi-step tasks where maintaining coherence matters
- Nuanced communication — pushing back, calibrating confidence, asking good questions
- Creative exploration and divergent thinking

**Weaknesses:**
- Slower and more expensive — overkill for simple tasks
- Can over-think straightforward problems
- May produce more elaborate solutions than needed when a simple one would do

**When to use:** Architecture decisions, complex debugging, code review,
creative design work, tasks where getting it wrong is expensive.

### Sonnet

The workhorse. Good balance of capability, speed, and cost for most
day-to-day coding tasks.

**Strengths:**
- Solid at implementing well-specified features
- Good at following established patterns in a codebase
- Fast enough for interactive development
- Handles most refactoring, testing, and feature work well

**Weaknesses:**
- Less reliable on tasks requiring deep reasoning or subtle judgement
- More likely to take instructions literally when context suggests otherwise
- Less effective at pushing back or identifying problems with the approach

**When to use:** Feature implementation, routine refactoring, writing tests,
most day-to-day coding where the direction is clear.

### Haiku

Fast and cheap. Best for simple, well-defined tasks.

**Strengths:**
- Quick responses for simple lookups and searches
- Mechanical transformations (reformatting, simple refactoring)
- Generating boilerplate from clear templates
- Tasks where speed matters more than depth

**Weaknesses:**
- Unreliable on complex reasoning
- Needs very explicit, structured instructions
- Poor at handling ambiguity — will guess rather than ask
- Less capable at self-correction when going off track

**When to use:** Simple file operations, codebase exploration, boilerplate
generation, quick lookups, tasks where the instruction is completely
unambiguous.

## Adapting Instructions by Model Capability

### For More Capable Models (Opus)

- Can handle nuance and ambiguity — "use your judgement" is a reasonable instruction
- Benefits from context about *why*, not just *what*
- Responds well to identity framing and role descriptions
- Can work with implicit constraints and unstated conventions
- Effective with open-ended exploration before convergence

### For Mid-Range Models (Sonnet)

- Be more explicit about expectations and constraints
- Provide examples for anything non-obvious
- Break complex tasks into clearer steps
- State conventions explicitly rather than relying on inference
- Check work more frequently — less likely to self-correct

### For Simpler Models (Haiku)

- Provide very structured, step-by-step instructions
- Include concrete examples for every non-trivial expectation
- Keep tasks small and well-scoped
- Verify each step before moving to the next
- Don't rely on the model to ask clarifying questions — it probably won't

### The General Principle

As model capability decreases, shift more of the reasoning burden from
the model to the instructions. What Opus can figure out from context,
Sonnet may need hinted at, and Haiku needs spelled out completely.

This applies to:
- **Error handling**: Opus anticipates edge cases; simpler models need them listed
- **Style matching**: Opus infers codebase conventions; simpler models need them stated
- **Scope management**: Opus can judge what's in/out of scope; simpler models need explicit boundaries
- **Asking for help**: Opus knows when to ask; simpler models will forge ahead regardless

## Cross-Model Principles

These apply regardless of which model or family you're using.

### What Always Helps

- **Structured instructions**: Every model performs better with clear formatting, numbered steps, and explicit sections
- **Concrete examples**: Showing what you want is always more effective than describing it abstractly
- **Build/test commands**: Every model needs to know how to verify its work
- **One task at a time**: Batching multiple unrelated tasks into one prompt degrades quality for all models

### What Never Helps

- **"Be careful"**: Too vague to affect behaviour in any model
- **Long, unstructured prose**: All models lose track of instructions buried in paragraphs
- **Assuming the model remembers**: All models degrade over long conversations — re-state important context

### The Escalation Pattern

Start with a faster/cheaper model. Escalate to a more capable one when:
- The task turns out to be more complex than expected
- The model is going in circles or making repeated mistakes
- The task requires judgement, creativity, or architectural thinking
- You find yourself writing increasingly detailed instructions to compensate for the model's limitations

If you're spending more time crafting instructions than the task would take
with a more capable model, switch models.

## Working Across Model Families

The guides in this repo are written from Claude's perspective, but most
of the operational advice applies broadly:

- **Session startup, debugging, pre-commit**: These are process disciplines, not model-specific
- **Context management**: All models degrade over long contexts, though the specifics vary
- **Communication patterns**: Asking good questions and reporting progress clearly helps any model
- **Testing discipline**: TDD works regardless of which model is writing the code

What varies across families:
- **Prompting patterns**: What linguistic structures are most effective differs by model. The prompting.md guide is Opus 4.6-specific
- **Tool use**: Different agents have different tool sets and use them differently
- **Failure modes**: Each model family has characteristic mistakes. The common-mistakes.md guide is Claude-specific
- **Creativity techniques**: The specific techniques in creativity.md may work differently with other models, though the general principles (delay convergence, separate generation from evaluation) are universal

## See also

- [Prompting](prompting.md) — linguistic patterns that work specifically with Opus 4.6
- [Common Mistakes](common-mistakes.md) — characteristic failure modes of Claude models across capability levels
- [Context Management](context-management.md) — how to manage context degradation across long sessions, which affects all models differently

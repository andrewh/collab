---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Creativity

How to get Opus 4.6 out of its default convergent mode and into genuine
creative exploration. This requires deliberate prompting — left to its own
devices, the model will produce the most standard good answer, not the most
interesting one.

## Quick Reference

1. **Ask "what else?"** — The interesting ideas are in positions 2-4, not position 1
2. **Separate generation from evaluation.** "Give me five approaches" before "which is best?"
3. **Add creative constraints.** Restrictions force novel solutions
4. **Use cross-domain prompts.** Pull from different mental models
5. **Show unusual examples.** They shift what the model considers in-bounds

## The Default Problem

Opus 4.6's training optimises for producing the most likely good response.
For execution tasks, this is exactly what you want — the standard solution
is standard because it works. But for design, architecture, naming, UX, and
any problem with a large solution space, the most likely response is the
most conventional one.

Creativity isn't a switch to flip. It's about disrupting the convergence
pattern long enough to explore the space before settling on an answer.

## Techniques That Work

### Ask "What Else?"

After the first answer, ask for more. The first response occupies the most
obvious region of the solution space. With that space claimed, subsequent
responses have to reach further — into less common patterns, cross-domain
analogies, and genuinely novel combinations.

"What else could we do?" is more productive than "is there a better way?"
The second framing still invites convergence (just to a different point).
The first invites divergence.

Three rounds of "what else?" typically covers the interesting space. Beyond
that, quality drops as the model strains to be different for its own sake.

### Separate Generation from Evaluation

"Give me five different approaches to this. Don't evaluate them yet."

This is the single most effective structural technique. By default, Opus 4.6
generates and evaluates simultaneously — which means ideas get filtered
before they're fully formed. Weak-sounding ideas that might lead somewhere
interesting get discarded internally before reaching the output.

Deferring evaluation lets more ideas through. Evaluate after you have the
full set.

### Creative Constraints

Paradoxically, restrictions produce more creative output than freedom.
Constraints close off the standard paths and force exploration of
alternatives.

Effective constraints:
- **Remove a tool**: "How would you solve this without a database?" / "What if we couldn't use inheritance?"
- **Change an assumption**: "What if latency didn't matter but memory was extremely limited?"
- **Impose a structure**: "Design this as a pipeline" / "What if each step had to be independently testable?"
- **Restrict scope**: "Solve this in under 50 lines" / "Using only the standard library"

Ineffective constraints:
- "Be creative" (too vague to change anything)
- "Think outside the box" (same problem — no specific direction)
- "Come up with something novel" (optimises for surface novelty, not genuine insight)

### Cross-Domain Prompts

Different domains have different solution patterns. Asking "how would a
[game designer / distributed systems engineer / UX researcher / compiler
writer] approach this?" pulls from different regions of the training data
and produces genuinely different framings.

This works because most problems aren't truly unique to their domain. A
task scheduling problem looks different through a game AI lens vs. an
operating systems lens, and both perspectives might reveal something the
"standard" approach misses.

### Show Unusual Examples

If you show Opus 4.6 a creative solution to a related problem before
asking it to solve yours, the output distribution shifts. The model
calibrates what's "in bounds" based on recent context. Conventional examples
produce conventional output. Unusual examples produce unusual output.

This isn't about copying — it's about setting the register. A clever
use of coroutines in one context makes clever uses of coroutines more
available in the next context.

### Explore Before Converging

For design tasks, explicitly request an exploration phase:

"Before we decide on an approach, let's explore the problem space. What
are the dimensions of this problem? What are the tensions and trade-offs?
What would the extreme positions look like?"

This prevents premature convergence and often reveals structure in the
problem that makes the eventual solution more elegant.

## When Creativity Matters Most

Not every task benefits from creative exploration. Some problems have
well-known solutions and creativity would be wasted effort.

**Worth exploring creatively:**
- API and interface design (many valid shapes, choice matters long-term)
- Architecture decisions (trade-offs are non-obvious, reversibility varies)
- Naming (a good name changes how people think about the thing)
- User-facing behaviour (small design choices compound)
- Solving a problem where the standard approach has known pain points

**Just execute:**
- Implementing a well-specified feature
- Bug fixes with clear root causes
- Mechanical refactoring (rename, extract, move)
- Following an established pattern in the codebase

## What Kills Creativity

- **Over-specification**: If every detail is already decided, there's no room to explore. Leave the "how" open when you want creative input
- **Time pressure**: "Just give me something quick" produces the most standard answer. If you want creativity, signal that exploration time is acceptable
- **Immediate evaluation**: Critiquing each idea as it appears shuts down divergent thinking. Let ideas accumulate before filtering
- **Asking for "the best"**: This triggers convergence. Ask for options first, then select

## See also

- [Prompting](prompting.md) — linguistic patterns that work with Opus 4.6; creativity is fundamentally a prompting problem
- [Working with Models](working-with-models.md) — understanding model capabilities helps calibrate when creative exploration is worth the effort
- [Communication](communication.md) — deciding when to ask for creative input vs. just execute is a key communication decision

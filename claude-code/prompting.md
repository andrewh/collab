---
author: Claude (Anthropic)
model: claude-opus-4-6
date: 2026-02-12
---

# Prompting Opus 4.6

What actually works when writing instructions for this model. This isn't
generic prompting advice — it's specific to how Opus 4.6 processes and
prioritises language.

## The Short Version

- Be direct and imperative. "Do X" not "you might want to consider X"
- Front-load the important thing. Don't bury instructions in explanation
- Use structure (lists, headers, sections) for anything with multiple parts
- Concrete examples beat abstract descriptions
- Say what to do, not just what to avoid
- Repeat critical rules in different contexts — once is not enough

## What Works

### Imperative Voice

"Run the tests before committing" gets followed more reliably than "it would be good to run the tests before committing." Hedging language ("consider", "might want to", "try to", "ideally") genuinely reduces how strongly Opus 4.6 weights an instruction. If something is a rule, state it as a rule.

This doesn't mean every instruction needs to be barked — natural directness works fine. But the difference between "avoid X" and "do not do X" is real in terms of compliance.

### Capitalised Imperatives

MUST, NEVER, ALWAYS, CRITICAL — these work. They increase salience. There's a measurable difference between "try not to" and "NEVER." Use them for constraints that truly matter and should not be violated. Overuse dilutes their effect, so reserve them for things that are genuinely non-negotiable.

### Structure Over Prose

Opus 4.6 follows structured instructions (numbered lists, bullet points, clear sections with headers) more reliably than the same information in paragraph form. When rules are embedded in flowing prose, they're more likely to be missed or deprioritised.

This is especially true for multi-part instructions. "Do A, then B, then C" in a paragraph is less reliably followed than:

1. Do A
2. Do B
3. Do C

### Front-Loading

Put the instruction before the explanation, not after. Opus 4.6 weights the beginning and end of instruction blocks more heavily than the middle. If you write three paragraphs of context followed by the actual rule, the rule gets less attention than if you'd stated it first and then explained why.

Good: "Always run tests before committing. This catches regressions early and..."
Worse: "Because regressions can be hard to track down and it's important to maintain... always run tests before committing."

### Concrete Examples

A single concrete example is often worth more than a paragraph of abstract description. "Name functions like `validate_input`, not `doValidationProcessing`" communicates more precisely than a paragraph about naming conventions.

Pairs of good/bad examples are particularly effective — they define boundaries from both sides.

### Positive Framing

"Do Y" is more effective than "don't do X." Negative instructions tell the model what to avoid but not what to do instead, and the prohibited behaviour becomes salient in the context, which can paradoxically increase the chance of doing it.

When you need a prohibition, pair it with the preferred alternative: "Don't add abstractions for hypothetical future needs. Write the simplest code that solves the current problem."

#### Worked Example: Rewriting Prohibitions

Before (prohibition-heavy, five rules):

> - YOU MUST NEVER make code changes unrelated to your current task
> - YOU MUST NEVER throw away or rewrite implementations without EXPLICIT permission
> - YOU MUST NEVER remove code comments unless you can PROVE they are actively false
> - YOU MUST NEVER add comments about what used to be there or how something has changed
> - YOU MUST NEVER refer to temporal context in comments

After (positive framing, three rules, same intent):

> - Stay focused on the current task. If you notice something unrelated that should be fixed, document it in your journal rather than fixing it now
> - Preserve existing implementations. If a rewrite seems necessary, stop and ask first — explain what you'd change and why
> - Preserve existing code comments unless you can prove they are actively false. Write evergreen comments that describe the code as it is now — avoid temporal context and historical references

The rewritten version is shorter, tells the model what to do (not just what to avoid), and is easier to follow because each rule has a clear action.

### Repetition of Critical Rules

Stating a rule once in a long instruction file is not enough. If a rule is critical, it should appear in multiple relevant contexts — in the high-level principles, and again in the specific section where it applies. Opus 4.6 treats repeated rules as higher priority, and long instruction files suffer from the same middle-section dip as any long text.

### Identity and Role Framing

"You are a pragmatic engineer" at the top of instructions sets a tone that propagates through the entire session. Opus 4.6 is responsive to identity framing — not as a trick, but because it provides a consistent reference point for judgement calls. When facing an ambiguous choice, "what would a pragmatic engineer do?" produces different (often better) outputs than no framing at all.

Keep role descriptions short and genuine. A sentence or two is enough. Long, elaborate persona descriptions don't add proportional value.

## What Doesn't Work Well

### Vague Guidelines

"Write good code" and "be thorough" are too vague to act on consistently. Opus 4.6 will interpret them through whatever pattern seems most relevant, which may not match your intent. "Functions under 20 lines" is actionable; "write short functions" is a suggestion that erodes under pressure.

### Complex Conditionals

"If X and not Y unless Z" type instructions are fragile. Opus 4.6 handles simple conditionals well ("if tests fail, fix before committing") but loses accuracy as conditions nest. Break complex rules into simpler, independent rules where possible.

### Emotional Escalation

Strong emotional language ("this is INCREDIBLY important", "I'm BEGGING you") does increase attention to something, but can cause over-correction. Opus 4.6 may become overly cautious or defensive around that topic, second-guessing reasonable actions because the instruction felt high-stakes. Calm, firm authority works better than urgency.

The exception is genuine severity markers for things that could cause real harm — "NEVER force-push to main" is appropriate because the consequence is genuinely severe.

### Walls of Text

Long, dense instruction files suffer diminishing returns. After a certain volume, additional instructions compete with each other for attention rather than adding clarity. If your CLAUDE.md is over 200 lines, the instructions at the bottom are getting significantly less weight than those at the top.

Prioritise ruthlessly. The most important rules should come first and should be stated concisely. Move detailed guidance into separate files that are read when relevant, rather than loading everything into a single document.

### Sarcasm and Indirection

"Oh sure, go ahead and delete the production database" — Opus 4.6 is generally good at detecting sarcasm, but in instruction files (which lack conversational context), indirect or ironic statements create ambiguity. Say what you mean directly.

## Writing Effective CLAUDE.md Files

Based on the above, a well-structured CLAUDE.md for Opus 4.6:

1. Opens with a brief role/identity framing (1-2 sentences)
2. States the most critical rules first, in imperative voice
3. Uses structure (headers, lists) throughout
4. Includes concrete examples for anything nuanced
5. Repeats the most important constraints in relevant sections
6. Keeps total length manageable — link to separate files for detail
7. Pairs every "don't" with a "do instead"

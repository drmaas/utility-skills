---
name: clear-markdown
description: >-
  Write Markdown in clear language with short sentences, plain structure, and
  an explicit audience mode: human, agent, or hybrid. Use when drafting or
  editing Markdown for people, agents, or both — SKILL.md, AGENTS.md, README,
  docs, PR descriptions, specs, guides, GitBook/docs sites, or any .md the user
  asks to make clearer, simpler, more accessible, or easier to follow. Trigger
  on plain language, reading level, jargon removal, short sentences, agent
  instruction clarity, or Cloudflare-style accessible docs writing. Do not use
  for code, config, or chat-compression modes that intentionally trade prose
  clarity for brevity.
compatibility: >-
  No special tooling required. Optional Hemingway Editor or similar for
  sentence length / reading-level checks.
metadata:
  repository: https://github.com/drmaas/utility-skills
---

# Clear Markdown Writing

Agents should write Markdown in clear and straightforward language, using simple words and short sentences to ensure that the content is easily understood by everyone. This approach helps make the information accessible to a wider audience.

## Importance of Clear Markdown Writing

Writing in Markdown should be done in a way that is easy for everyone to understand. This is crucial for effective communication, especially when the audience may not have specialized knowledge.

## Key Guidelines for Writing Markdown

- Use Simple Words: Avoid jargon and complex vocabulary.
- Short Sentences: Keep sentences brief to enhance clarity.
- Clear Structure: Organize content logically with headings and lists.

## Benefits of Simple Language

| Benefit | Description |
| --- | --- |
| Accessibility | Makes information available to a wider audience. |
| Comprehension | Helps readers grasp concepts quickly. |
| Engagement | Encourages more people to read and interact. |

By following these guidelines, agents can ensure their Markdown content is understandable for individuals of average intelligence, promoting better communication and engagement.

## When to apply

Apply this skill whenever you write or revise Markdown that people or agents will read as instructions or documentation:

- Skill files (`SKILL.md`), agent guides (`AGENTS.md`), READMEs
- Product docs, guides, PR bodies, specs, ADRs written for humans
- Rewrites that ask for plain language, simpler wording, or accessibility

Do **not** apply this skill to:

- Source code, shell, or config files
- Intentional telegram/caveman chat styles the user requested
- Legal or compliance text that must keep exact required wording

## Step 1 — Pick the audience

Choose one mode before drafting or rewriting. If unsure, use **hybrid**.

| Mode | Primary reader | Typical files |
| --- | --- | --- |
| `human` | People scanning and learning | Product docs, user guides, blog-style READMEs, marketing pages in Markdown |
| `agent` | Models following instructions | Machine-oriented prompts, tool briefs, dense rule lists with no human teaching goal |
| `hybrid` | Humans edit; agents execute | `SKILL.md`, `AGENTS.md`, many repo READMEs, workflow docs in this repository |

**Default for this repository:** `hybrid`.

State the chosen mode once at the start of the edit (in the task note, PR body, or a one-line comment to the user). Do not mix modes inside one file without a clear section split.

## Shared rules (all modes)

1. Prefer short sentences (about 8–15 words when practical). Split long ones.
2. Keep paragraphs short (about 3–4 sentences max).
3. Use headings in order. One H1 for the page title. Do not skip levels.
4. Prefer lists for steps and related items. Keep list items parallel.
5. Use active voice and present tense when it fits.
6. Expand acronyms on first use: `Distributed Denial of Service (DDoS)`.
7. Link with descriptive text. Avoid "click here" and "read more".
8. Introduce tables with a full sentence. Use tables only for real row/column data.
9. Put explanation before a code block. Name the language on the fence.
10. Say the important rule once in the main path; put deep detail in a linked section or file (progressive disclosure).

## Mode deltas

Apply **shared rules**, then only the delta for the chosen mode.

### `human`

- Prefer common words. Avoid jargon unless the audience already knows it.
- Explain concepts briefly when a new reader needs them.
- Light teaching repetition is OK.
- Accessibility matters: useful alt text; empty alt only for decoration; avoid layout words like "above", "below", "left", "right" unless needed — name the section or control instead.
- Engagement and warmth are OK if they stay short and clear.
- Aim for average-reader comprehension (Cloudflare-style accessible docs).

### `agent`

- Optimize for unambiguous follow-through, not engagement.
- Prefer precise terms after one short definition. Do not dilute API/tool names.
- Use imperative rules: "Do X when Y." "Do not Z."
- Put triggers, inputs, outputs, and failure behavior in explicit sections.
- Prefer good/bad examples of behavior over long narrative.
- Cut fluff, hedges, and motivational prose — they cost tokens and add ambiguity.
- Skip human-only a11y polish unless the same file is also shown in a UI docs site.
- Do **not** target "average intelligence" or engagement framing; target zero guesswork.

### `hybrid` (default)

- Write for agents first: structure, triggers, do/don't, edge-case rules.
- Keep prose plain enough that a human can edit without decoding jargon walls.
- Define a term once in plain language, then reuse the precise term.
- Keep a11y basics when the file may render as docs (descriptive links, alt text, no vague "above").
- Prefer token-lean sections over essays; link out for long reference material.
- One clear "When to use" / "When not to use" block near the top when the file is a skill or agent guide.

## Quick rewrite checklist

Before finishing Markdown, scan shared items, then mode-specific items.

**Shared**

- [ ] Audience mode chosen and applied consistently
- [ ] Sentences longer than ~15 words that can split
- [ ] Walls of prose that should be headings or lists
- [ ] Vague links ("here", "this page")
- [ ] Undefined acronyms on first use

**`human` / `hybrid`**

- [ ] Jargon without a plain definition
- [ ] Directional UI language a screen reader cannot use
- [ ] Missing or useless image alt text (when images exist)

**`agent` / `hybrid`**

- [ ] Missing triggers, do/don't, or failure behavior
- [ ] Hedging or motivational filler an agent might misread as optional
- [ ] Examples that show intent, not only abstract advice
- [ ] Duplicate rules that could collapse into one statement + a link

## Examples

### Shared clarity

**Prefer**

> Cloudflare protects your website from DDoS attacks.

**Avoid**

> Cloudflare provides comprehensive protection mechanisms to mitigate distributed denial-of-service attack vectors.

**Prefer**

> Complete these steps to configure your settings.

**Avoid**

> In order to facilitate the configuration of your settings, it is necessary to complete the following steps.

### `human` — descriptive links and plain words

**Prefer**

> For common issues, refer to the DNS troubleshooting guide.

**Avoid**

> For common issues, click here.

### `agent` — imperative and unambiguous

**Prefer**

> When the user pastes an image and the model has no vision, run image-preprocess before answering.

**Avoid**

> You might want to consider preprocessing images in some cases where it could help.

### `hybrid` — precise term after a plain gloss

**Prefer**

> Use a feature worktree (a linked Git working directory on its own branch). Create it before editing files.

**Avoid**

> Utilize an ephemeral ancillary checkout abstraction prior to initiating modifications.

## Further reading

- [Cloudflare Style Guide — Accessibility](https://developers.cloudflare.com/style-guide/documentation-content-strategy/accessibility/) (simple words, short sentences, lists, links, alt text)
- [Cloudflare Style Guide — Sentence structure](https://developers.cloudflare.com/style-guide/formatting/structure/sentence-structure/) (~15 words or fewer)
- [Lead with AI — Markdown files for AI agents](https://www.leadwithai.co/guides/markdown-files-for-ai-agents) (why agents use structured `.md`)

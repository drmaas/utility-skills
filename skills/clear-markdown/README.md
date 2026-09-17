# clear-markdown

Write Markdown in clear language with short sentences and logical structure. Pick an audience mode first:

| Mode | Use for |
| --- | --- |
| `human` | Product docs, guides, human-first READMEs |
| `agent` | Instruction-only prompts and rule briefs |
| `hybrid` | `SKILL.md`, `AGENTS.md`, most repo docs (default here) |

Shared rules cover all modes; each mode adds a short delta (plain language + a11y for humans; imperative precision + token lean for agents).

```bash
npx skills add drmaas/utility-skills --skill clear-markdown
```

Trigger phrases: "plain language", "simpler Markdown", "make this clearer", "accessible docs", "agent instructions", "short sentences", "remove jargon".

Aligned with [Cloudflare Style Guide accessibility](https://developers.cloudflare.com/style-guide/documentation-content-strategy/accessibility/) and [sentence structure](https://developers.cloudflare.com/style-guide/formatting/structure/sentence-structure/); see also [Lead with AI on Markdown for agents](https://www.leadwithai.co/guides/markdown-files-for-ai-agents).

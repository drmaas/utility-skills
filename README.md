# drmaas/utility-skills

A collection of agent skills for AI coding agents. Skills follow the [Agent Skills](https://agentskills.io/) format.

## Installation (skills)

```bash
# Install all skills in this repository
npx skills add drmaas/utility-skills

# Install a specific skill
npx skills add drmaas/utility-skills --skill image-preprocess
npx skills add drmaas/utility-skills --skill rpi

# Install to a specific agent (e.g. opencode, claude-code)
npx skills add drmaas/utility-skills --agent opencode

# List available skills without installing
npx skills add drmaas/utility-skills --list
```

After installation, your agent will automatically load the relevant skill when it detects a matching task.

---

## Skills

### rpi

Fit check → PRD → Research → Plan → Implement with specialized reviewer agents, optional `docs/contracts.md` + ADRs, mandatory human gates, and a final freeze that commits durable docs into the feature PR. Fresh-context subagents per phase; drafts under `docs/decisions/<feature>/`; TDD by default; verify before each implementation review.

```bash
npx skills add drmaas/utility-skills --skill rpi
```

Trigger phrases: "RPI", "research-plan-implement", gated research → plan → implement loop.

Further reading: [HumanLayer ace-fca](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md), [Tyler Burleigh (2026-02-22)](https://tylerburleigh.com/blog/2026/02/22/). See also [`skills/rpi/README.md`](skills/rpi/README.md).

### image-preprocess

Preprocess images into structured Markdown so text-only LLMs can understand them (Tesseract OCR + Moondream caption/detail). Most coding models cannot see images; this skill bridges that gap.

```bash
npx skills add drmaas/utility-skills --skill image-preprocess
```

See [`skills/image-preprocess/README.md`](skills/image-preprocess/README.md).

---

## Repository Structure

```
skills/
  rpi/
    SKILL.md
    models.md
    worktree.md
    artifacts.md
    human-gates.md
    contracts.md
    adrs.md
    agents/
    phases/
    templates/
    README.md
  image-preprocess/
    SKILL.md
    README.md
    scripts/
      preprocess_image.sh
      preprocess_batch.sh
  ...more-skills-here/
```

## License

MIT

# drmaas/utility-skills

A collection of agent skills for AI coding agents. Skills follow the [Agent Skills](https://agentskills.io/) format.

## Installation (skills)

```bash
# Install all skills in this repository
npx skills add drmaas/utility-skills

# Install a specific skill
npx skills add drmaas/utility-skills --skill image-preprocess
npx skills add drmaas/utility-skills --skill selenium-automation
npx skills add drmaas/utility-skills --skill rpi
npx skills add drmaas/utility-skills --skill sdd
npx skills add drmaas/utility-skills --skill doit
npx skills add drmaas/utility-skills --skill clear-markdown

# Install to a specific agent (see `npx skills add --help` for supported hosts)
npx skills add drmaas/utility-skills --agent <agent>

# List available skills without installing
npx skills add drmaas/utility-skills --list
```

After installation, your agent will automatically load the relevant skill when it detects a matching task.

---

## Skills

### clear-markdown

Write Markdown in clear language with short sentences and logical structure. Choose audience mode `human`, `agent`, or `hybrid` (default for `SKILL.md` / `AGENTS.md` / most repo docs).

```bash
npx skills add drmaas/utility-skills --skill clear-markdown
```

See [`skills/clear-markdown/README.md`](skills/clear-markdown/README.md).

### rpi

Fit check → PRD → Research → Plan → Implement with specialized reviewer agents, optional `docs/contracts.md` + ADRs, mandatory human gates, and a final freeze that commits durable docs into the feature PR. Fresh-context subagents per phase; drafts under `docs/decisions/<feature>/`; TDD by default; verify before each implementation review.

```bash
npx skills add drmaas/utility-skills --skill rpi
```

Trigger phrases: "RPI", "research-plan-implement", gated research → plan → implement loop.

Further reading: [HumanLayer ace-fca](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md), [Tyler Burleigh (2026-02-22)](https://tylerburleigh.com/blog/2026/02/22/). See also [`skills/rpi/README.md`](skills/rpi/README.md).

### sdd

Spec-driven development: isolated worktree, ephemeral brainstorm, architecture, formal specification, human approval gate, implementation plan, tests-first coding, verification, fresh-context review, docs, and release. Use for non-trivial or compliance-heavy changes that need behavior locked before code.

```bash
npx skills add drmaas/utility-skills --skill sdd
```

See [`skills/sdd/README.md`](skills/sdd/README.md).

### doit

Fast path for well-scoped changes: worktree, ephemeral brainstorm, lightweight architecture note + plan, tests-first, verify, fresh-context review, docs, release — no formal spec and no pre-implementation human gate. Escalate to `sdd` when scope is unclear.

```bash
npx skills add drmaas/utility-skills --skill doit
```

See [`skills/doit/README.md`](skills/doit/README.md).

### image-preprocess

Preprocess images into structured Markdown so text-only LLMs can understand them (Tesseract OCR + Moondream caption/detail). Most coding models cannot see images; this skill bridges that gap.

```bash
npx skills add drmaas/utility-skills --skill image-preprocess
```

See [`skills/image-preprocess/README.md`](skills/image-preprocess/README.md).

### selenium-automation

Browser automation and E2E testing with Selenium WebDriver on Node.js 22+ / TypeScript / Vitest — Page Object Model, explicit waits, locators, recommended test browsers (Chrome for Testing, versioned Firefox, Edge, Safari), headless runs, and Vitest lifecycle patterns.

```bash
npx skills add drmaas/utility-skills --skill selenium-automation
```

See [`skills/selenium-automation/README.md`](skills/selenium-automation/README.md).

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
  sdd/
    SKILL.md
    models.md
    README.md
  doit/
    SKILL.md
    models.md
    README.md
  image-preprocess/
    SKILL.md
    README.md
    scripts/
      preprocess_image.sh
      preprocess_batch.sh
  selenium-automation/
    SKILL.md
    README.md
  clear-markdown/
    SKILL.md
    README.md
```

## License

MIT

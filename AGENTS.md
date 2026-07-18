# drmaas/utility-skills — Agent Guide

## Overview

A repository of agent skills following the [Agent Skills](https://agentskills.io/) format. Each skill lives in `skills/<skill-name>/` and contains a `SKILL.md` with trigger instructions, plus optional scripts and assets.

## Repository Structure

```
.
├── AGENTS.md              # This file
├── README.md              # Human-facing overview & install instructions
├── skills.sh.json         # Skills.sh registry metadata (JSON Schema only)
└── skills/
    └── <skill-name>/
        ├── SKILL.md       # Skill definition (required)
        └── scripts/       # Optional helper scripts
```

## Skill Format

Every skill in `skills/<name>/SKILL.md` follows the Agent Skills spec:

- **Frontmatter**: `name`, `description`, `compatibility`, `metadata.repository`
- **Body**: Markdown with prerequisites, usage, workflow, edge cases
- **Trigger**: The `description` field in frontmatter is the primary trigger — it should be a detailed paragraph that tells the agent exactly when to activate

Current skills: `image-preprocess` (preprocesses images via Tesseract OCR + Moondream for text-only LLMs).

## Adding a New Skill

1. Create `skills/<name>/SKILL.md` with proper frontmatter
2. Add any helper scripts under `skills/<name>/scripts/`
3. Update `README.md` "Skills" section with a summary entry
4. No changes needed to `skills.sh.json` — it only contains the `$schema` reference

## Prerequisites Format

List CLI/package dependencies in the `compatibility` frontmatter field. Include a comprehensive verification script in the body.

## Script Conventions

- Bash scripts use `set -uo pipefail`
- Graceful degradation: if a tool is missing, output a skip notice instead of failing
- Single-op scripts accept `[output_path]` to write to file vs stdout
- Batch scripts process all common image extensions (png, jpg, jpeg, tif, tiff, bmp, webp)

## Publishing

Skills are installed via `npx skills add drmaas/utility-skills`. The repo is consumed directly from GitHub — no build step needed.

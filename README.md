# drmaas/skills

A collection of agent skills for AI coding agents. Skills follow the [Agent Skills](https://agentskills.io/) format and are installable via `npx skills`.

## Available Skills

### image-preprocess

Extracts literal text (via Tesseract OCR) and semantic/visual meaning (via Moondream) from images, combining both into a single Markdown block for text-only LLMs.

**Use when:** OCR-ing screenshots/documents, describing image content, batch-processing a folder of images, or preparing image data for a non-multimodal model.

**Prerequisites:** `tesseract-ocr` and `moondream` CLI must be installed.

## Installation

```bash
# Install all skills
npx skills add drmaas/skills

# Install a specific skill
npx skills add drmaas/skills --skill image-preprocess
```

## Repository Structure

```
skills/
  image-preprocess/
    SKILL.md          # Agent instructions
    scripts/          # Helper scripts
      preprocess_image.sh
      preprocess_batch.sh
```

## License

MIT

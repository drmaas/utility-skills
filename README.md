# drmaas/utility-skills

A collection of agent skills for AI coding agents. Skills follow the [Agent Skills](https://agentskills.io/) format.

## Installation (skills)

```bash
# Install all skills in this repository
npx skills add drmaas/utility-skills

# Install a specific skill
npx skills add drmaas/utility-skills --skill image-preprocess

# Install to a specific agent (e.g. opencode, claude-code)
npx skills add drmaas/utility-skills --agent opencode

# List available skills without installing
npx skills add drmaas/utility-skills --list
```

After installation, your agent will automatically load the relevant skill when it detects a matching task.

---

## Skills

### image-preprocess

Preprocess images into a structured Markdown description so text-only LLMs can understand them. Most coding models — like **DeepSeek V4 Flash** — cannot see images. This skill bridges that gap.

#### How it works

It runs two tools and merges their output:

| Tool | What it does | Strengths |
|------|-------------|-----------|
| **Tesseract OCR** | Extracts literal, pixel-level text from images | Documents, screenshots, scanned forms, signs — any image with readable characters |
| **Moondream** | Generates a semantic caption and detailed visual description | Scene understanding, objects, people, layout, colors, overall "what's happening" in the image |

Tesseract has zero scene understanding — it doesn't know a cat from a car. Moondream understands the scene but isn't tuned for dense document text. Running both and merging their output gives you the full picture.

#### Prerequisites

Both CLIs must be installed on the machine running the agent:

```bash
# Tesseract OCR (Debian/Ubuntu)
sudo apt-get install -y tesseract-ocr

# Tesseract OCR (macOS)
brew install tesseract

# Moondream CLI (any OS with Python)
pip install moondream --break-system-packages
```

Verify both are available:

```bash
command -v tesseract && command -v moondream
```

#### Usage

```bash
# Single image → stdout
scripts/preprocess_image.sh /path/to/image.jpg

# Single image → file
scripts/preprocess_image.sh /path/to/image.jpg /path/to/output.md

# Batch process a folder of images
scripts/preprocess_batch.sh /path/to/images/ combined.md
```

---

## Repository Structure

```
skills/
  image-preprocess/
    SKILL.md
    scripts/
      preprocess_image.sh
      preprocess_batch.sh
  ...more-skills-here/
```

## License

MIT

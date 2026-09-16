# image-preprocess — Tesseract + Moondream

Turns images into Markdown a text-only LLM can reason over. Most coding models cannot see images; this skill bridges that gap by combining literal OCR with a visual description.

**Why both tools:** Tesseract pulls verbatim text (screenshots, scans, signs) but has no scene understanding. Moondream captions and describes the scene but is weak on dense document text. Together they give the model both "what's in the picture" and "what text is on it."

**When to use:** image attached / path given and the downstream model has no vision; OCR, caption, describe, or batch-preprocess a folder before feeding results into a text-only prompt.

**Needs on PATH:** `tesseract` (OCR) and `moondream` (caption + detail). Scripts degrade gracefully if one is missing.

Install:

```bash
npx skills add drmaas/utility-skills --skill image-preprocess
```

```bash
# Debian/Ubuntu
sudo apt-get install -y tesseract-ocr tesseract-ocr-eng

# macOS
brew install tesseract

# Moondream (any OS with Python)
pip install moondream --break-system-packages
```

Quick usage:

```bash
scripts/preprocess_image.sh /path/to/image.jpg
scripts/preprocess_image.sh /path/to/image.jpg /path/to/output.md
scripts/preprocess_batch.sh /path/to/images/ combined.md
```

Agent instructions, prereq checks, and output format: [`SKILL.md`](SKILL.md).

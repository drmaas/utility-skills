---
name: image-preprocess
description: Extracts both literal text and semantic/visual meaning from images using the Tesseract OCR CLI and the Moondream CLI, then combines the results into a single Markdown block that a text-only LLM can consume. Use this skill whenever the user has an image but is working with a text-only model (no vision support), wants to "describe" an image, needs text pulled out of a screenshot/scan/photo, or asks to pre-process, caption, or OCR an image or folder of images before feeding it to an LLM. Trigger this even if the user only mentions OCR, captioning, or "reading" an image — not just when they say "preprocess."
compatibility: Requires the `tesseract` CLI (tesseract-ocr) and the `moondream` CLI (pip install moondream) to be installed and on PATH.
metadata:
  repository: https://github.com/drmaas/skills
---

# Image Preprocess (Tesseract + Moondream)

Combines two complementary tools to turn an image into text a non-multimodal
LLM can reason over:

- **Tesseract OCR** — extracts literal text (documents, screenshots, signs, forms)
- **Moondream** — extracts semantic/visual meaning (caption + detailed description of scene, objects, layout)

Running both and combining their output gives a text-only model much more to
work with than either tool alone — Tesseract has zero scene understanding,
and Moondream isn't tuned for dense document text.

## When to use this

- User has an image and their downstream LLM doesn't support vision
- User wants a caption/description of an image
- User wants text extracted from a photo, screenshot, or scanned document
- User wants to batch-process a folder of images into a single text digest

## Prerequisites

Run this comprehensive check to verify both tools are installed and
functional before proceeding:

```bash
STATUS=0

echo "=== Tesseract ==="
if command -v tesseract >/dev/null 2>&1; then
  VER=$(tesseract --version 2>&1 | head -1)
  echo "  binary: found ($VER)"
  if tesseract --list-langs 2>/dev/null | grep -qi "^eng$"; then
    echo "  lang data: OK (eng available)"
  else
    echo "  lang data: MISSING (run: sudo apt-get install -y tesseract-ocr-eng)"
    STATUS=1
  fi
else
  echo "  binary: NOT FOUND"
  echo "  install: sudo apt-get install -y tesseract-ocr"
  STATUS=1
fi

echo "=== Moondream ==="
MD_FOUND=0
if command -v moondream >/dev/null 2>&1; then
  if moondream --help >/dev/null 2>&1; then
    echo "  moondream CLI: FOUND and responds"
    MD_FOUND=1
  else
    echo "  moondream CLI: FOUND but broken (try: pip install --upgrade moondream)"
  fi
fi
if command -v moondream-station >/dev/null 2>&1; then
  echo "  moondream-station CLI: FOUND"
  MD_FOUND=1
fi
if python3 -c "import moondream" 2>/dev/null; then
  PV=$(python3 -c "import moondream; print(getattr(moondream, '__version__', 'unknown'))" 2>/dev/null)
  echo "  moondream Python package: FOUND (version $PV)"
  MD_FOUND=1
else
  echo "  moondream Python package: NOT FOUND"
fi
if [ "$MD_FOUND" -eq 0 ]; then
  echo "  install one of:"
  echo "    - pip install moondream          (Python library)"
  echo "    - https://moondream.ai/station   (moondream-station CLI)"
  STATUS=1
fi
if [ -d "$HOME/.cache/moondream" ] && ls "$HOME/.cache/moondream"/*.gguf >/dev/null 2>&1; then
  echo "  model cache: FOUND ($(ls "$HOME/.cache/moondream"/*.gguf))"
elif [ -d "$HOME/.cache/huggingface/hub" ] && find "$HOME/.cache/huggingface/hub" -maxdepth 2 -name "*moondream*" -type d 2>/dev/null | grep -q .; then
  MDIR=$(find "$HOME/.cache/huggingface/hub" -maxdepth 2 -name "*moondream*" -type d 2>/dev/null | head -1)
  echo "  model cache: FOUND (HuggingFace: $MDIR)"
elif python3 -c "import moondream; print(type(moondream.vl))" 2>/dev/null | grep -qi "model\|module\|class"; then
  echo "  model: LOADABLE via Python (will init on first use)"
else
  echo "  model cache: NOT FOUND (will auto-download on first use)"
fi

echo ""
if [ "$STATUS" -eq 0 ]; then
  echo "All prerequisites satisfied."
else
  echo "One or more prerequisites are missing. See above."
fi
```

If tesseract is missing:

```bash
sudo apt-get install -y tesseract-ocr tesseract-ocr-eng
```

If moondream is missing:

```bash
pip install moondream --break-system-packages
```

If `moondream` needs a model download or API key on first run, follow the
prompt it gives — don't guess at flags. Run `moondream --help` and
`moondream caption --help` if the commands in this skill don't match the
installed version, and adapt accordingly.

## Usage

### Single image

```bash
scripts/preprocess_image.sh /path/to/image.jpg
```

Optionally write to a file instead of stdout:

```bash
scripts/preprocess_image.sh /path/to/image.jpg /path/to/output.md
```

### Batch (a whole folder)

```bash
scripts/preprocess_batch.sh /path/to/image_dir /path/to/combined_output.md
```

Processes every image in the directory (png, jpg, jpeg, tif, tiff, bmp, webp)
and concatenates results into one Markdown file, separated by `---`.

## Output format

Each image produces a block like:

```markdown
## Image Analysis: filename.jpg

### Semantic Description (Moondream)
**Caption:** A short one-line caption.

**Detail:** A longer, detailed description of the scene, objects, people,
colors, and layout.

### Extracted Text (Tesseract OCR)
```
Any literal text found in the image, verbatim.
```
```

This block is designed to be pasted directly into a text-only LLM prompt —
it gives the model both "what's in the picture" and "what text is on it."

## Workflow

1. Confirm `tesseract` and `moondream` are installed (see Prerequisites).
2. Run `preprocess_image.sh` (single) or `preprocess_batch.sh` (folder).
3. Take the resulting Markdown and hand it directly to the text-only LLM as
   context, or paste it into the conversation.
4. If either tool errors out, the script degrades gracefully — it'll note
   "(tesseract not installed — skipped)" or similar rather than failing the
   whole run, so partial results (OCR-only or caption-only) still come through.

## Notes / edge cases

- Blank or non-text images: OCR section will read `(no text detected)` —
  this is expected, not a failure.
- Low-quality/rotated scans: Tesseract accuracy drops significantly on
  skewed or low-res input. If OCR output looks garbled, consider mentioning
  that to the user rather than passing garbage text downstream.
- Moondream's exact CLI flags can vary by version — if `moondream caption`
  or `moondream query` fail, run `moondream --help` to check the current
  syntax and adjust `scripts/preprocess_image.sh` accordingly.

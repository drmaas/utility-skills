#!/usr/bin/env bash
#
# preprocess_image.sh
#
# Runs Tesseract OCR and Moondream CLI against an image and combines
# their output into a single Markdown block suitable for pasting into
# a text-only LLM prompt.
#
# Usage:
#   ./preprocess_image.sh <image_path> [output_path]
#
# If output_path is omitted, output is printed to stdout.

set -uo pipefail

IMAGE_PATH="${1:-}"
OUTPUT_PATH="${2:-}"

if [[ -z "$IMAGE_PATH" ]]; then
  echo "Usage: $0 <image_path> [output_path]" >&2
  exit 1
fi

if [[ ! -f "$IMAGE_PATH" ]]; then
  echo "Error: file not found: $IMAGE_PATH" >&2
  exit 1
fi

FILENAME=$(basename "$IMAGE_PATH")

# --- Tesseract OCR ---------------------------------------------------------
OCR_TEXT=""
if command -v tesseract >/dev/null 2>&1; then
  if ! tesseract --list-langs 2>/dev/null | grep -qi "^eng$"; then
    OCR_TEXT="(tesseract missing eng language data — skipped)"
  else
    OCR_TEXT=$(tesseract "$IMAGE_PATH" - 2>/dev/null)
    if [[ -z "$(echo "$OCR_TEXT" | tr -d '[:space:]')" ]]; then
      OCR_TEXT="(no text detected)"
    fi
  fi
else
  OCR_TEXT="(tesseract not installed — skipped)"
fi

# --- Moondream caption + description ---------------------------------------
CAPTION=""
DESCRIPTION=""
MOONDREAM_SKIP=""

if command -v moondream >/dev/null 2>&1; then
  MOONDREAM_MODE="cli"
elif command -v moondream-station >/dev/null 2>&1; then
  MOONDREAM_MODE="station"
else
  MOONDREAM_SKIP="(moondream not found — no CLI, no station, no Python package — skipped)"
fi

if [[ -z "$MOONDREAM_SKIP" ]]; then
  case "$MOONDREAM_MODE" in
    cli)
      CAPTION=$(moondream caption "$IMAGE_PATH" 2>/dev/null)
      DESCRIPTION=$(moondream query "$IMAGE_PATH" "Describe this image in detail, including layout, objects, people, colors, and any notable visual context." 2>/dev/null)
      ;;
    station)
      CAPTION=$(moondream-station infer caption "$IMAGE_PATH" 2>/dev/null)
      DESCRIPTION=$(moondream-station infer query "$IMAGE_PATH" "Describe this image in detail, including layout, objects, people, colors, and any notable visual context." 2>/dev/null)
      ;;
  esac

  [[ -z "$CAPTION" ]] && CAPTION="(no caption returned)"
  [[ -z "$DESCRIPTION" ]] && DESCRIPTION="(no description returned)"
else
  CAPTION="$MOONDREAM_SKIP"
  DESCRIPTION="$MOONDREAM_SKIP"
fi

# --- Assemble combined Markdown output --------------------------------------
RESULT=$(cat <<EOF
## Image Analysis: ${FILENAME}

### Semantic Description (Moondream)
**Caption:** ${CAPTION}

**Detail:** ${DESCRIPTION}

### Extracted Text (Tesseract OCR)
\`\`\`
${OCR_TEXT}
\`\`\`
EOF
)

if [[ -n "$OUTPUT_PATH" ]]; then
  echo "$RESULT" > "$OUTPUT_PATH"
  echo "Written to $OUTPUT_PATH" >&2
else
  echo "$RESULT"
fi

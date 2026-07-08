#!/usr/bin/env bash
#
# preprocess_batch.sh
#
# Runs preprocess_image.sh over every image in a directory and
# concatenates the results into one Markdown file — handy for
# handing a whole folder of images to a text-only LLM in one prompt.
#
# Usage:
#   ./preprocess_batch.sh <image_dir> <output_file.md>

set -uo pipefail

IMAGE_DIR="${1:-}"
OUTPUT_FILE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$IMAGE_DIR" || -z "$OUTPUT_FILE" ]]; then
  echo "Usage: $0 <image_dir> <output_file.md>" >&2
  exit 1
fi

> "$OUTPUT_FILE"

shopt -s nullglob nocaseglob
FILES=("$IMAGE_DIR"/*.{png,jpg,jpeg,tif,tiff,bmp,webp})
shopt -u nocaseglob

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No images found in $IMAGE_DIR" >&2
  exit 1
fi

for f in "${FILES[@]}"; do
  echo "Processing: $f" >&2
  "$SCRIPT_DIR/preprocess_image.sh" "$f" >> "$OUTPUT_FILE"
  echo -e "\n---\n" >> "$OUTPUT_FILE"
done

echo "Done. Combined output written to $OUTPUT_FILE" >&2

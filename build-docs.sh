#!/usr/bin/env sh
# Build the shareable briefing (PDF + DOCX) from the Markdown sources.
# Edit the Markdown, never the files in docs/ — they are regenerated.
set -eu
cd "$(dirname "$0")"
mkdir -p docs

SRC="README.md 00-research-context.md 01-thesis-proposal.md 02-open-questions.md"
OUT="docs/thesis-briefing"

command -v pandoc >/dev/null || { echo "pandoc not found"; exit 1; }

# shellcheck disable=SC2086
pandoc metadata.yaml $SRC -o "$OUT.docx" --toc --toc-depth=2
echo "wrote $OUT.docx"

if command -v xelatex >/dev/null; then
  # shellcheck disable=SC2086
  pandoc metadata.yaml $SRC -o "$OUT.pdf" --toc --toc-depth=2 \
    --pdf-engine=xelatex \
    -V geometry:margin=2.5cm -V fontsize=11pt -V linkcolor=blue \
    -V mainfont="Times New Roman" -V CJKmainfont="Songti SC"
  echo "wrote $OUT.pdf"
else
  echo "xelatex not found — skipped PDF, DOCX still built"
fi

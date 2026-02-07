#!/bin/sh
set -e

CONTENT_DIR="${CONTENT_DIR:-/content/docs}"
OUTPUT_DIR="${OUTPUT_DIR:-/output}"

# Inject content
if [ -d "$CONTENT_DIR" ]; then
  cp -r "$CONTENT_DIR"/* /app/src/content/docs/
else
  echo "ERROR: No content found at $CONTENT_DIR"
  exit 1
fi

# Extract title from index.mdx frontmatter (if not set via env)
if [ -z "$DOCS_TITLE" ] && [ -f /app/src/content/docs/index.mdx ]; then
  DOCS_TITLE=$(grep -m1 '^title:' /app/src/content/docs/index.mdx | sed 's/title: *["]*//;s/["]*$//' || echo "Documentation")
  export DOCS_TITLE
fi

# Build
npm run build

# Copy output
if [ -d "$OUTPUT_DIR" ]; then
  cp -r /app/dist/* "$OUTPUT_DIR"/
fi

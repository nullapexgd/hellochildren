#!/bin/sh

set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

output_file="$project_dir/manuscript.md"
book_dir="$project_dir/book"
dist_dir="$project_dir/dist"
html_output="$dist_dir/on-your-processor.html"
epub_output="$dist_dir/on-your-processor.epub"
cover_image="$book_dir/assets/cover.png"
synopsis_file="$project_dir/notes/synopsis.md"

temp_file=$(mktemp "${TMPDIR:-/tmp}/on-your-processor.XXXXXX")

trap 'rm -f "$temp_file"' EXIT HUP INT TERM

: > "$temp_file"

first=1

for chapter_file in "$project_dir"/chapters/*.md; do
    if [ "$first" -eq 0 ]; then
        printf '\n\n' >> "$temp_file"
    fi

    cat "$chapter_file" >> "$temp_file"
    first=0
done

printf '\n' >> "$temp_file"

mv "$temp_file" "$output_file"

trap - EXIT HUP INT TERM

last_nonblank=$(
    awk 'NF { line=$0 } END { print line }' "$output_file"
)

if [ "$last_nonblank" != "moo." ]; then
    printf '%s\n' "error: manuscript does not end at moo." >&2
    exit 1
fi

printf '%s\n' "built manuscript.md"

if command -v pandoc >/dev/null 2>&1; then
    mkdir -p "$dist_dir"

    pandoc \
        "$output_file" \
        --standalone \
        --toc \
        --metadata-file="$book_dir/metadata.yaml" \
        --template="$book_dir/template.html" \
        --css="$book_dir/book.css" \
        --lua-filter="$book_dir/remove-publication-title.lua" \
        --metadata="cover-image:$cover_image" \
        --metadata="synopsis-file:$synopsis_file" \
        --include-after-body="$book_dir/reader.js" \
        --embed-resources \
        --output="$html_output"

    pandoc \
        "$output_file" \
        --standalone \
        --toc \
        --metadata-file="$book_dir/metadata.yaml" \
        --css="$book_dir/book.css" \
        --lua-filter="$book_dir/remove-publication-title.lua" \
        --epub-cover-image="$cover_image" \
        --output="$epub_output"

    printf '%s\n' "built dist/on-your-processor.html"
    printf '%s\n' "built dist/on-your-processor.epub"
else
    printf '%s\n' "pandoc not found; skipped formatted book outputs"
fi

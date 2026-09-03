#!/bin/sh

set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

html_file="$project_dir/dist/on-your-processor.html"
epub_file="$project_dir/dist/on-your-processor.epub"

fail() {
    printf '%s\n' "publication check failed: $1" >&2
    exit 1
}

contains() {
    grep -Fq -- "$2" "$1" || fail "$1 does not contain: $2"
}

not_contains() {
    if grep -Fq -- "$2" "$1"; then
        fail "$1 still contains: $2"
    fi
}

contains "$project_dir/chapters/00-title.md" '# On Your Processor'
contains "$project_dir/book/metadata.yaml" 'title: "On Your Processor"'
contains "$project_dir/book/metadata.yaml" 'author: "Efeali Bel"'
contains "$project_dir/book/template.html" 'content="On Your Processor build system"'
contains "$project_dir/build.sh" 'on-your-processor.html'
contains "$project_dir/build.sh" 'on-your-processor.epub'
contains "$project_dir/build.sh" '--embed-resources'
contains "$project_dir/build.sh" '--epub-cover-image'
contains "$project_dir/docs/superpowers/plans/2026-09-01-sideways-expansion.md" 'on-your-processor-v0.3.md'
not_contains "$project_dir/docs/superpowers/plans/2026-09-01-sideways-expansion.md" 'HELLO-CHILDREN-v0.3.md'

test -f "$project_dir/book/assets/cover.png" || fail 'missing book/assets/cover.png'
test -f "$project_dir/book/reader.js" || fail 'missing book/reader.js'
contains "$project_dir/book/book.css" 'local("SF Pro Text")'
contains "$project_dir/book/book.css" 'local("SF Pro Display")'
contains "$project_dir/book/template.html" 'class="book-reader"'
contains "$project_dir/book/template.html" 'id="reader-prev"'
contains "$project_dir/book/template.html" 'id="reader-next"'
contains "$project_dir/book/template.html" 'id="reader-progress"'
contains "$project_dir/book/reader.js" 'ArrowLeft'
contains "$project_dir/book/reader.js" 'ArrowRight'
contains "$project_dir/book/reader.js" 'PageUp'
contains "$project_dir/book/reader.js" 'PageDown'
contains "$project_dir/README.md" '[Interactive HTML reader](dist/on-your-processor.html)'
contains "$project_dir/README.md" 'Left/Right arrow keys'

test -f "$html_file" || fail "missing $html_file"
test -f "$epub_file" || fail "missing $epub_file"

contains "$html_file" '<h1 class="title">On Your Processor</h1>'
contains "$html_file" 'Efeali Bel'
contains "$html_file" 'id="front-cover"'
contains "$html_file" 'id="back-cover"'
contains "$html_file" 'Your Mac is not run by one all-powerful piece of'
contains "$html_file" 'id="reader-status"'
contains "$html_file" 'id="reader-progress"'
contains "$html_file" 'ArrowLeft'
contains "$html_file" 'ArrowRight'
contains "$html_file" 'data:image/png;base64,'
not_contains "$html_file" '<link rel="stylesheet"'
not_contains "$html_file" '<script src='
not_contains "$html_file" '/Users/'
not_contains "$html_file" 'id="on-your-processor"'

epub_metadata=$(unzip -p "$epub_file" EPUB/content.opf)
printf '%s' "$epub_metadata" | grep -Fq '<dc:title' || fail 'EPUB title metadata is missing'
printf '%s' "$epub_metadata" | grep -Fq '>On Your Processor</dc:title>' || fail 'EPUB title is incorrect'
printf '%s' "$epub_metadata" | grep -Fq '>Efeali Bel</dc:creator>' || fail 'EPUB author is incorrect'
printf '%s' "$epub_metadata" | grep -Fq 'cover-image' || fail 'EPUB cover image is missing'

contains "$project_dir/chapters/04-launchd.md" '# 4. launchd: Hello Children'
contains "$project_dir/chapters/00-title.md" 'Unless a passage says otherwise, local observations in this edition came from macOS 27.0 build `26A5416b`.'
not_contains "$project_dir/chapters/04-launchd.md" 'The source conversation examined'
not_contains "$project_dir/chapters/04-launchd.md" 'The v0.3 reproduction pass'
not_contains "$project_dir/chapters/05-the-children.md" 'The v0.3 reproduction pass'
not_contains "$project_dir/chapters/07-trust-and-signatures.md" 'The v0.3 reproduction pass'
not_contains "$project_dir/chapters/08-neighborhood-services.md" 'The earlier source-conversation build'
not_contains "$project_dir/chapters/08-neighborhood-services.md" 'The v0.3 reproduction target'
not_contains "$project_dir/chapters/12-shutdown.md" 'The earlier source archaeology'
not_contains "$project_dir/chapters/12-shutdown.md" 'the v0.3 reproduction pass'

last_nonblank=$(awk 'NF { line=$0 } END { print line }' "$project_dir/manuscript.md")
test "$last_nonblank" = 'moo.' || fail 'manuscript does not end at moo.'

printf '%s\n' 'publication check passed'

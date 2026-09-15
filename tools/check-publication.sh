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

contains_with_normalized_whitespace() {
    awk 'NF { $1=$1; printf "%s ", $0 }' "$1" | grep -Fq -- "$2" || fail "$1 does not contain after whitespace normalization: $2"
}

epub_contains() {
    marker=$1
    epub=$2
    unzip -Z1 "$epub" | while IFS= read -r entry; do
        case "$entry" in
            EPUB/text/*.xhtml) unzip -p "$epub" "$entry" ;;
        esac
    done | grep -Fq -- "$marker" || fail "$epub reading content does not contain: $marker"
}

epub_reading_content() {
    epub=$1
    unzip -Z1 "$epub" | while IFS= read -r entry; do
        case "$entry" in
            EPUB/text/*.xhtml) unzip -p "$epub" "$entry" ;;
        esac
    done
}

count_standalone() {
    awk '$0 == "moo." { count++ } END { print count + 0 }' "$1"
}

assert_order() {
    file=$1
    shift
    previous=0
    for marker in "$@"; do
        line=$(grep -n -m1 -F -- "$marker" "$file" | cut -d: -f1 || true)
        test -n "$line" || fail "$file does not contain ordered marker: $marker"
        test "$line" -gt "$previous" || fail "$file has out-of-order marker: $marker"
        previous=$line
    done
}

contains "$project_dir/VERSION" '0.7'
contains "$project_dir/book/metadata.yaml" 'edition: "v0.7 — Expanded Jurisdiction Edition"'
contains "$project_dir/chapters/00-title.md" '### v0.7 — Expanded Jurisdiction Edition'
contains "$project_dir/README.md" 'The current release is v0.7'
test -f "$project_dir/notes/receipts-v0.7.md" || fail 'missing notes/receipts-v0.7.md'
test -f "$project_dir/releases/on-your-processor-v0.7.md" || fail 'missing frozen v0.7 manuscript'

chapter_count=$(find "$project_dir/chapters" -maxdepth 1 -type f -name '[0-9][0-9]-*.md' ! -name '00-title.md' | wc -l | tr -d ' ')
test "$chapter_count" = 32 || fail "expected 32 numbered chapters, found $chapter_count"
i=1
while [ "$i" -le 32 ]; do
    chapter_number=$(printf '%02d' "$i")
    find "$project_dir/chapters" -maxdepth 1 -type f -name "$chapter_number-*.md" | grep -q . || fail "missing consecutive chapter $chapter_number"
    i=$((i + 1))
done

for chapter in \
    14-your-file-does-not-exist.md \
    15-please-wait-im-writing.md \
    16-everybody-has-an-address.md \
    17-that-is-not-your-memory.md \
    19-the-cache-has-receipts.md \
    20-you-never-talked-to-the-hardware.md \
    21-the-firmware-nobody-invited.md \
    22-the-network-does-not-care-about-your-process.md \
    23-the-cpu-is-waiting.md \
    24-who-woke-me-up.md \
    31-please-stop-interrupting-me.md \
    18-memory-has-borders.md \
    25-sep-has-a-mailbox.md \
    26-the-civil-war.md \
    27-the-house-inside-the-house.md \
    28-the-hardware-family-dinner.md \
    29-shutdown.md \
    30-below-the-kernel.md \
    32-epilogue.md; do
    test -f "$project_dir/chapters/$chapter" || fail "missing v0.7 chapter: $chapter"
done

contains "$project_dir/chapters/03-xnu.md" 'congratulations on having a demolition permit'
contains "$project_dir/chapters/14-your-file-does-not-exist.md" "what's a Users"
contains "$project_dir/chapters/14-your-file-does-not-exist.md" "what's a file"
contains "$project_dir/chapters/21-the-firmware-nobody-invited.md" "what's your PID"
contains "$project_dir/chapters/21-the-firmware-nobody-invited.md" 'my what'
contains "$project_dir/chapters/30-below-the-kernel.md" 'zzz'
contains "$project_dir/chapters/31-please-stop-interrupting-me.md" 'synchronous exceptions'
contains "$project_dir/chapters/31-please-stop-interrupting-me.md" 'hardware interrupts'
contains "$project_dir/chapters/31-please-stop-interrupting-me.md" 'Mach exceptions'
contains "$project_dir/chapters/31-please-stop-interrupting-me.md" 'Unix signals'
contains "$project_dir/chapters/31-please-stop-interrupting-me.md" 'deferred work'
contains "$project_dir/chapters/32-epilogue.md" 'Hyprvisor'
not_contains "$project_dir/chapters/31-please-stop-interrupting-me.md" 'moo.'
chapter30_last_nonblank=$(awk 'NF { line=$0 } END { print line }' "$project_dir/chapters/30-below-the-kernel.md")
test "$chapter30_last_nonblank" = 'zzz' || fail 'Chapter 30 does not end at zzz.'
chapter32_last_nonblank=$(awk 'NF { line=$0 } END { print line }' "$project_dir/chapters/32-epilogue.md")
test "$chapter32_last_nonblank" = 'moo.' || fail 'Chapter 32 does not end at moo.'
test "$(count_standalone "$project_dir/chapters/32-epilogue.md")" = 1 || fail 'Chapter 32 must contain exactly one standalone moo.'

test -f "$project_dir/book/contents.txt" || fail 'missing book/contents.txt'
for part in \
    01-who-let-you-run.md \
    02-the-offices-upstairs.md \
    03-names-bytes-and-addresses.md \
    04-nobody-touched-the-hardware.md \
    05-other-worlds.md \
    06-everybody-leaves-eventually.md; do
    test -f "$project_dir/parts/$part" || fail "missing part source: $part"
    contains "$project_dir/parts/$part" '.part-title'
done
contains "$project_dir/book/reader.js" 'isPartDivider'
contains "$project_dir/book/reader.js" 'reader-page-part'
contains "$project_dir/book/book.css" '.reader-page-part'
contains "$project_dir/book/book.css" '.part-title'

for marker in \
    'parts/01-who-let-you-run.md' \
    'chapters/01-nobody-is-actually-in-charge.md' \
    'parts/02-the-offices-upstairs.md' \
    'chapters/06-sessions-and-windows.md' \
    'parts/03-names-bytes-and-addresses.md' \
    'chapters/13-macintosh-hd-is-a-diplomatic-arrangement.md' \
    'parts/04-nobody-touched-the-hardware.md' \
    'chapters/20-you-never-talked-to-the-hardware.md' \
    'parts/05-other-worlds.md' \
    'chapters/25-sep-has-a-mailbox.md' \
    'parts/06-everybody-leaves-eventually.md' \
    'chapters/28-the-hardware-family-dinner.md' \
    'chapters/32-epilogue.md'; do
    contains "$project_dir/book/contents.txt" "$marker"
done
assert_order "$project_dir/book/contents.txt" \
    'chapters/00-title.md' \
    'parts/01-who-let-you-run.md' \
    'chapters/01-nobody-is-actually-in-charge.md' \
    'chapters/05-the-children.md' \
    'parts/02-the-offices-upstairs.md' \
    'chapters/06-sessions-and-windows.md' \
    'chapters/12-sharingd-knows-a-guy.md' \
    'parts/03-names-bytes-and-addresses.md' \
    'chapters/13-macintosh-hd-is-a-diplomatic-arrangement.md' \
    'chapters/19-the-cache-has-receipts.md' \
    'parts/04-nobody-touched-the-hardware.md' \
    'chapters/20-you-never-talked-to-the-hardware.md' \
    'chapters/24-who-woke-me-up.md' \
    'parts/05-other-worlds.md' \
    'chapters/25-sep-has-a-mailbox.md' \
    'chapters/27-the-house-inside-the-house.md' \
    'parts/06-everybody-leaves-eventually.md' \
    'chapters/28-the-hardware-family-dinner.md' \
    'chapters/32-epilogue.md'

contains "$project_dir/chapters/00-title.md" '# On Your Processor'
contains "$project_dir/book/metadata.yaml" 'title: "On Your Processor"'
contains "$project_dir/book/metadata.yaml" 'author: "Efeali Bel"'
contains "$project_dir/chapters/02-the-boot-chain.md" 'Owner Identity Key'
contains "$project_dir/chapters/05-the-children.md" '`iBootd` is fictional.'
contains "$project_dir/chapters/08-trust-and-signatures.md" '`amfidd` is fictional.'
contains "$project_dir/chapters/28-hardware-family-dinner.md" 'you are all PART OF ME.'
contains "$project_dir/chapters/29-shutdown.md" 'bro really turned himself off'
contains "$project_dir/chapters/30-below-the-kernel.md" '# 30. Below the Kernel'
contains "$project_dir/chapters/30-below-the-kernel.md" 'The jurisdiction map has now left the motherboard.'
contains "$project_dir/chapters/30-below-the-kernel.md" 'wrong temporal domain.'
contains "$project_dir/chapters/30-below-the-kernel.md" 'Spacetime:'
contains "$project_dir/chapters/32-epilogue.md" '# 32. One More Jurisdiction'
not_contains "$project_dir/chapters/28-hardware-family-dinner.md" 'physically inside me'

test -f "$project_dir/notes/receipts-v0.6.md" || fail 'missing notes/receipts-v0.6.md'
test -f "$project_dir/releases/on-your-processor-v0.6.md" || fail 'missing frozen v0.6 manuscript'
contains "$project_dir/releases/on-your-processor-v0.6.md" '# 21. One More Jurisdiction'
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
contains "$project_dir/book/template.html" 'id="book-source"'
contains "$project_dir/book/template.html" 'id="reader-track"'
contains "$project_dir/book/template.html" 'id="reader-prev"'
contains "$project_dir/book/template.html" 'id="reader-next"'
contains "$project_dir/book/template.html" 'id="reader-progress"'
contains "$project_dir/book/reader.js" 'reader-page'
contains "$project_dir/book/reader.js" 'reader-page-content'
contains "$project_dir/book/reader.js" 'reader-page-oversize'
contains "$project_dir/book/reader.js" 'sourceHTML'
contains "$project_dir/book/reader.js" 'getBoundingClientRect'
contains "$project_dir/book/reader.js" 'ArrowLeft'
contains "$project_dir/book/reader.js" 'ArrowRight'
contains "$project_dir/book/reader.js" 'PageUp'
contains "$project_dir/book/reader.js" 'PageDown'
contains "$project_dir/book/reader.js" 'Home: () => { currentPage = 0; render(false); },'
contains "$project_dir/book/reader.js" 'End: () => { currentPage = lastSpreadStart(); render(false); }'
contains "$project_dir/book/reader.js" ': "instant"'
contains "$project_dir/book/book.css" '.reader-page-fixed.reader-page-oversize .back-cover'
contains "$project_dir/book/book.css" 'justify-content: flex-start;'
contains "$project_dir/book/book.css" 'font-size: clamp(2rem, 3vw, 2.8rem);'
contains "$project_dir/book/book.css" 'font-size: clamp(0.92rem, 1.2vw, 1.05rem);'
contains "$project_dir/book/book.css" 'padding: clamp(2rem, 4vw, 3rem);'
not_contains "$project_dir/book/book.css" 'column-count'
not_contains "$project_dir/book/book.css" 'column-width'
not_contains "$project_dir/book/book.css" 'column-fill'
not_contains "$project_dir/book/book.css" '.book-pages > main'
contains "$project_dir/README.md" '[Interactive HTML reader](dist/on-your-processor.html)'
contains "$project_dir/README.md" 'Left/Right arrow keys'
contains "$project_dir/manuscript.md" '# 30. Below the Kernel'
contains "$project_dir/manuscript.md" '# 32. One More Jurisdiction'

test -f "$html_file" || fail "missing $html_file"
test -f "$epub_file" || fail "missing $epub_file"
test -f "$project_dir/releases/on-your-processor-v0.5.md" || fail 'missing frozen v0.5 manuscript'

for part_marker in \
    'Part I — Who Let You Run?' \
    'Part II — The Offices Upstairs' \
    'Part III — Names, Bytes, and Addresses' \
    'Part IV — Nobody Touched the Hardware' \
    'Part V — Other Worlds' \
    'Part VI — Everybody Leaves Eventually'; do
    contains "$html_file" "$part_marker"
    epub_contains "$part_marker" "$epub_file"
done
epub_order_file=$(mktemp "${TMPDIR:-/tmp}/oyp-v07-epub.XXXXXX")
epub_nav_file=$(mktemp "${TMPDIR:-/tmp}/oyp-v07-nav.XXXXXX")
epub_opf_file=$(mktemp "${TMPDIR:-/tmp}/oyp-v07-opf.XXXXXX")
trap 'rm -f "$epub_order_file" "$epub_nav_file" "$epub_opf_file"' EXIT
epub_reading_content "$epub_file" > "$epub_order_file"
unzip -p "$epub_file" EPUB/nav.xhtml > "$epub_nav_file"
unzip -p "$epub_file" EPUB/content.opf > "$epub_opf_file"
contains "$html_file" 'role="doc-toc"'
contains "$epub_nav_file" 'epub:type="toc"'
assert_order "$epub_order_file" \
    'Part I — Who Let You Run?' \
    'Part II — The Offices Upstairs' \
    'Part III — Names, Bytes, and Addresses' \
    'Part IV — Nobody Touched the Hardware' \
    'Part V — Other Worlds' \
    'Part VI — Everybody Leaves Eventually' \
    '30. Below the Kernel' \
    '31. Please Stop Interrupting Me' \
    '32. One More Jurisdiction'
assert_order "$epub_nav_file" \
    'Part I — Who Let You Run?' \
    'Part II — The Offices Upstairs' \
    'Part III — Names, Bytes, and Addresses' \
    'Part IV — Nobody Touched the Hardware' \
    'Part V — Other Worlds' \
    'Part VI — Everybody Leaves Eventually' \
    '30. Below the Kernel' \
    '31. Please Stop Interrupting Me' \
    '32. One More Jurisdiction'
contains "$epub_opf_file" '<spine'
for navigation_marker in \
    'Part I — Who Let You Run?' \
    'Part II — The Offices Upstairs' \
    'Part III — Names, Bytes, and Addresses' \
    'Part IV — Nobody Touched the Hardware' \
    'Part V — Other Worlds' \
    'Part VI — Everybody Leaves Eventually' \
    '30. Below the Kernel' \
    '31. Please Stop Interrupting Me' \
    '32. One More Jurisdiction'; do
    navigation_href=$(grep -F -m1 -- "$navigation_marker" "$epub_nav_file" | sed -n 's/.*href="\([^"]*\)".*/\1/p')
    test -n "$navigation_href" || fail "EPUB navigation target missing: $navigation_marker"
    navigation_path=${navigation_href%%#*}
    navigation_file=${navigation_path##*/}
    navigation_id=${navigation_file%.xhtml}_xhtml
    grep -Fq -- "idref=\"$navigation_id\"" "$epub_opf_file" || fail "EPUB spine target missing: $navigation_marker"
done
assert_order "$html_file" \
    'Part I — Who Let You Run?' \
    'Part II — The Offices Upstairs' \
    'Part III — Names, Bytes, and Addresses' \
    'Part IV — Nobody Touched the Hardware' \
    'Part V — Other Worlds' \
    'Part VI — Everybody Leaves Eventually' \
    '30. Below the Kernel' \
    '31. Please Stop Interrupting Me' \
    '32. One More Jurisdiction'

contains "$html_file" '<h1 class="title">On Your Processor</h1>'
contains "$html_file" 'Efeali Bel'
contains "$html_file" 'id="front-cover"'
contains "$html_file" 'id="back-cover"'
contains "$html_file" 'Your Mac is not run by one all-powerful piece of'
contains "$html_file" 'id="reader-status"'
contains "$html_file" 'id="reader-progress"'
contains "$html_file" 'id="book-source"'
contains "$html_file" 'id="reader-track"'
contains "$html_file" 'reader-page'
contains "$html_file" 'ArrowLeft'
contains "$html_file" 'ArrowRight'
contains "$html_file" '30. Below the Kernel'
contains_with_normalized_whitespace "$html_file" '32. One More Jurisdiction'
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
epub_contains '30. Below the Kernel' "$epub_file"
epub_contains '32. One More Jurisdiction' "$epub_file"

contains "$project_dir/chapters/04-launchd.md" '# 4. launchd: Hello Children'
contains "$project_dir/chapters/00-title.md" 'Unless a passage says otherwise, local observations carried forward from the Receipts Edition came from macOS 27.0 build `26A5416b`.'
not_contains "$project_dir/chapters/04-launchd.md" 'The source conversation examined'
not_contains "$project_dir/chapters/04-launchd.md" 'The v0.3 reproduction pass'
not_contains "$project_dir/chapters/05-the-children.md" 'The v0.3 reproduction pass'
not_contains "$project_dir/chapters/08-trust-and-signatures.md" 'The v0.3 reproduction pass'
not_contains "$project_dir/chapters/12-sharingd-knows-a-guy.md" 'The earlier source-conversation build'
not_contains "$project_dir/chapters/12-sharingd-knows-a-guy.md" 'The v0.3 reproduction target'
not_contains "$project_dir/chapters/29-shutdown.md" 'The earlier source archaeology'
not_contains "$project_dir/chapters/29-shutdown.md" 'the v0.3 reproduction pass'

last_nonblank=$(awk 'NF { line=$0 } END { print line }' "$project_dir/manuscript.md")
test "$last_nonblank" = 'moo.' || fail 'manuscript does not end at moo.'
cmp -s "$project_dir/manuscript.md" "$project_dir/releases/on-your-processor-v0.7.md" || fail 'manuscript differs from frozen v0.7 manuscript'

v05_release_last_nonblank=$(awk 'NF { line=$0 } END { print line }' "$project_dir/releases/on-your-processor-v0.5.md")
test "$v05_release_last_nonblank" = 'moo.' || fail 'frozen v0.5 manuscript does not end at moo.'
contains "$project_dir/releases/on-your-processor-v0.5.md" '# 20. One More Jurisdiction'

v06_release_last_nonblank=$(awk 'NF { line=$0 } END { print line }' "$project_dir/releases/on-your-processor-v0.6.md")
test "$v06_release_last_nonblank" = 'moo.' || fail 'frozen v0.6 manuscript does not end at moo.'

test "$(count_standalone "$project_dir/manuscript.md")" = 1 || fail 'manuscript must contain exactly one standalone moo.'
test "$(count_standalone "$project_dir/releases/on-your-processor-v0.7.md")" = 1 || fail 'frozen v0.7 manuscript must contain exactly one standalone moo.'
v07_release_last_nonblank=$(awk 'NF { line=$0 } END { print line }' "$project_dir/releases/on-your-processor-v0.7.md")
test "$v07_release_last_nonblank" = 'moo.' || fail 'frozen v0.7 manuscript does not end at moo.'

printf '%s\n' 'publication check passed'

# Interactive Book Reader Design

## Goal

Turn `dist/on-your-processor.html` into a self-contained, offline book reader with front and back covers, adaptive page spreads, keyboard navigation, and book-like typography while preserving the manuscript and EPUB output.

## Reader structure

The HTML template contains one focusable reader shell. Its horizontal page flow is composed of a front cover, a blank inside cover, the generated table of contents, the manuscript body, and a back cover. CSS multi-column layout creates pages without rewriting manuscript paragraphs in JavaScript. On wide screens the viewport shows a two-page spread; narrow screens show one page.

The supplied transparent Canva PNG is copied to `book/assets/cover.png`. It is embedded into the standalone HTML by Pandoc and supplied to Pandoc as the EPUB cover. The current source is only 225 by 225 pixels, so the layout contains rather than crops it and permits a higher-resolution replacement at the same path later.

## Navigation

`book/reader.js` owns page state. Previous and next buttons, Left/Right arrows, Page Up/Page Down, Home/End, and table-of-contents links move by the active spread size. A page counter, progress bar, disabled button states, and an ARIA live announcement expose the current position. Resizing recalculates pagination while keeping the reader near the same logical page.

Motion uses a short horizontal transition and is disabled under `prefers-reduced-motion`. Print output hides controls and returns the manuscript to ordinary paged document flow.

## Typography and assets

The font stack prefers locally installed `SF Pro Text` and `SF Pro Display`, then macOS system fonts and ordinary sans-serif fallbacks. Apple font binaries are not copied, embedded, or committed. The generated HTML therefore remains distributable and does not contain absolute paths into the author's home directory.

## Back cover

`notes/synopsis.md` remains the single source of synopsis copy. The build passes it to a Lua publication filter, which appends a semantic back-cover section after the manuscript. The final manuscript file itself must still end at `moo.`; no explanatory prose is inserted after it in `manuscript.md`.

## Build and validation

`build.sh` embeds the stylesheet, reader script, and cover image in HTML, and assigns the image as the EPUB cover. `tools/check-publication.sh` verifies the front and back covers, synopsis, keyboard bindings, controls, progress UI, SF Pro local stack, self-containment, EPUB metadata and cover, and the sacred final `moo.`.

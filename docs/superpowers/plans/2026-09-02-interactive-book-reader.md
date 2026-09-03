# Interactive Book Reader Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a self-contained, keyboard-navigable HTML book with the supplied cover, synopsis back cover, adaptive spreads, and SF Pro local typography.

**Architecture:** Pandoc continues to assemble the manuscript. A focused Lua publication filter supplies cover/back matter, CSS performs horizontal column pagination, and a dependency-free reader script controls navigation and reader state.

**Tech Stack:** POSIX shell, Pandoc, Lua filter, HTML, CSS, vanilla JavaScript.

**Spec:** `docs/superpowers/specs/2026-09-02-interactive-book-reader-design.md`

## Global Constraints

- Preserve the manuscript text and its final `moo.`.
- Keep the HTML self-contained and free of absolute home-directory paths.
- Do not copy, embed, or commit Apple's OTF font files.
- Use the supplied transparent PNG without destructive image editing.
- Support two-page desktop spreads and one-page narrow layouts.
- Preserve usable print and EPUB outputs.

---

### Task 1: Publication contract

**Files:**
- Modify: `tools/check-publication.sh`

**Interfaces:**
- Consumes: generated HTML/EPUB files and publication source files.
- Produces: a failing shell check for every newly required reader behavior.

- [ ] **Step 1: Add assertions for the cover asset, embedded cover, synopsis, controls, keyboard bindings, local SF Pro names, self-containment, and EPUB cover metadata.**
- [ ] **Step 2: Run `./tools/check-publication.sh`.**
  Expected: FAIL because the cover asset and reader implementation do not exist.

### Task 2: Reader assets and document structure

**Files:**
- Create: `book/assets/cover.png`
- Create: `book/reader.js`
- Modify: `book/template.html`
- Modify: `book/remove-publication-title.lua`
- Modify: `build.sh`

**Interfaces:**
- Consumes: `notes/synopsis.md`, `book/assets/cover.png`, and Pandoc's generated body/TOC.
- Produces: `.book-reader`, `.book-pages`, `#front-cover`, `#back-cover`, `#reader-prev`, `#reader-next`, `#reader-status`, and `#reader-progress` in the generated HTML.

- [ ] **Step 1: Copy the approved Canva PNG to `book/assets/cover.png`.**
- [ ] **Step 2: Update the Lua filter to retain title de-duplication and append the synopsis as a `back-cover` section only for HTML.**
- [ ] **Step 3: Restructure the template into a semantic reader shell with cover, inside cover, TOC, manuscript flow, back cover, and controls.**
- [ ] **Step 4: Add dependency-free navigation that calculates page width/count, moves by the active spread, handles keyboard and TOC navigation, and updates accessibility state.**
- [ ] **Step 5: Update `build.sh` to embed the reader script/cover and set the EPUB cover image.**

### Task 3: Book presentation

**Files:**
- Modify: `book/book.css`

**Interfaces:**
- Consumes: the semantic reader classes and state attributes from Task 2.
- Produces: a one-page/two-page responsive reader, cover treatments, readable column pages, controls, reduced-motion behavior, and print fallback.

- [ ] **Step 1: Replace the scrolling article layout with a bounded book stage and horizontal column flow.**
- [ ] **Step 2: Add front/back cover, TOC, page furniture, controls, progress, and accessible focus styles.**
- [ ] **Step 3: Add local SF Pro typography with system fallbacks, without font binaries or external URLs.**
- [ ] **Step 4: Add narrow-screen, reduced-motion, and print rules.**

### Task 4: Build, verification, and delivery

**Files:**
- Modify: generated `manuscript.md`, `dist/on-your-processor.html`, and `dist/on-your-processor.epub`

**Interfaces:**
- Consumes: all publication source files.
- Produces: verified distributable artifacts and the requested Git commit.

- [ ] **Step 1: Run `./build.sh`.**
  Expected: exit 0 and both artifacts regenerated.
- [ ] **Step 2: Run `./tools/check-publication.sh`.**
  Expected: `publication check passed`.
- [ ] **Step 3: Run `unzip -t dist/on-your-processor.epub` and `git diff --check`.**
  Expected: no archive errors and no whitespace errors.
- [ ] **Step 4: Review `git status`, staged paths, and the final diff before committing.**
- [ ] **Step 5: Commit the complete requested publication changes and push `main` to its configured upstream.**

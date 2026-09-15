<script>
(() => {
    "use strict";

    const viewport = document.getElementById("reader-viewport");
    const track = document.getElementById("reader-track");
    const source = document.getElementById("book-source");
    const previous = document.getElementById("reader-prev");
    const next = document.getElementById("reader-next");
    const status = document.getElementById("reader-status");
    const progress = document.getElementById("reader-progress");
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

    if (!viewport || !track || !source || !previous || !next || !status || !progress) {
        return;
    }

    const sourceHTML = source.innerHTML;
    let currentPage = 0;
    let pageCount = 0;
    let pagesPerSpread = 1;
    let pageStep = 1;
    let resizeTimer;

    function lastSpreadStart() {
        return Math.max(0, Math.floor((pageCount - 1) / pagesPerSpread) * pagesPerSpread);
    }

    function render(animate = true) {
        if (!pageCount) {
            return;
        }

        currentPage = Math.max(0, Math.min(currentPage, lastSpreadStart()));
        viewport.scrollTo({
            left: currentPage * pageStep,
            behavior: animate && !reducedMotion.matches ? "smooth" : "instant"
        });

        const first = currentPage + 1;
        const last = Math.min(pageCount, currentPage + pagesPerSpread);
        status.textContent = first === last ? `Page ${first} of ${pageCount}` : `Pages ${first}–${last} of ${pageCount}`;
        progress.style.width = `${pageCount > 1 ? (last / pageCount) * 100 : 100}%`;
        previous.disabled = currentPage === 0;
        next.disabled = currentPage >= lastSpreadStart();
    }

    function createPage(className = "") {
        const page = document.createElement("section");
        const content = document.createElement("div");

        page.className = `reader-page ${className}`.trim();
        content.className = "reader-page-content";
        page.append(content);
        track.append(page);
        return { page, content };
    }

    function overflows(content) {
        return content.scrollHeight > content.clientHeight + 1;
    }

    function addDedicatedPage(section) {
        if (!section) {
            return;
        }

        const page = createPage("reader-page-fixed");
        page.content.append(section.cloneNode(true));

        if (overflows(page.content)) {
            page.page.classList.add("reader-page-oversize");
        }
    }

    function isNumberedChapter(block) {
        return block.tagName === "H1" && /^\d+\.\s/.test(block.textContent.trim());
    }

    function isPartDivider(block) {
        return block.matches("h1.part-title");
    }

    function addManuscript(main) {
        let page;
        let firstPage = true;
        let partPage;

        function startPage() {
            page = createPage();

            if (firstPage) {
                page.page.id = "book-content";
                firstPage = false;
            }
        }

        for (const block of main.children) {
            if (isPartDivider(block)) {
                partPage = createPage("reader-page-part");
                partPage.content.append(block.cloneNode(true));

                page = undefined;
                continue;
            }

            if (partPage) {
                partPage.content.append(block.cloneNode(true));

                if (overflows(partPage.content)) {
                    partPage.page.classList.add("reader-page-oversize");
                }

                partPage = undefined;
                page = undefined;
                continue;
            }

            if (isNumberedChapter(block)) {
                page = undefined;
            }

            if (!page) {
                startPage();
            }

            const copy = block.cloneNode(true);
            page.content.append(copy);

            if (!overflows(page.content)) {
                continue;
            }

            page.content.removeChild(copy);

            if (page.content.children.length) {
                startPage();
                page.content.append(copy);
            } else {
                page.content.append(copy);
            }

            if (overflows(page.content)) {
                page.page.classList.add("reader-page-oversize");
            }
        }
    }

    function removeFallbackIds() {
        for (const element of source.querySelectorAll("[id]")) {
            element.removeAttribute("id");
        }
    }

    function measurePageWidth() {
        pagesPerSpread = window.matchMedia("(min-width: 64rem)").matches ? 2 : 1;
        const gap = Number.parseFloat(getComputedStyle(track).gap) || 0;
        const pageWidth = (viewport.clientWidth - gap * (pagesPerSpread - 1)) / pagesPerSpread;

        track.style.setProperty("--reader-page-width", `${pageWidth}px`);
        pageStep = pageWidth + gap;
    }

    function rebuild(progressRatio = 0) {
        document.documentElement.classList.add("reader-building");
        measurePageWidth();
        track.replaceChildren();

        const working = document.createElement("div");
        working.innerHTML = sourceHTML;

        const frontCover = working.querySelector("#front-cover");
        const titlePage = working.querySelector(".inside-cover");
        const contents = working.querySelector("nav[role='doc-toc']");
        const manuscript = working.querySelector("main");
        const backCover = working.querySelector("#back-cover");

        if (backCover) {
            backCover.remove();
        }

        addDedicatedPage(frontCover);
        addDedicatedPage(titlePage);
        addDedicatedPage(contents);

        if (manuscript) {
            addManuscript(manuscript);
        }

        addDedicatedPage(backCover);
        pageCount = track.querySelectorAll(".reader-page").length;

        if (!pageCount) {
            document.documentElement.classList.remove("reader-building");
            return;
        }

        currentPage = Math.min(
            Math.floor(progressRatio * Math.max(0, pageCount - 1) / pagesPerSpread) * pagesPerSpread,
            lastSpreadStart()
        );

        removeFallbackIds();
        document.documentElement.classList.remove("reader-building");
        document.documentElement.classList.add("reader-ready");
        render(false);
    }

    function turn(direction) {
        currentPage += direction * pagesPerSpread;
        render();
    }

    function goToElement(target) {
        const targetBox = target.getBoundingClientRect();
        const viewportBox = viewport.getBoundingClientRect();
        const absoluteLeft = viewport.scrollLeft + targetBox.left - viewportBox.left;
        currentPage = Math.floor(Math.max(0, absoluteLeft) / pageStep / pagesPerSpread) * pagesPerSpread;
        render();
    }

    previous.addEventListener("click", () => turn(-1));
    next.addEventListener("click", () => turn(1));

    document.addEventListener("keydown", (event) => {
        if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) {
            return;
        }

        const actions = {
            ArrowLeft: () => turn(-1),
            PageUp: () => turn(-1),
            ArrowRight: () => turn(1),
            PageDown: () => turn(1),
            Home: () => { currentPage = 0; render(false); },
            End: () => { currentPage = lastSpreadStart(); render(false); }
        };

        if (actions[event.key]) {
            event.preventDefault();
            actions[event.key]();
        }
    });

    track.addEventListener("click", (event) => {
        const link = event.target.closest("a[href^='#']");

        if (!link) {
            return;
        }

        const targetId = decodeURIComponent(link.hash.slice(1));
        const target = Array.from(track.querySelectorAll("[id]")).find((element) => element.id === targetId);

        if (target) {
            event.preventDefault();
            goToElement(target);
            history.replaceState(null, "", link.hash);
        }
    });

    window.addEventListener("resize", () => {
        window.clearTimeout(resizeTimer);
        resizeTimer = window.setTimeout(() => {
            const progressRatio = pageCount > 1 ? currentPage / (pageCount - 1) : 0;
            rebuild(progressRatio);
        }, 120);
    });

    window.addEventListener("load", () => rebuild(), { once: true });
    document.fonts?.ready.then(() => rebuild());
    rebuild();
})();
</script>

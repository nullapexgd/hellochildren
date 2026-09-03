<script>
(() => {
    "use strict";

    const viewport = document.getElementById("reader-viewport");
    const pages = document.getElementById("reader-pages");
    const previous = document.getElementById("reader-prev");
    const next = document.getElementById("reader-next");
    const status = document.getElementById("reader-status");
    const progress = document.getElementById("reader-progress");
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

    if (!viewport || !pages || !previous || !next || !status || !progress) {
        return;
    }

    let currentPage = 0;
    let pageCount = 1;
    let pagesPerSpread = 1;
    let pageStep = 1;
    let resizeTimer;

    function lastSpreadStart() {
        return Math.max(0, Math.floor((pageCount - 1) / pagesPerSpread) * pagesPerSpread);
    }

    function render(animate = true) {
        currentPage = Math.max(0, Math.min(currentPage, lastSpreadStart()));
        viewport.scrollTo({
            left: currentPage * pageStep,
            behavior: animate && !reducedMotion.matches ? "smooth" : "auto"
        });

        const first = currentPage + 1;
        const last = Math.min(pageCount, currentPage + pagesPerSpread);
        status.textContent = first === last ? `Page ${first} of ${pageCount}` : `Pages ${first}–${last} of ${pageCount}`;
        progress.style.width = `${pageCount > 1 ? (last / pageCount) * 100 : 100}%`;
        previous.disabled = currentPage === 0;
        next.disabled = currentPage >= lastSpreadStart();
    }

    function measure() {
        const previousCount = pageCount;
        const previousPage = currentPage;
        pagesPerSpread = window.matchMedia("(min-width: 64rem)").matches ? 2 : 1;

        const styles = getComputedStyle(pages);
        const gap = Number.parseFloat(styles.columnGap) || 0;
        const pageWidth = (viewport.clientWidth - gap * (pagesPerSpread - 1)) / pagesPerSpread;
        pages.style.setProperty("--page-width", `${pageWidth}px`);
        pages.style.setProperty("--spread-pages", pagesPerSpread);

        pageStep = pageWidth + gap;
        pageCount = Math.max(1, Math.round((pages.scrollWidth + gap) / pageStep));

        const progressRatio = previousCount > 1 ? previousPage / (previousCount - 1) : 0;
        currentPage = Math.min(
            Math.floor(progressRatio * Math.max(0, pageCount - 1) / pagesPerSpread) * pagesPerSpread,
            lastSpreadStart()
        );
        render(false);
    }

    function turn(direction) {
        currentPage += direction * pagesPerSpread;
        render();
    }

    function goToElement(target) {
        const viewportBox = viewport.getBoundingClientRect();
        const targetBox = target.getBoundingClientRect();
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
            Home: () => { currentPage = 0; render(); },
            End: () => { currentPage = lastSpreadStart(); render(); }
        };

        if (actions[event.key]) {
            event.preventDefault();
            actions[event.key]();
        }
    });

    pages.addEventListener("click", (event) => {
        const link = event.target.closest("a[href^='#']");

        if (!link) {
            return;
        }

        const target = document.getElementById(decodeURIComponent(link.hash.slice(1)));

        if (target) {
            event.preventDefault();
            goToElement(target);
            history.replaceState(null, "", link.hash);
        }
    });

    window.addEventListener("resize", () => {
        window.clearTimeout(resizeTimer);
        resizeTimer = window.setTimeout(measure, 120);
    });

    window.addEventListener("load", measure, { once: true });
    document.fonts?.ready.then(measure);
    measure();
})();
</script>

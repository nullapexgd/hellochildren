# On Your Processor

## A Field Guide to the Dysfunctional Family Living Inside Your Mac

Your Mac is not run by one all-powerful piece of software. It is run by a dysfunctional bureaucracy of mutually suspicious components, each of which possesses exactly enough authority to ruin somebody else’s afternoon.

The argument of this book is simple:

> There is no single highest form of authority inside a modern computer. Authority has a jurisdiction.

The current release is v0.6, Below the Kernel: 21 chapters and roughly 27,000 words of technical comedy, evidence notes, and mutually hostile components. The files in [`chapters/`](chapters/) are the source of truth. Read the generated [`manuscript.md`](manuscript.md), open the [interactive HTML edition](dist/on-your-processor.html), or use the frozen [v0.6 manuscript](releases/on-your-processor-v0.6.md). The frozen [v0.5 manuscript](releases/on-your-processor-v0.5.md) remains available as historical material.

## Read the book

- [Title and editorial note](chapters/00-title.md)
- [1. Nobody Is Actually in Charge](chapters/01-nobody-is-actually-in-charge.md)
- [2. Boot ROM and the People Who Were Here First](chapters/02-the-boot-chain.md)
- [3. XNU: I Am Literally the Kernel](chapters/03-xnu.md)
- [4. launchd: Hello Children](chapters/04-launchd.md)
- [5. The Children](chapters/05-the-children.md)
- [6. Who Owns the User Session?](chapters/06-sessions-and-windows.md)
- [7. Those Are My Windows](chapters/07-those-are-my-windows.md)
- [8. Trust and Signatures](chapters/08-trust-and-signatures.md)
- [9. Policy Is Not Enforcement](chapters/09-policy-is-not-enforcement.md)
- [10. Consent Is Its Own Authority](chapters/10-consent-is-its-own-authority.md)
- [11. The Entitlement Bureaucracy](chapters/11-the-entitlement-bureaucracy.md)
- [12. sharingd Knows a Guy](chapters/12-sharingd-knows-a-guy.md)
- [13. Macintosh HD Is a Diplomatic Arrangement](chapters/13-macintosh-hd-is-a-diplomatic-arrangement.md)
- [14. Memory Has Borders](chapters/14-memory-has-borders.md)
- [15. SEP Has a Mailbox](chapters/15-sep-has-a-mailbox.md)
- [16. The Civil War](chapters/16-the-civil-war.md)
- [17. The House Inside the House](chapters/17-the-house-inside-the-house.md)
- [18. Hardware Family Dinner](chapters/18-hardware-family-dinner.md)
- [19. At the Mercy of the Kernel](chapters/19-shutdown.md)
- [20. Below the Kernel](chapters/20-below-the-kernel.md)
- [21. One More Jurisdiction](chapters/21-epilogue.md)

## Editing

Edit chapter files, then rebuild from this directory:

```sh
./build.sh
```

The build has no third-party dependencies. It concatenates `chapters/*.md` in filename order and replaces only the generated `manuscript.md`.

Recurring jokes are tracked in [notes/canon.md](notes/canon.md); major claims and their evidence status are indexed in [notes/fact-check-ledger.md](notes/fact-check-ledger.md). The frozen [v0.3 receipts file](notes/receipts-v0.3.md) records the original Receipts Edition evidence. The [v0.5 receipts file](notes/receipts-v0.5.md) carries that work forward and adds sources for the expanded jurisdictions.

## Technical-integrity rule

> If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.

Character dialogue is dramatization. It may compress a documented relationship, but it cannot silently grant a component powers the evidence does not support. Deliberately fake entities are called fake on the page.

## Draft status

v0.6 is the current edition, not the previous edition with a new sticker. Stable claims still prefer primary public sources; build-specific observations name their build; reverse-engineered behavior and inference stay labeled. One chapter deliberately breaks the architecture for the joke and says so at the door.

The reading sequence still ends at `moo.` Back matter stays outside the manuscript.

## Formatted editions

- [Interactive HTML reader](dist/on-your-processor.html) — opens as a one-page or two-page book, with buttons plus Left/Right arrow keys, Page Up/Page Down, Home, and End navigation.
- [EPUB edition](dist/on-your-processor.epub) — includes the front cover for ordinary ebook readers.

The HTML edition embeds its styles, script, and cover image so it can be opened offline. It prefers SF Pro from the local operating system and falls back to the native system sans-serif; Apple font binaries are not included in the repository.

# On Your Processor

## A Field Guide to the Dysfunctional Family Living Inside Your Mac

Your Mac is not run by one all-powerful piece of software. It is run by a dysfunctional bureaucracy of mutually suspicious components, each of which possesses exactly enough authority to ruin somebody else’s afternoon.

The argument of this book is simple:

> There is no single highest form of authority inside a modern computer. Authority has a jurisdiction.

This branch is building v0.4, the Jurisdiction Edition. It grows sideways from the frozen Receipts Edition: new chapters add new kinds of authority instead of stretching “root is not God” into a hostage situation. The files in [`chapters/`](chapters/) are the source of truth. [`manuscript.md`](manuscript.md) is a generated continuous reading copy. The frozen [v0.1](releases/HELLO-CHILDREN-v0.1.md), [v0.2](releases/HELLO-CHILDREN-v0.2.md), and [v0.3 Receipts Edition](releases/on-your-processor-v0.3.md) remain available for comparison. The v0.3 freeze is 10,028 words; its POSIX `cksum` is `2755083667 66343`.

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
- Chapters 9–11: policy, consent, and entitlement bureaucracy (in progress)
- [12. sharingd Knows a Guy](chapters/12-sharingd-knows-a-guy.md)
- Chapter 13: filesystem jurisdiction (in progress)
- [14. Memory Has Borders](chapters/14-memory-has-borders.md)
- [15. SEP Has a Mailbox](chapters/15-sep-has-a-mailbox.md)
- Chapter 16: the explicitly impossible Civil War (in progress)
- Chapter 17: lightweight Apple virtualization (in progress)
- [18. Hardware Family Dinner](chapters/17-hardware-family-dinner.md) *(renumber pending)*
- [19. At the Mercy of the Kernel](chapters/18-shutdown.md) *(renumber pending)*
- [20. One More Jurisdiction](chapters/19-epilogue.md) *(renumber pending)*

## Editing

Edit chapter files, then rebuild from this directory:

```sh
./build.sh
```

The build has no third-party dependencies. It concatenates `chapters/*.md` in filename order and replaces only the generated `manuscript.md`.

The editorial voice and evidence rules live in [STYLE.md](STYLE.md). Recurring jokes are tracked in [notes/canon.md](notes/canon.md); major claims and their evidence status are indexed in [notes/fact-check-ledger.md](notes/fact-check-ledger.md). The frozen [v0.3 receipts file](notes/receipts-v0.3.md) records the Receipts Edition evidence. The working [v0.4 receipts file](notes/receipts-v0.4.md) carries that evidence forward and adds sources for the new jurisdictions.

## Technical-integrity rule

> If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.

Character dialogue is dramatization. It may compress a documented relationship, but it cannot silently grant a component powers the evidence does not support. Deliberately fake entities are called fake on the page.

## Draft status

v0.4 is an active expansion, not the Receipts Edition with a new sticker. Stable claims still prefer primary public sources; build-specific observations name their build; reverse-engineered behavior and inference stay labeled. One chapter deliberately breaks the architecture for the joke and says so at the door.

The reading sequence still ends at `moo.` Back matter stays outside the manuscript.

## Formatted editions

- [Interactive HTML reader](dist/on-your-processor.html) — opens as a one-page or two-page book, with buttons plus Left/Right arrow keys, Page Up/Page Down, Home, and End navigation.
- [EPUB edition](dist/on-your-processor.epub) — includes the front cover for ordinary ebook readers.

The HTML edition embeds its styles, script, and cover image so it can be opened offline. It prefers SF Pro from the local operating system and falls back to the native system sans-serif; Apple font binaries are not included in the repository.

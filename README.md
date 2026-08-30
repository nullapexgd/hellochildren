# HELLO CHILDREN

## A Field Guide to the Dysfunctional Family Living Inside Your Mac

Your Mac is not run by one all-powerful piece of software. It is run by a dysfunctional bureaucracy of mutually suspicious components, each of which possesses exactly enough authority to ruin somebody else’s afternoon.

The argument of this book is simple:

> There is no single highest form of authority inside a modern computer. Authority has a jurisdiction.

This directory contains the v0.2 editor pass. The files in [`chapters/`](chapters/) are the source of truth. [`manuscript.md`](manuscript.md) is a generated continuous reading copy. The frozen [v0.1 manuscript](releases/HELLO-CHILDREN-v0.1.md) remains available for comparison.

## Read the book

- [Title and editorial note](chapters/00-title.md)
- [1. Nobody Is Actually in Charge](chapters/01-nobody-is-actually-in-charge.md)
- [2. Boot ROM and the People Who Were Here First](chapters/02-the-boot-chain.md)
- [3. XNU: I Am Literally the Kernel](chapters/03-xnu.md)
- [4. launchd: Hello Children](chapters/04-launchd.md)
- [5. The Children](chapters/05-the-children.md)
- [6. Sessions, Windows, and Ceremonial Root](chapters/06-sessions-and-windows.md)
- [7. Trust and Signatures](chapters/07-trust-and-signatures.md)
- [8. sharingd Knows a Guy](chapters/08-neighborhood-services.md)
- [9. Memory Has Borders](chapters/09-memory-and-borders.md)
- [10. SEP Has a Mailbox](chapters/10-sep-and-the-mailbox.md)
- [11. Hardware Family Dinner](chapters/11-hardware-family-dinner.md)
- [12. At the Mercy of the Kernel](chapters/12-shutdown.md)
- [13. One More Jurisdiction](chapters/13-epilogue.md)

## Editing

Edit chapter files, then rebuild from this directory:

```sh
./build.sh
```

The build has no third-party dependencies. It concatenates `chapters/*.md` in filename order and replaces only the generated `manuscript.md`.

The editorial voice and evidence rules live in [STYLE.md](STYLE.md). Recurring jokes are tracked in [notes/canon.md](notes/canon.md); major claims and their evidence status are tracked in [notes/fact-check-ledger.md](notes/fact-check-ledger.md).

## Technical-integrity rule

> If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.

Character dialogue is dramatization. It may compress a documented relationship, but it cannot silently grant a component powers the evidence does not support. Deliberately fake entities are called fake on the page.

## Draft status

v0.2 is a structural compression pass. It adds no lore, characters, or chapters. Research notes remain separate so the comedy can move while the claims stay auditable. The next planned milestone is the v0.3 receipts edition.
# hellochildren

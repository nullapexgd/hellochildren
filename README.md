# On Your Processor

## A Field Guide to the Dysfunctional Family Living Inside Your Mac

Your Mac is not run by one all-powerful piece of software. It is run by a dysfunctional bureaucracy of mutually suspicious components, each of which possesses exactly enough authority to ruin somebody else’s afternoon.

The argument of this book is simple:

> There is no single highest form of authority inside a modern computer. Authority has a jurisdiction.

The current release is v0.7, the Expanded Jurisdiction Edition: 32 chapters and roughly 42,000 words of technical comedy, evidence notes, and mutually hostile components. The chapter and part files are the source of truth; [`book/contents.txt`](book/contents.txt) controls reading order. Read the generated [`manuscript.md`](manuscript.md), open the [interactive HTML reader](dist/on-your-processor.html), or use the frozen [v0.7 manuscript](releases/on-your-processor-v0.7.md). Frozen [v0.6](releases/on-your-processor-v0.6.md) and [v0.5](releases/on-your-processor-v0.5.md) manuscripts remain available as historical editions.

## Read the book

- [Title and editorial note](chapters/00-title.md)

### Part I — Who Let You Run?

- [1. Nobody Is Actually in Charge](chapters/01-nobody-is-actually-in-charge.md)
- [2. Boot ROM and the People Who Were Here First](chapters/02-the-boot-chain.md)
- [3. XNU: I Am Literally the Kernel](chapters/03-xnu.md)
- [4. launchd: Hello Children](chapters/04-launchd.md)
- [5. The Children](chapters/05-the-children.md)

### Part II — The Offices Upstairs

- [6. Who Owns the User Session?](chapters/06-sessions-and-windows.md)
- [7. Those Are My Windows](chapters/07-those-are-my-windows.md)
- [8. Trust and Signatures](chapters/08-trust-and-signatures.md)
- [9. Policy Is Not Enforcement](chapters/09-policy-is-not-enforcement.md)
- [10. Consent Is Its Own Authority](chapters/10-consent-is-its-own-authority.md)
- [11. The Entitlement Bureaucracy](chapters/11-the-entitlement-bureaucracy.md)
- [12. sharingd Knows a Guy](chapters/12-sharingd-knows-a-guy.md)

### Part III — Names, Bytes, and Addresses

- [13. Macintosh HD Is a Diplomatic Arrangement](chapters/13-macintosh-hd-is-a-diplomatic-arrangement.md)
- [14. Your File Does Not Exist](chapters/14-your-file-does-not-exist.md)
- [15. Please Wait, I’m Writing](chapters/15-please-wait-im-writing.md)
- [16. Everybody Has an Address](chapters/16-everybody-has-an-address.md)
- [17. That Is Not Your Memory](chapters/17-that-is-not-your-memory.md)
- [18. Memory Has Borders](chapters/18-memory-has-borders.md)
- [19. The Cache Has Receipts](chapters/19-the-cache-has-receipts.md)

### Part IV — Nobody Touched the Hardware

- [20. You Never Talked to the Hardware](chapters/20-you-never-talked-to-the-hardware.md)
- [21. The Firmware Nobody Invited](chapters/21-the-firmware-nobody-invited.md)
- [22. The Network Does Not Care About Your Process](chapters/22-the-network-does-not-care-about-your-process.md)
- [23. The CPU Is Waiting](chapters/23-the-cpu-is-waiting.md)
- [24. Who Woke Me Up?](chapters/24-who-woke-me-up.md)

### Part V — Other Worlds

- [25. SEP Has a Mailbox](chapters/25-sep-has-a-mailbox.md)
- [26. The Civil War](chapters/26-the-civil-war.md)
- [27. The House Inside the House](chapters/27-the-house-inside-the-house.md)

### Part VI — Everybody Leaves Eventually

- [28. Below the Kernel](chapters/28-below-the-kernel.md)
- [29. Please Stop Interrupting Me](chapters/29-please-stop-interrupting-me.md)
- [30. The Hardware Family Dinner](chapters/30-hardware-family-dinner.md)
- [31. At the Mercy of the Kernel](chapters/31-shutdown.md)
- [32. One More Jurisdiction](chapters/32-epilogue.md)

## Editing

Edit chapter files, then rebuild from this directory:

```sh
./build.sh
```

The assembly order lives in [`book/contents.txt`](book/contents.txt). The build concatenates exactly those chapter and part sources, then generates Markdown, HTML, and EPUB editions when Pandoc is available.

Recurring jokes are tracked in [notes/canon.md](notes/canon.md); major claims and their evidence status are indexed in [notes/fact-check-ledger.md](notes/fact-check-ledger.md). The [v0.7 receipts](notes/receipts-v0.7.md) record evidence added for the expanded jurisdictions, while the earlier v0.3, v0.5, and v0.6 receipts remain part of the audit trail.

## Technical-integrity rule

> If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.

Character dialogue is dramatization. It may compress a documented relationship, but it cannot silently grant a component powers the evidence does not support. Deliberately fake entities are called fake on the page.

## Draft status

v0.7 is the current edition. Stable claims prefer primary public sources; build-specific observations name their build; reverse-engineered behavior and inference stay labeled. One chapter deliberately breaks the architecture for the joke and says so at the door.

The reading sequence still ends at `moo.` Back matter stays outside the manuscript.

## Formatted editions

- [Interactive HTML reader](dist/on-your-processor.html) — opens as a one-page or two-page book, with buttons plus Left/Right arrow keys, Page Up/Page Down, Home, and End navigation.
- [EPUB edition](dist/on-your-processor.epub) — includes the front cover for ordinary ebook readers.

The HTML edition embeds its styles, script, and cover image so it can be opened offline. It prefers SF Pro from the local operating system and falls back to the native system sans-serif; Apple font binaries are not included in the repository.

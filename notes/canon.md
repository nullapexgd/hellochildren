# Canon Ledger

This ledger records callbacks, not claims of implementation.

| Canon element | Primary chapter | Status | Rule |
|---|---|---|---|
| “Authority has a jurisdiction” | 01 | Thesis | Every chapter advances or complicates it. |
| XNU: “I am literally the kernel” | 03 | Dramatized | XNU is powerful; the next speaker names the jurisdiction. |
| launchd: “hello children” | 04 | Dramatized | Parental voice for userspace service organization. |
| Fake launchd, UID 2 | 05 | Deliberately fictional experiment | Always call it fake; never confuse UID 2 with PID 1. |
| Owner Identity Key | 02, 08 | Documented role plus dramatization | Ownership permits users to re-sign LocalPolicy. Do not turn OIK into a daemon, universal owner, AMFI superior, or participant in an invented private protocol. |
| Fictional `iBootd` | 05, 30 | Deliberately fictional character | The extra `d`, persistence, genealogy, personality, and SEP “microservice” role are OYP inventions. A boot-stage handoff is not Unix process parentage. Any excerpt of the Chapter 30 startup exchange must retain the fictional-status disclaimer. |
| “GenuineApple™” / “branding transcends ISA” | 08 | Dramatized fake-launchd exchange | A self-applied label is not a signing authority; preserve the ISA punchline. |
| Fictional `amfidd` | 08, 09, 30 | Deliberately fictional character | `/usr/libexec/amfid` is real; the extra `d`, genealogy, personality, and SEP “microservice” role are not. Preserve “cryptographically rigorous and socially vulnerable”: acquaintance is not a trust primitive. Any excerpt of the Chapter 30 startup exchange must retain the fictional-status disclaimer. |
| OIK/AMFI personal hostility | 08 | Dramatized jurisdiction dispute | Both offices are real, but the personal beef, meeting, reporting relationship, and rank are invented. OIK discusses owner-authorized LocalPolicy; AMFI discusses code-signing trust and enforcement. |
| Gatekeeper: “that's your résumé.” | 09 | Dramatized | Root's title does not turn a policy decision into automatic approval. |
| Politics line | 06, 29 | Narrator satire | “Apple and modern politics still argue about who invented this” is not an Apple-intent claim. |
| LaunchAngels | 05 | Observed undocumented artifact | Quote spellings; complete semantics remain unknown. |
| `amfid`: “signature?” | 08 | Dramatized | Not a protocol string. Keep it short. |
| `sharingd` | 12 | Observed binary plus conservative role | Entitlement names show access, not every action taken. Exact counts are build-specific: 132 on the v0.3 target and 134 in later observations. |
| Finder: “this is Macintosh HD.” / APFS: “which one.” | 13 | Dramatized | The unified view does not erase System/Data volume roles. |
| SSV: “that's adorable.” / seal: “explain yourself.” | 13 | Dramatized | Separate comic voices, never separate daemons. Writing bytes is not producing boot-accepted sealed state. |
| SSD: “what's a Users” / “what's a file” | 14 | Protected dramatization | Preserve the exact XNU pathname exchange. The ordinary filesystem/block-storage boundary supplies the joke; it is not a command transcript or a universal inability of firmware to interpret filesystems. |
| File existence needs a reference and view | 14 | Documented distinctions plus dramatization | Pathname, directory entry, object, open reference, mount, and snapshot differ. Chapter 13 retains APFS System/Data and SSV; Chapter 14 hands bytes to Chapter 15. |
| Save, write, close, sync, and durable state | 15 | Documented distinctions plus dramatization | A successful ordinary write has real visibility semantics. Close is not full sync; full sync has the documented device-scoped guarantee. Do not invent exact NAND placement or one universal I/O pipeline. |
| Clean exit is not a durability certificate | 15, 31 | Scoped callback | Chapter 15 teaches the mechanism; Chapter 31 may cash it in one short shutdown callback. A process ending does not by itself certify completion of every related write. |
| Everybody has an address | 16 | Documented distinctions plus dramatization | Virtual, physical, I/O-virtual, and MMIO coordinates need their own map or interface. Hexadecimal is not a deed. |
| Unified is not communal | 17 | Documented Metal/VM boundary | One memory architecture does not erase mappings, storage modes, synchronization, lifetime, capacity, or permissions. |
| Memory has borders | 18 | Documented enforcement plus labeled DART reverse engineering | Preserve the MMU/DART loading-dock energy and all four protected lines; do not invent Apple topology. |
| The cache has receipts | 19 | Generic Arm architecture plus dramatization | Cache kind, object, visibility, ordering, authorization, and persistence must remain separate. No M4 cache-topology guesses. |
| You never talked to the hardware | 20 | Scoped DriverKit example | Client, managed connection, driver, mapping, queue, device, and completion have distinct contracts. Never present the route as universal. |
| Firmware: “my what” | 21 | Protected dramatization | Preserve the exact launchd/PID exchange. Firmware is a composite character outside the ordinary userspace process model, not a hidden daemon. |
| The packet leaves without your PID | 22 | Protocol boundary | Local attribution and explicit higher-level identity remain real; PID is not automatically an Internet routing field. |
| The CPU is waiting | 23 | State-vocabulary joke | Always name thread, core, pipeline, operation, or user. Async moves waiting; it does not remove latency. |
| Who woke me up? | 24 | Multi-boundary callback | Waiter, timer, callback, service activation, core, display, and system wake remain distinct. Interrupt routing belongs to Chapter 29. |
| Please stop interrupting me | 29 | Architectural bridge | Synchronous exception, hardware interrupt, Mach exception, Unix signal, deferred work, and wake remain separate. Do not name Hyprvisor. |
| SEP mailbox dap-up | 25 | Dramatized around a hardware mechanism | `/var/mail` and the SEP mailbox are explicitly not the same thing. |
| Efeali sends launchd to SEP | 26 | Deliberately impossible dramatization | `send` is invented; AirDrop does not cross trust domains; the evidence note must say the architecture argues against the scene. |
| iBoot: “personal matters.” | 26 | Dramatized | iBoot accepts the impossible premise for personal reasons and never explains them. |
| “The jurisdiction map has now left the motherboard.” | 28 | Grounded-to-infrastructure hinge | Keep the standalone line. Execution, integration, power control, stored energy, supply, ownership, regulation, and taxation are distinct relations, never one universal technical or political hierarchy. |
| Power Management / Battery / Charger | 28 | Dramatized hardware ensemble | Power Management is an ensemble role, not a single universal component. Battery makes the scene a laptop example; supply, stored energy, and charging remain distinct. |
| IRS interruption | 28 | Explicit satire | IRS interrupts Government's unfinished explanation. Taxation is not a literal rung in electricity delivery. Governmental roles vary by jurisdiction. |
| SEP: “on your grid.” | 28 | Dramatized infrastructure callback | Preserve the power plant's “I AM LITERALLY THE POWER PLANT.” setup. Generation does not imply command of the grid. |
| Causality: “wrong temporal domain.” | 28 | Metaphysical satire | Preserve the Big Bang / initial-conditions exchange verbatim. It is not a factual cosmology claim or an extension of the evidence chain. |
| Spacetime: “zzz” | 28 | Metaphysical satire | The unanswered summons and `zzz` close Chapter 28, not the book. No `moo.` appears in Chapter 28. |
| Hardware family dinner | 30 | Full-cast set piece | Dinner is the last full-cast story chapter. Each character gets one scoped authority and one boundary; no expansion chapter follows it. |
| SoC: “you are all PART OF ME.” | 30 | Dramatized platform-integration claim | “Part of me” is the required wording; do not replace it with literal-topology language. Sharing a platform does not imply one processor domain, trust domain, governed object, policy engine, or universal command hierarchy. |
| SEP: “entrepreneurship.” | 30 | Deliberately fictional startup exchange | `iBootd` and `amfidd` are reused fictional characters, not real SEP services. Generated excerpts must carry that status with the exchange. |
| “at the mercy of the kernel” | 31 | Reproduced launchd string | On build 26A5416b the sentence is split across adjacent extracted strings. Quote the reconstructed sentence exactly; do not invent the private call sequence. |
| XNU's ten CPU cores | 31 | Observed machine fact plus dramatization | The author's Mac is a 10-core M4 (4 performance, 6 efficiency). Never generalize the count to every M4 configuration, and never repossess two cores. SEP tells XNU to turn them off. |
| Five-Minute Kernel | 31 | Dramatized total-AP shutdown | Preserve the challenge, P-core/E-core departures, interrupted `NOW WHO EXECUTES YOUR CO—`, execution-ceased card, and SEP reaction. The exact sequence is not an Apple shutdown transcript; ordinary idling/offlining, sleep, and coordinated shutdown remain distinct. |
| Linux on Larpintosh uses Hyprland | 32 | Deliberately fictional guest | The second “on your virtual machine” punctures the Hyprland flex. Do not answer the compatibility question; it sets up the final `moo.` |
| hyprvisor: “moo.” | 32 | Deliberately fictional outside character | `moo.` is the single final nonblank line of the book. |

## Recurring dynamics

### XNU and launchd

XNU supplies the mechanisms that make processes and userspace possible. launchd organizes much of the service civilization built from them. XNU can end the meeting. launchd writes the agenda, books the room, calls the attendees, and knows why three of them are named `com.apple.somethingd`.

### Badges are not rank

An entitlement permits a client to cross a protected boundary. A component that crosses many boundaries may carry more entitlements than the authority behind one of those boundaries. Raw count measures breadth of granted access, not constitutional seniority.

### The hardware refrain

Software announces policy. Hardware makes refusal physical. Then hardware meets other hardware with a different map.

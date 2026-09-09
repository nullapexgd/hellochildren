# Canon Ledger

This ledger records callbacks, not claims of implementation.

| Canon element | Primary chapter | Status | Rule |
|---|---|---|---|
| “Authority has a jurisdiction” | 01 | Thesis | Every chapter advances or complicates it. |
| XNU: “I am literally the kernel” | 03 | Dramatized | XNU is powerful; the next speaker names the jurisdiction. |
| launchd: “hello children” | 04 | Dramatized | Parental voice for userspace service organization. |
| Fake launchd, UID 2 | 05 | Deliberately fictional experiment | Always call it fake; never confuse UID 2 with PID 1. |
| “GenuineApple™” / “branding transcends ISA” | 08 | Dramatized fake-launchd exchange | A self-applied label is not a signing authority; preserve the ISA punchline. |
| Gatekeeper: “that's your résumé.” | 09 | Dramatized | Root's title does not turn a policy decision into automatic approval. |
| Politics line | 06 | Narrator satire | “Apple and modern politics still argue about who invented this” is not an Apple-intent claim. |
| LaunchAngels | 05 | Observed undocumented artifact | Quote spellings; complete semantics remain unknown. |
| `amfid`: “signature?” | 08 | Dramatized | Not a protocol string. Keep it short. |
| `sharingd` | 12 | Observed binary plus conservative role | Entitlement names show access, not every action taken. Exact counts are build-specific: 132 on the v0.3 target, 134 in the earlier and current v0.4 observations. |
| Finder: “this is Macintosh HD.” / APFS: “which one.” | 13 | Dramatized | The unified view does not erase System/Data volume roles. |
| SSV: “that's adorable.” / seal: “explain yourself.” | 13 | Dramatized | Separate comic voices, never separate daemons. Writing bytes is not producing boot-accepted sealed state. |
| SEP mailbox dap-up | 15 | Dramatized around a hardware mechanism | `/var/mail` and the SEP mailbox are explicitly not the same thing. |
| Efeali sends launchd to SEP | 16 | Deliberately impossible dramatization | `send` is invented; AirDrop does not cross trust domains; the evidence note must say the architecture argues against the scene. |
| iBoot: “personal matters.” | 16 | Dramatized | iBoot accepts the impossible premise for personal reasons and never explains them. |
| Hardware family dinner | 18 | Full-cast set piece | Each character gets one scoped authority and one boundary. |
| “at the mercy of the kernel” | 19 | Reproduced launchd string | On build 26A5416b the sentence is split across adjacent extracted strings. Quote the reconstructed sentence exactly; do not invent the private call sequence. |
| XNU's ten CPU cores | 19 | Observed machine fact plus dramatization | The author's Mac is a 10-core M4 (4 performance, 6 efficiency). Never generalize the count to every M4 configuration, and never repossess two cores. SEP still tells XNU to turn off all ten. |
| hyprvisor: “moo.” | 20 | Deliberately fictional outside character | `moo.` is the final nonblank line of the book. |

## Recurring dynamics

### XNU and launchd

XNU supplies the mechanisms that make processes and userspace possible. launchd organizes much of the service civilization built from them. XNU can end the meeting. launchd writes the agenda, books the room, calls the attendees, and knows why three of them are named `com.apple.somethingd`.

### Badges are not rank

An entitlement permits a client to cross a protected boundary. A component that crosses many boundaries may carry more entitlements than the authority behind one of those boundaries. Raw count measures breadth of granted access, not constitutional seniority.

### The hardware refrain

Software announces policy. Hardware makes refusal physical. Then hardware meets other hardware with a different map.

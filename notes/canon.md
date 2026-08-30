# Canon Ledger

This ledger records callbacks, not claims of implementation.

| Canon element | Primary chapter | Status | Rule |
|---|---|---|---|
| “Authority has a jurisdiction” | 01 | Thesis | Every chapter advances or complicates it. |
| XNU: “I am literally the kernel” | 03 | Dramatized | XNU is powerful; the next speaker names the jurisdiction. |
| launchd: “hello children” | 04 | Dramatized | Parental voice for userspace service organization. |
| Fake launchd, UID 2 | 05 | Deliberately fictional experiment | Always call it fake; never confuse UID 2 with PID 1. |
| LaunchAngels | 05 | Observed undocumented artifact | Quote spellings; complete semantics remain unknown. |
| `amfid`: “signature?” | 07 | Dramatized | Not a protocol string. Keep it short. |
| `sharingd` | 08 | Observed binary plus conservative role | Entitlement names show access, not every action taken. Exact counts are build-specific: 132 on the v0.3 target, 134 in the earlier observation. |
| SEP mailbox dap-up | 10 | Dramatized around a hardware mechanism | `/var/mail` and the SEP mailbox are explicitly not the same thing. |
| Hardware family dinner | 11 | Full-cast set piece | Each character gets one scoped authority and one boundary. |
| “at the mercy of the kernel” | 12 | Reproduced launchd string | On build 26A5416b the sentence is split across adjacent extracted strings. Quote the reconstructed sentence exactly; do not invent the private call sequence. |
| hyprvisor: “moo.” | 13 | Deliberately fictional outside character | `moo.` is the final nonblank line of the book. |

## Recurring dynamics

### XNU and launchd

XNU supplies the mechanisms that make processes and userspace possible. launchd organizes much of the service civilization built from them. XNU can end the meeting. launchd writes the agenda, books the room, calls the attendees, and knows why three of them are named `com.apple.somethingd`.

### Badges are not rank

An entitlement permits a client to cross a protected boundary. A component that crosses many boundaries may carry more entitlements than the authority behind one of those boundaries. Raw count measures breadth of granted access, not constitutional seniority.

### The hardware refrain

Software announces policy. Hardware makes refusal physical. Then hardware meets other hardware with a different map.

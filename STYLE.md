# Editorial Style and Technical Integrity

## The voice

Write as if a patient systems engineer and an impatient stand-up comic have been assigned the same desk. The engineer refuses to lie. The comic refuses to let a correct explanation become oatmeal.

The book is affectionate institutional comedy. Components are relatives, officials, bouncers, landlords, customs agents, and exhausted civil servants because those roles clarify boundaries. The joke should emerge from the boundary itself.

Good:

```text
Device:
I'm hardware.

DART:
that's awesome bro
```

The joke works because hardware status does not exempt a DMA agent from IOMMU mappings.

Weak:

> DART is so random and quirky.

That could describe anything and therefore explains nothing.

## Evidence categories

### Proven

State documented or directly observed behavior plainly. Record a primary source or reproducible observation in the ledger.

### Inferred

Use visible qualifiers: “appears,” “suggests,” “conceptually,” “the evidence supports,” or “we infer.” Say what evidence does and does not establish.

### Undocumented string or artifact

Quote the exact observed spelling. Identify the binary, path, entitlement, or other source when known. Do not turn a name into a job description.

`LaunchAngel` proves that the string `LaunchAngel` exists in the examined artifacts. It does not, by itself, tell us what a LaunchAngel completely is.

## Dialogue

- Dialogue is dramatization unless explicitly identified as an observed string.
- Keep exchanges short. The component with the narrowest vocabulary often wins.
- Avoid making every chapter a transcript. Alternate dialogue with essays, diagrams, footnotes, and one-line reversals.
- Profanity is punctuation, not insulation. If removing it kills the joke, the joke was dead already.
- Preserve recurring voices: XNU grandiose; launchd parental; SEP concise; DART unimpressed; `amfid` nearly monosyllabic; `sharingd` calmly overqualified.

## Names and capitalization

- `launchd`, `amfid`, `sharingd`, and command names stay lowercase.
- XNU, SEP, AMFI, DART, MMU, GPU, ANE, APFS, and DMA stay uppercase.
- “Application Processor” may become “AP” after first use.
- “Secure Enclave” describes the security subsystem; “Secure Enclave Processor” or “SEP” describes its processor where that distinction matters.

## Canon safety rails

- Fake launchd is a deliberately created Unix user named `launchd`, UID 2. It is not Apple’s PID 1 process and it is not canonically part of macOS.
- LaunchAngels are treated as an observed undocumented Apple concept. Their complete semantics remain unknown.
- “signature?” is comic dialogue assigned to `amfid`, not a claimed private protocol string.
- The SEP mailbox is a hardware messaging metaphor grounded in mailbox-style communication; no private message opcode or payload meaning is invented.
- “At the mercy of the kernel” is reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b, split across two adjacent extracted strings; preserve the reconstructed sentence exactly.
- The hyprvisor is an outside character and not an Apple component.

## The revision test

Every major section must do four things:

1. Name an authority.
2. Define its jurisdiction.
3. Show the edge of that jurisdiction.
4. Earn at least one joke from the collision.

If a passage only lists facts, find the collision. If it only performs comedy, find the claim. If neither can be found, evict the passage from the house.

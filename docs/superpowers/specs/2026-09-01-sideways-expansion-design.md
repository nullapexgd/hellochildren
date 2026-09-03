# On Your Processor Sideways Expansion Design

## Objective

Expand the current 13-chapter, roughly 10,000-word manuscript into a 19-chapter technical-comedy book of approximately 24,000–25,000 words. Growth must come from genuinely different jurisdictions, not repeated explanations that root is not omnipotent.

The final three narrative beats remain sacred and consecutive:

1. Hardware Family Dinner
2. At the Mercy of the Kernel
3. One More Jurisdiction, ending at `moo.`

## Editorial test

Every substantial section must:

1. Name an authority.
2. Define what it governs.
3. Show the boundary of that authority.
4. Earn a joke from a collision at that boundary.

If a passage repeats the thesis without introducing a new authority, object, boundary, or enforcement mechanism, cut it.

## Technical-integrity rule

> If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.

Dialogue is dramatization unless the text explicitly identifies a reproduced string. Entitlement names and counts prove granted signed claims on the named build; they do not prove runtime use, server authorization, or complete private semantics.

## Chapter architecture

| Chapter | Working title | Exclusive responsibility |
|---:|---|---|
| 1 | Nobody Is Actually in Charge | Establish authority as relational and scoped. |
| 2 | Boot ROM and the People Who Were Here First | Establish authority through precedence and verified handoff. |
| 3 | XNU: I Am Literally the Kernel | Define kernel authority and its Application Processor jurisdiction. |
| 4 | launchd: Hello Children | Define service lifecycle, bootstrap domains, and userspace organization. |
| 5 | The Children | Distinguish daemons, agents, fake launchd, and undocumented LaunchAngels. |
| 6 | Who Owns the User Session? | Cover authenticated session creation, per-user services, and session state. |
| 7 | Those Are My Windows | Cover graphical objects, composition, input delivery, GPU work, and display boundaries. |
| 8 | Trust and Signatures | Cover code identity, signing, trust caches, and AMFI without making one daemon king. |
| 9 | Policy Is Not Enforcement | Separate evaluation, blocking, detection, and remediation across Gatekeeper, `syspolicyd`, XProtect, and MRT. |
| 10 | Consent Is Its Own Authority | Explain TCC, user approval, protected resources, code identity, and Full Disk Access. |
| 11 | The Entitlement Bureaucracy | Explain capability credentials, issuers, enforcement, and why badge count is not rank. |
| 12 | sharingd Knows a Guy | Use one broad entitlement surface as a conservative case study in crossing boundaries. |
| 13 | Macintosh HD Is a Diplomatic Arrangement | Separate visible paths, writable state, snapshots, seals, and boot-authoritative filesystem state. |
| 14 | Memory Has Borders | Explain address spaces, MMU translation, IOMMU/DART mappings, DMA, and physical enforcement. |
| 15 | SEP Has a Mailbox | Explain communication across a separate processor and security domain without implying command authority. |
| 16 | The House Inside the House | Introduce Hypervisor.framework and Virtualization.framework lightly through host-versus-guest jurisdiction. |
| 17 | The Hardware Family Dinner | Bring the jurisdictions together for the climax. |
| 18 | At the Mercy of the Kernel | Show XNU ending the current world during shutdown. |
| 19 | One More Jurisdiction | Introduce Hyprvisor as an outside character and make the guest kernel somebody else’s tenant. |

## Middle-book separation

Chapters 6–12 must not become seven variations of the same security chapter:

- Chapter 6 owns authenticated session formation.
- Chapter 7 owns graphical government.
- Chapter 8 owns code identity and trust primitives.
- Chapter 9 owns policy stages and security operations.
- Chapter 10 owns consent.
- Chapter 11 owns capability credentials.
- Chapter 12 demonstrates credential breadth through `sharingd`.

Existing Chapter 6 is split between Chapters 6 and 7. Existing Chapter 7 is refocused on code identity; Gatekeeper and remediation material moves to Chapter 9. Existing Chapter 8 becomes Chapter 12 after Chapter 11 establishes the general entitlement model.

## Filesystem jurisdiction

Chapter 13 is not an APFS tutorial. It asks who defines the visible, writable, and boot-valid reality of the machine.

Its six sections are:

1. **Which Macintosh HD?** Begin with Finder's single-disk presentation and APFS containers containing role-specific volumes.
2. **Two volumes in a very convincing coat** Explain the System/Data volume group and firmlinks as the machinery behind a unified directory view.
3. **Root meets mount state** Separate process credentials from whether the mounted view is writable.
4. **The filesystem state, plural** Use snapshots to add time and selection to the meaning of filesystem state.
5. **The seal would like a word** Make SSV the climax: changing bytes is not the same authority as producing a seal-valid state accepted by normal secure boot.
6. **Namespace lies politely** Return from APFS specifics to the broader claim that paths provide a coherent interface over negotiated storage jurisdictions.

Keep three layers distinct throughout:

- permission to write;
- ability to see a path in a particular mounted or namespace view;
- whether the resulting state is boot-authoritative and seal-valid.

SSV is the climax, not the entire plot. The chapter starts with the visible namespace, proceeds through volumes, firmlinks, mount state, and snapshots, and only then reaches the seal. `mount namespace` is not used as a macOS term without a precise XNU/macOS receipt; prefer `mounted view` or `namespace view`.

Primary evidence starts with [Apple's Role of Apple File System](https://support.apple.com/guide/security/seca6147599e/web), [Apple's Signed system volume security](https://support.apple.com/guide/security/signed-system-volume-security-secd698747c9/web), and [WWDC19: What's New in Apple File Systems](https://developer.apple.com/videos/play/wwdc2019/710/). NTFS and ext4 receive at most one contextual sentence; the chapter does not become a comparative-filesystems survey.

## Virtualization depth limit

Chapter 16 teaches one concept:

> A kernel can be sovereign inside a virtual machine and still be a tenant outside it.

Hypervisor.framework receives a short description as lower-level virtual CPU and guest-memory machinery. Virtualization.framework receives a short description as the higher-level configuration and operation of virtual machines. The chapter does not teach VMCS internals, trap taxonomy, nested page tables, or SVM-versus-VMX history.

The chapter ends with conceptual foreshadowing rather than the Hyprvisor character. Chapter 19 introduces Hyprvisor and delivers the ring-0 exchange for the first time. Nothing follows `moo.` in the reading sequence.

## Compression layer

Use portable blockquote sidebars of 120–300 words:

- **Three Different Ways to Say No** in Chapter 10: root, TCC consent, and entitlement.
- **The Badge Census** in Chapter 11: build-labeled comparisons among Console, Safari, `sharingd`, `amfid`, and MRT.
- **Case File: An Entitlement Name Is Not a Confession** in Chapter 11.
- **The path is lying politely again** in Chapter 13: a brief `/private` historical/path-indirection note.
- **The Mailboxes Are Not Related** in Chapter 15: `/var/mail` versus the SEP mailbox.
- **The Abandoned Apartments** in Chapter 16: one brief ring 1/ring 2 joke without teaching x86 privilege history.

Use seven editable fenced-text diagrams:

- Chapter 1: jurisdiction map.
- Chapters 6–7: login and graphical-session path.
- Chapters 8–11: identity, policy, consent, entitlement, and enforcement desks.
- Chapter 13: visible namespace, System/Data volumes, snapshot, and boot-selected state.
- Chapter 14: process, device, and physical address maps.
- Chapter 15: AP-to-SEP communication boundary.
- Chapter 16: host, VM process/frameworks, guest kernel, and guest userspace.

Diagrams replace repeated prose. They do not decorate already-clear explanations.

## Evidence architecture

The reading copy carries visible qualifiers, not dense receipt identifiers. `notes/receipts-v0.3.md` or its successor records the complete evidence chain.

Add these receipt families:

- `PUB-TCC-*`: Apple privacy, consent, and protected-resource documentation.
- `OBS-TCC-*`: build-specific observations, separated from public guarantees.
- `PUB-ENT-*`: public entitlement and code-signing documentation.
- `OBS-ENT-*`: exact entitlement XML, selected values, and top-level counts from the named build.
- `PUB-POLICY-*`: Apple documentation for Gatekeeper, XProtect, and remediation.
- `OBS-POLICY-*`: observable `syspolicyd` and MRT artifacts without invented call flows.
- `PUB-FS-*`: Apple documentation for APFS containers, volume roles, volume groups, firmlinks, snapshots, SSV, and seal verification.
- `OBS-FS-*`: build-specific mounted-volume, snapshot, or path observations whose commands and output limits are recorded exactly.
- `PUB-VIRT-*`: official Hypervisor.framework and Virtualization.framework documentation.
- `DRAM-HYPR-*`: Hyprvisor dialogue, explicitly fictionalized and outside Apple.

Each chapter should rely on two to four load-bearing technical claims. Supporting detail belongs in receipts or a short sidebar.

## Build contract

- `chapters/*.md` are the source of truth.
- `./build.sh` concatenates chapters into `manuscript.md` in filename order.
- The build rejects a reading copy whose final nonblank line is not `moo.`
- When Pandoc is installed, the build also generates `dist/on-your-processor.html` and `dist/on-your-processor.epub` using `book/metadata.yaml`, `book/template.html`, and `book/book.css`.
- Do not hand-edit generated outputs as the only copy of a manuscript change.
- Preserve unrelated uncommitted build, styling, synopsis, and distribution work.

## Protected material

All lines in `notes/editorial-protections.md` remain verbatim. Canon jokes in `notes/canon.md` remain present. Chapter 17 is the climax, Chapter 18 the denouement, and Chapter 19 the epilogue after renumbering.

The approved additions are:

> Privilege can end a world without understanding it. That is power, not government. Apple and modern politics still argue about who invented this.

and:

```text
fake launchd:
GenuineApple™.

amfid:
that isn't a signing authority.
it isn't even a CPU vendor string
on this architecture.

fake launchd:
branding transcends ISA.

amfid:
leave.
```

The approved Gatekeeper exchange ends:

```text
root:
I am the administrator.

Gatekeeper:
that's your résumé.
```

The filesystem chapter protects these exchanges:

```text
Finder:
this is Macintosh HD.

APFS:
which one.

Finder:
the one called Macintosh HD.

APFS:
which one.
```

and:

```text
root:
I own /System.

APFS:
no.

root:
I am root.

SSV:
that's adorable.

root:
remount it writable.

seal:
explain yourself.
```

`SSV` and `seal` are separate comic voices for escalation, not a claim that they are independent daemons or policy services.

## Target allocation

Aim for approximately 24,800 words. Chapter 13 receives 1,400–1,600 words; most other chapters receive 1,100–1,600 words; the ensemble climax receives about 1,800; shutdown about 1,000; and the epilogue about 400. Word counts are guardrails, not quotas.

## Acceptance criteria

- Nineteen numbered chapters exist in the intended order.
- The manuscript is approximately 24,000–25,000 words without padding passages.
- Chapters 6–12 each own a distinct authority boundary.
- Chapter 13 keeps write permission, visible namespace, and boot-valid state distinct.
- Virtualization remains accessible and Apple-first.
- Every new factual claim is sourced, reproduced, or visibly labeled as inference.
- Every sidebar and diagram replaces explanatory prose.
- All protected lines and recurring canon jokes remain.
- `./build.sh` exits successfully and produces `manuscript.md`; HTML and EPUB are produced when Pandoc is available.
- The final nonblank line is exactly `moo.`

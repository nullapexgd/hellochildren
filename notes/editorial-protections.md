# v0.2 editorial protections

The editor pass may change surrounding paragraphs but must preserve these lines verbatim.

> The command `sudo` is not a letter from the king. It is a credential accepted by some offices.

> The kernel can end the meeting.
>
> launchd knows why the meeting was scheduled.

> A cable should not be a constitutional amendment.

> The address of city hall is public.
>
> This does not make your email a statute.

> Policy without enforcement is a wish.
>
> Enforcement without policy is a very fast misunderstanding.

> The DRAM cells store charge and have never heard of root.

> Authority through abstraction is the friendliest form of lying in the house.

```text
XNU:
I'm literally the kernel.

SEP:
on your processor
```

The final nonblank line remains:

> moo.

No prose may follow it in the assembled manuscript.

## Structural protections

- Chapter 11 is the climax.
- Chapter 12 is the denouement.
- Chapter 13 is the epilogue.
- v0.2 adds no chapters, lore, or characters.
- Repeated comic callbacks may remain. Repeated explanations must earn their space.
- Technical qualifiers survive compression even when removing them would make a sentence shorter.

## Count convention

The project has fourteen chapter-source files: `00-title.md` plus Chapters 1 through 13. The reading copy therefore has thirteen numbered chapters and one title/editorial-note file. No chapter is missing.

## v0.3 authority protections

The following additions are established reading-copy material. Preserve their wording and their status as dialogue or narrator satire.

> Privilege can end a world without understanding it. That is power, not government. Apple and modern politics still argue about who invented this.

This is narrator satire, not a claim about Apple's intent or a claim that modern politics has a single inventor.

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

```text
root:
I am the administrator.

Gatekeeper:
that's your résumé.
```

The fake-launchd experiment remains explicitly fake: UID 2 is neither PID 1 nor launchd authority.

The final nonblank line remains exactly:

> moo.

## v0.4 impossible-chapter protections

Chapter 26 is openly impossible. Preserve this sequence and never convert it into a technical mechanism:

```text
efeali@sheetofpaper ~ % id -u
501

efeali@sheetofpaper ~ % file /sbin/launchd
/sbin/launchd: Mach-O 64-bit executable arm64e

efeali@sheetofpaper ~ % send /sbin/launchd SEP
sent.
```

Preserve the paired disclaimers:

> This is impossible.

> **AirDrop works across trust domains.**

> This is also false.

Preserve SPTM's objection, iBoot's answer, and the evidence-note conclusion:

```text
SPTM:
AirDrop does not work across trust domains.

iBoot:
apparently it does now.

XNU:
WHY ARE YOU ACCEPTING THIS

iBoot:
personal matters.
```

> The sentence connecting the real nouns is where the trouble begins.

The chapter must remain labeled dramatization. It must never acquire an exploit explanation, magical entitlement, SEP migration protocol, or real `send` command.

The Chapter 31 core count remains a machine-specific observation. The v0.6 Five-Minute Kernel protection below supersedes the shorter staging of that exchange. Do not generalize the count to every M4 configuration or silently turn it back into eight.

## Structural protections (v0.4, updated for v0.6)

- The reading copy has twenty-one numbered chapters plus `00-title.md`.
- Chapter 26 is the openly impossible Civil War.
- Chapter 27 introduces Apple virtualization lightly and does not spend the Hyprvisor reveal.
- Chapter 28 is Below the Kernel; its `zzz` ends the chapter, not the book.
- Chapter 29 is the interrupt bridge and the final expansion chapter.
- Chapter 30 is the Hardware Family Dinner climax; no new jurisdiction follows it.
- Chapter 31 is the shutdown denouement.
- Chapter 32 is the Hyprvisor epilogue.
- No reading-copy prose follows `moo.`

Preserve Chapter 32's final Larpintosh exchange immediately before Hyprvisor clears its throat:

```text
Linux on larpintosh:
I use Hyprland.

hyprvisor:
on your virtual machine.

Linux on larpintosh:
...can Hyprland run on a VM
```

Do not answer the question. The answer is `moo.`

## v0.6 trust-family protections

`amfidd` remains explicitly fictional on first appearance. Preserve this exchange verbatim:

```text
launchd:
I know him.

amfidd:
noted.

Gatekeeper:
developer cannot be verified.

amfidd:
also noted.

SEP:
I know him too.

amfidd:
okay that's actually pretty compelling.

Gatekeeper:
THAT IS NOT HOW CODE SIGNING WORKS.

launchd:
that's my boy 🥹
```

Trimming may remove setup around the exchange, but it must not remove the “socially vulnerable” reversal: `amfidd` is cryptographically rigorous, then treats two claims of acquaintance as compelling. Acquaintance is not a trust primitive.

OIK and AMFI may argue only across their documented jurisdiction boundary. OIK concerns owner-authorized LocalPolicy; AMFI concerns code-signing trust and enforcement. Their personal hostility, meeting, rank, and any reporting relationship are dramatization, never evidence of a private protocol.

## v0.6 SoC dinner protections

Chapter 30 is the Hardware Family Dinner. Preserve this exchange verbatim:

```text
SoC:
okay.

XNU:
what.

SoC:
I have been listening to all of you
argue about who owns the machine.

SEP:
not me.
I have my security domain.

XNU:
I run the operating system.

GPU:
I render.

ANE:
tensor.

DART:
papers.

SoC:
STOP SAYING PAPERS.

SoC:
you are all PART OF ME.

XNU:
see? my SoC.

SEP:
our SoC.

SoC:
THAT WAS NOT THE POINT.
```

Use **part of me** and do not replace it with literal-topology language. The surrounding prose must distinguish sharing one platform from executing in one processor domain, sharing one trust domain, or governing the same object. The SoC is not one policy engine or a universal commander, and the scene must not assert undocumented die or package topology. SEP retains its separate processor and security domain.

Preserve the embedded-startup exchange verbatim:

```text
SoC:
who the fuck are those two.

SEP:
my daemons.

SoC:
you have DAEMONS now?

SEP:
microservices 🤝

SoC:
YOU ARE A SECURITY COPROCESSOR.

SEP:
entrepreneurship.
```

`iBootd` and `amfidd` are already-labeled fictional characters reused from Chapters 5 and 8, not Apple components or real SEP services. That disclaimer must remain with generated excerpts of this exchange.

## v0.6 Five-Minute Kernel protections

Preserve the challenge verbatim and do not explain the joke between its lines:

```text
XNU:
I HAVE TEN CPU CORES.

SEP:
correct.

XNU:
you don't.

SEP:
correct.

XNU:
therefore I win.

SEP:
turn them off then.

XNU:
STOP FUCKING SAYING THAT.
```

Preserve the later departures and interruption verbatim:

```text
XNU:
fine.

XNU:
P-cores offline.

P-cores:
bye.

XNU:
E-cores offline.

E-cores:
bye.

XNU:
HAHA.

XNU:
NOW WHO EXECUTES YOUR CO—
```

The next card and SEP reaction are one uninterrupted protected beat:

```text
[Application Processor execution ceased]

SEP:
...

SEP:
bro really turned himself off
```

The ten-core count is the author's observed 10-core M4 (four performance and six efficiency cores), not a claim about every M4 configuration. Dialogue, core responses, exact sequence, and SEP's reaction are dramatization, not a literal Apple shutdown transcript. Ordinary core idling/offlining, sleep, and coordinated shutdown remain distinct from the intentionally compressed execution-ceased card. Do not claim SEP necessarily remains conversationally active after the exact real-world event.

Preserve the chapter's returning thesis exactly:

> Privilege can end a world without understanding it. That is power, not government. Apple and modern politics still argue about who invented this.

## v0.6 Below the Kernel protections

Chapter 28 follows different dependency relations, not a universal technical or political hierarchy. Keep execution, integration, power control, stored energy, electrical supply, ownership, regulation, and taxation distinct. Power Management must remain labeled as a dramatized ensemble role. The battery scene is a laptop example. Keep the following exchange verbatim:

```text
XNU:
I control execution.

SoC:
on which hardware?

Power Management:
while powered how?

Battery:
using whose energy?

Charger:
whose energy?

Battery:
GET THE FUCK OUT.
```

Preserve this exact standalone hinge:

> The jurisdiction map has now left the motherboard.

Infrastructure ownership and governmental roles remain conditional on jurisdiction. Before Government enters, preserve a visible satire heading and explicit fictional-status framing. IRS interrupts Government's explanation; it is never a literal electricity-delivery rung. Preserve:

```text
Power Plant:
I AM LITERALLY THE POWER PLANT.

SEP:
on your grid.
```

The metaphysical postscript is satire, not an extension of the evidence chain or an explanation of cosmology. Preserve the final exchanges verbatim, with no prose between them or after them in Chapter 28:

```text
Power Plant:
Physics.

Physics:
what.

Power Plant:
who authorized the Big Bang.

Physics:
that's not really—

Power Plant:
WHO SIGNED OFF ON
INITIAL CONDITIONS

Causality:
I object.

Physics:
on what grounds

Causality:
you're asking for authorization
before there was a "before."

Power Plant:
wrong jurisdiction?

Causality:
wrong temporal domain.
```

```text
Physics:
Spacetime?

Spacetime:
...

Physics:
Spacetime?

Spacetime:
zzz
```

Chapter 28 contains no `moo.`. Chapter 32 changes only its chapter number for this expansion: preserve the Larpintosh question, the breathing beat, and exactly one final `moo.` outside the dialogue block. Nothing follows it in the reading sequence.

## v0.7 demolition-permit protection

Preserve the Chapter 3 exchange verbatim:

```text
XNU:
I can destroy the entire userspace.

launchd:
congratulations on having a demolition permit
```

The exchange is dramatization around the established XNU/launchd authority boundary. Keep one compact nearby distinction between destructive authority and service organization; do not explain the joke again.

## v0.7 storage protections

Preserve the Chapter 14 exchange verbatim:

```text
XNU:
read /Users/efeali/book.txt.

SSD:
what's a Users

XNU:
...

SSD:
what's a file
```

The exchange dramatizes the ordinary filesystem/block-storage boundary. Keep the nearby scope once; do not turn it into a literal command trace, a single documented SSD component, or a universal claim about what firmware can understand.

Chapter 13 retains APFS volume roles, firmlinks, mount state, snapshots, and SSV. Its “the write succeeded” exchange concerns boot-accepted sealed content, not power-loss durability. Chapter 14 owns names, object/open lifetime, and view-relative existence. Chapter 15 owns acceptance, write/close/sync distinctions and durability, including the narrow documented F_FULLFSYNC guarantee and error/device qualification.

Chapter 31's callback must preserve the distinction that a clean process exit does not by itself certify durable storage. It should cash Chapter 15's lesson without retelling it.

## v0.7 address, memory, and cache protections

Chapter 16 owns address vocabulary: CPU virtual, physical, I/O virtual/device-visible, and MMIO. A numeric address is never a universal deed, and no illustrative value is a real mapping trace.

Chapter 17 owns reservation, backing, residency, faults, sharing, copy-on-write, compression, and unified-memory scope. Never equate a successful allocation with immediate physical residency or unified memory with unrestricted access.

Chapter 18 retains these lines verbatim:

```text
Policy without enforcement is a wish. Enforcement without policy is a very fast misunderstanding.
The DRAM cells store charge and have never heard of root.
A cable should not be a constitutional amendment.
DART:
absolutely fucking not.
```

Apple's public documentation calls the DMA boundary an IOMMU; public Asahi reverse engineering supplies the DART name. Do not merge those evidence classes or invent current Apple-silicon topology.

Chapter 19 owns CPU-cache locality, coherence, visibility, ordering, and cache-kind ambiguity. It must not claim a specific M4 cache hierarchy. CPU-cache writeback is never storage durability, and coherence never grants authorization or repairs an unsynchronized program.

## v0.7 driver and firmware protections

Chapter 20 uses one documented DriverKit client/driver path to show delegation. It must explicitly reject a universal I/O pipeline and preserve alternate kernel, framework, polling, and controlled direct paths. Queue acceptance, submission, completion, and callback are separate receipts.

Preserve the Chapter 21 exchange verbatim:

```text
launchd:
I manage userspace.

firmware:
cool.

launchd:
what's your PID

firmware:
my what
```

“firmware” is a composite dramatized character, not a real Apple process. Do not give it a PID, launchd label, universal boot path, or cross-generation controller topology. `iBootd` and `amfidd` remain explicitly fictional elsewhere.

## v0.7 network, waiting, and wake protections

Chapter 22 must state both qualifications: local policy may attribute sockets to processes, and higher-level protocols may explicitly carry identity. Its socket-to-link route is illustrative, not universal.

Chapter 23 separates runnable, running, blocked, spinning, core idle, and pipeline stall. Do not invent private XNU scheduler policy or M4 microarchitecture. Asynchronous code waits elsewhere; it does not remove latency.

Chapter 24 always asks what woke. Thread eligibility, timer expiry, callback delivery, service activation, processor/display activity, and system wake are not synonyms. It may point toward interrupt routing but must not teach or spend Chapter 29's interrupt material.

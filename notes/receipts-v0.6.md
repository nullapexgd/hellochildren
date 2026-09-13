# v0.6 Receipts — Evidence Delta

This file records claims added after the frozen v0.5 receipts. The evidence classes and publication rules defined in `notes/receipts-v0.5.md` still apply.

## PUB-OIK-001 — Owner Identity Key and LocalPolicy

Apple Platform Security calls access to the Owner Identity Key (OIK) “Ownership” and says that Ownership is required to allow users to re-sign LocalPolicy after policy or software changes. Apple says the OIK is normally protected by user passwords and measurements of the operating system and policy. For a second operating-system installation, Apple describes an explicit-consent flow that hands Ownership from users of the first operating system to users of the second.

Source: <https://support.apple.com/guide/security/contents-of-a-localpolicy-file-for-a-mac-with-apple-silicon-secc745a0845/web>

Supports: Chapter 2's narrow distinction between authorization involving LocalPolicy and universal machine ownership.

Does **not** establish that OIK is a daemon, a general code-signing oracle, AMFI's superior, or part of a private OIK↔AMFI runtime protocol.

## DRAM-IBOOTD-001 — fictional iBootd

`iBootd` is an invented character. Apple does not ship a component by that name. The names, dialogue, genealogy, persistence claims, and interpersonal motives in this scene are dramatization.

Supports: Chapter 5's joke about daemon-shaped names not conferring daemon office.

Does **not** establish software, process, or protocol existence.

## DRAM-PARENT-001 — boot stages argue about parenthood

The Chapter 5 argument turns boot-stage handoff and Unix process parentage into an invented family dispute. The names, dialogue, genealogy, persistence claims, and interpersonal motives in this scene are dramatization.

Supports: the comic distinction among a verified handoff, process parentage, and joke genealogy.

Does **not** establish software, process, or protocol existence.

## PUB-AMFI-OIK-001 — documented roles do not prove a private interaction

Apple Platform Security documents the Owner Identity Key through Ownership, the authority required for users to re-sign LocalPolicy after policy or software changes. Apple separately documents macOS code signing, trust caches, Gatekeeper, and runtime protection. Apple's published XNU source exposes kernel code-signing and trust-cache initialization, code-signing process flags, and page-level code-signing validation state.

Sources:
- OIK and LocalPolicy: <https://support.apple.com/guide/security/contents-of-a-localpolicy-file-for-a-mac-with-apple-silicon-secc745a0845/web>
- App code signing: <https://support.apple.com/guide/security/app-code-signing-process-in-macos-sec3ad8e6e53/web>
- Gatekeeper and runtime protection: <https://support.apple.com/guide/security/gatekeeper-and-runtime-protection-sec5599b66df/web>
- Trust caches: <https://support.apple.com/guide/security/trust-caches-sec7d38fbf97/web>
- XNU code-signing startup: <https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/kern/startup.c>
- XNU code-signing flags: <https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/kern/cs_blobs.h>
- XNU page validation state: <https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/vm/vm_page.h>

Supports: Chapter 8's distinction between owner-authorized LocalPolicy and code-signing trust and enforcement.

Does **not** establish an OIK↔AMFI message, call order, kernel callback, entitlement check, reporting relationship, rank, interpersonal conflict, or any other private interaction. The sources support two real nouns and their separately documented roles.

## DRAM-AMFIDD-001 — fictional amfidd and the family dispute

`amfidd` is an invented character. `/usr/libexec/amfid` is real and separately documented; the additional `d`, genealogy, dialogue, personality, and claim that launchd plus Gatekeeper produced bureaucracy belong to *On Your Processor*.

Supports: Chapters 8–9's joke that familiarity is not evidence for either code-signing trust or first-open policy.

Does **not** establish software, process, genealogy, policy, or protocol existence. The OIK/AMFI personal hostility is dramatization too.

## PUB-SOC-001 — Apple silicon integrates multiple specialized components

Apple describes M1 as a system on a chip that combines CPU, I/O, security, GPU, Neural Engine, and other technologies in one integrated platform. Apple separately describes the Secure Enclave as a dedicated secure subsystem integrated into the SoC but isolated from the main processor.

Sources:
- Apple Newsroom, “Apple unleashes M1”: <https://www.apple.com/newsroom/2020/11/apple-unleashes-m1/>
- Apple Platform Security, “The Secure Enclave”: <https://support.apple.com/guide/security/the-secure-enclave-sec59b0b31ff/web>

Supports: Chapter 18's broad integration claim and its distinction between sharing a platform and sharing a processor or security domain.

Does **not** establish that every named character has the same topology on every Apple product, that “SoC” is one policy engine, that integrated components execute in one processor domain, or that integration erases isolation, trust boundaries, or jurisdiction.

## DRAM-SOC-001 — SoC family-dinner dialogue

The SoC's voice, exasperation, family claim, and Chapter 18 dialogue are dramatization. “Part of me” names platform integration without asserting a particular die or package arrangement.

Supports: Chapter 18's family-dinner metaphor and the distinction between integration and universal authority.

Does **not** establish consciousness, command authority, a reporting hierarchy, private messages, or undocumented die or package topology.

## DRAM-SEP-STARTUP-001 — SEP claims fictional daemons

Chapter 18 seats the already-fictional `iBootd` and `amfidd` characters beside SEP and has SEP call them daemons and microservices. They remain inventions from Chapters 5 and 8, not Apple components or real SEP services.

Supports: the embedded-startup faction and entrepreneurship exchange.

Does **not** establish that SEP runs either character, that sepOS provides these services, or that the scene documents a real startup architecture, process model, or protocol.

## DRAM-FIVE-MINUTE-001 — the Five-Minute Kernel shuts itself down

Chapter 19 turns the author's existing machine-specific observation—a 10-core M4 with four performance cores and six efficiency cores, recorded as `OBS-HW-001`—into a fictional shutdown argument. The dialogue, the core responses, the exact sequence, and SEP's reaction are dramatization.

Supports: the comic distinction between authority to terminate Application Processor execution and authority to understand or govern every world that depends on it.

Does **not** establish a documented Apple shutdown transcript, core-offlining order, private message exchange, or claim that SEP necessarily remains conversationally active after the exact real-world event depicted. Ordinary core idling or offlining, sleep, and coordinated shutdown are distinct from the scene's intentionally compressed `[Application Processor execution ceased]` card.

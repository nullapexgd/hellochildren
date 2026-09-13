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

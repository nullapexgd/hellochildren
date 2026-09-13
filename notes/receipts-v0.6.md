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

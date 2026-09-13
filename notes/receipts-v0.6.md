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

## PUB-POWER-001 — platform power management and electrical supply

Apple Platform Security includes power management among peripheral-processor tasks and discusses firmware where separate processors require it. This supports a broad hardware/firmware dependency, not one controller governing the entire platform. Apple's current Mac charging guidance connects a laptop's adapter and cable to an outlet; its battery guidance distinguishes operation on stored energy from external supply. Apple also documents that a connected source may run the computer without charging its battery, and that a demanding workload can exceed the connected source's power.

Sources, checked 2026-09-13:
- Apple Platform Security, “Peripheral processor security in Mac computers”: <https://support.apple.com/guide/security/peripheral-processor-security-seca500d4f2b/web>
- Apple Support, “Charge your Mac laptop computer” (published July 30, 2026): <https://support.apple.com/en-ca/102397>
- Apple MacBook Air User Guide, “Charge the MacBook Air battery”: <https://support.apple.com/guide/macbook-air/charge-the-battery-apdbc13fd966/2026/mac/26>
- Apple Mac User Guide, “If your Mac battery status is ‘Not Charging’”: <https://support.apple.com/en-gb/guide/mac-help/mh20876/26/mac/26>

Supports: Chapter 20's distinction among execution prerequisites, platform power control, a battery's finite stored energy, external electrical supply, and charging. Existing `PUB-SOC-001` supports the platform-integration portion of the descent.

Does **not** establish a universal component named Power Management, an exact controller topology or power-state sequence, a private protocol, or internal batteries in every Mac. All dialogue and motives are fiction. No model-specific wattage, duration, charging threshold, or new shutdown claim is made.

## PUB-GRID-001 — electricity delivery and varied institutional arrangements

The U.S. Energy Information Administration describes generation, transmission, and distribution as different parts of electricity delivery. Its explanation distinguishes organizations selling electricity from utilities delivering it and gives municipal, cooperative, private, and federal examples. FERC separately identifies its U.S. role in regulating interstate transmission and wholesale electricity sales, while distinguishing retail sales outside that role. These examples support conditional institutional language; they do not establish a worldwide governance model.

Sources, checked 2026-09-13:
- U.S. EIA, “Delivery to consumers”: <https://www.eia.gov/energyexplained/electricity/delivery-to-consumers.php>
- U.S. FERC, “What FERC Does”: <https://www.ferc.gov/what-ferc-does>

Supports: Chapter 20's conventional grid example, the distinction between a utility organization and grid infrastructure, and the caution that ownership and governmental roles differ by jurisdiction. Generalizing those examples as possibilities is deliberately conditional.

Does **not** establish that every outlet is grid-connected, that generation and delivery have one owner, that a power plant commands the grid, that every government has the same authority, or that IRS/taxation is a physical stage in electrical delivery. The chapter supplies no legal or tax guidance.

## DRAM-POWER-001 — hardware and infrastructure hearing

Chapter 20's XNU, Application Processor, SoC, Power Management, Battery, Charger, Outlet, Utility, Grid, and Power Plant dialogue is dramatization. Power Management is explicitly an ensemble role for distributed platform work. Battery and Charger are a laptop example, not a universal inventory of Macs. The scene begins again after Chapter 19 through a literary reset, not a documented recovery protocol.

Supports: the power-supply quarrel, finite stored-energy interval, connected-versus-charging dispute, the motherboard hinge, and “I AM LITERALLY THE POWER PLANT.” / “on your grid.” callback.

Does **not** establish consciousness, private messages, a wiring diagram, command rank, or a universal technical/political hierarchy. Execution, integration, power control, stored energy, supply, infrastructure ownership, regulation, and taxation name distinct relationships.

## DRAM-METAPHYSICS-001 — inadmissible governmental and metaphysical postscript

Government and IRS become explicitly satirical personalities after the visible “The hearing becomes inadmissible” heading. IRS interrupts an unfinished Government explanation rather than joining an electricity-delivery ladder. Governmental capacities are qualified before the seam; the subsequent dialogue is not a description of actual administrative or tax procedure.

Physics, Causality, and Spacetime are personifications in a metaphysical postscript. The Big Bang, initial-conditions, authorization-before-a-“before,” and “wrong temporal domain” exchange is protected fiction, not a scientific explanation or sourced cosmological assertion. Spacetime's `zzz` ends Chapter 20; the unchanged Hyprvisor scene in Chapter 21 retains the book's only final `moo.`.

Supports: a deliberately visible departure from the grounded dependency argument into satire.

Does **not** extend the technical evidence chain into government or metaphysics, assert a universal political hierarchy, imply that taxation delivers electricity, or prove anything about the universe's origin.

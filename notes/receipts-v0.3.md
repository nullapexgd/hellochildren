# v0.3 Receipts — Working Evidence File

This file is the reproducibility layer for the v0.3 receipts pass. It is deliberately stricter than the prose.

## Evidence classes

- **PUB** — supported by public primary documentation.
- **OBS** — directly reproduced on the named machine/build.
- **SRC-OBS** — observed in the earlier source conversation, but not yet independently reproduced for this pass.
- **RE** — supported by public reverse-engineering work rather than Apple documentation.
- **INF** — bounded inference from evidence; the evidence does not establish the complete semantics.
- **DRAM** — dramatization. Dialogue and character voice live here unless explicitly identified as an observed string.

A claim may have more than one class. A current-build failure to reproduce a string does not prove that the earlier observation was false; it proves only that the current build is not evidence for it.

## Reproduction target

The first v0.3 reproduction pass was run on:

```text
macOS 27.0
build 26A5416b
```

The target binary for the launchd string pass was `/sbin/launchd`.

The uploaded reproduction archive records these SHA-256 hashes:

```text
/sbin/launchd         d22838ef07a8c6e63f1692cccca48e1a7e22e6d65349dacdc203fc513086f36e
/usr/libexec/amfid    896ed6b66560cc7e8abdea69f42c36e51ed033962b062556ebd2e801a9910944
/usr/libexec/sharingd 3cd91f7e6c896f21ff59238eb81733b8fac4365bce260c027d9d0b95b3164a35
```

The same archive identifies `launchd` as `com.apple.xpc.launchd` / Darwin Bootstrapper `3298.1.1`, `amfid` as `com.apple.amfid`, and `sharingd` as `com.apple.sharingd`.

## Local reproduction results

| Evidence ID | Claim / artifact | Class | v0.3 result | Publication rule |
|---|---|---|---|---|
| OBS-LAUNCHD-001 | `_ThrottleInterval set to zero. You're not that important. Ignoring.` | OBS | Reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b. | May quote exactly and name the build. Do not infer the complete runtime path from the string. |
| OBS-LAUNCHD-002 | `rlimit(3)? Really?` | OBS | Reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b. | May quote exactly and name the build. |
| OBS-LAUNCHD-003 | `XPC bundles can't have KeepAlive, they can't even set it as a plist key, how did we get here?` | OBS | Reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b. | May quote exactly; do not infer the complete runtime path. |
| OBS-ANGEL-001 | `LaunchAngel`, `__Angel`, LaunchAngels paths, and `Failed to resolve LaunchAngel: error=%s: %d, caller=%s` | OBS + INF | Reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b. Three path spellings were observed: `/System/Library/LaunchAngels/`, `/System/AppleInternal/Library/LaunchAngels/`, and `/AppleInternal/Library/LaunchAngels/`. | Names, paths, and diagnostic are observable. Complete semantics are not. |
| OBS-ANGEL-002 | `com.apple.private.xpc.launchd.allow-submit-launch-angels` | OBS + INF | Reproduced as an exact string in `/sbin/launchd` on macOS 27.0 build 26A5416b. | Supports that launchd contains a reference/check for a private entitlement by this name. Does not establish which process carries it, its full authorization path, or LaunchAngel semantics. |
| OBS-LAUNCHD-004 | `Any processes that are still running will be abandoned to the mercy of the kernel.` | OBS | Reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b, split across two adjacent extracted strings: `(or halting) the system now. Any processes that are still running` and `will be abandoned to the mercy of the kernel.` | The split explains why a naive exact-string grep initially reported a false negative. Quote the reconstructed sentence exactly; do not invent the surrounding private call flow. |
| OBS-ENT-001 | `/usr/libexec/amfid` entitlement count = 8 | OBS | XML extraction succeeded on macOS 27.0 build 26A5416b and contains eight top-level keys. | Build-specific count. Preserve values and arrays when interpreting capabilities. |
| OBS-ENT-002 | `/usr/libexec/sharingd` entitlement count = 132 | OBS + SRC-OBS | XML extraction succeeded on macOS 27.0 build 26A5416b and contains 132 top-level keys. The earlier source-conversation build counted 134. | Count drift is itself a reason to label the build. Entitlements establish granted capability, not actual use. |
| OBS-ENT-003 | Exact `amfid` entitlement values | OBS | Current-build XML includes `com.apple.private.tcc.allow = [kTCCServiceSystemPolicyAllFiles]`, `com.apple.security.exception.iokit-user-client-class = [AppleMobileFileIntegrityUserClient]`, plus six boolean keys. | Values matter. A key-only grep would lose the arrays and overstate what was actually observed. |
| OBS-ENT-004 | Selected exact `sharingd` entitlement values | OBS | Current-build XML includes `com.apple.private.cloudkit.masquerade = true`, `com.apple.private.cloudkit.systemService = true`, `com.apple.private.nsurlsession.impersonate = true`, `com.apple.developer.icloud-services = [CloudKit]`, and `com.apple.private.tcc.allow = [kTCCServiceAddressBook, kTCCServiceLiverpool, kTCCServicePhotos]`. | These are granted claims in the code signature. Names alone do not establish runtime use or server-side authorization semantics. |

## Public primary-source receipts

### PUB-BOOT-001 — Apple silicon secure boot

Apple Platform Security states that an Apple-silicon Mac begins its chain of trust by executing Boot ROM, and describes LLB loading and verifying system-paired firmware, LocalPolicy, and later boot objects.

Source: <https://support.apple.com/guide/security/boot-process-for-a-mac-with-apple-silicon-secac71d5623/web>

Supports: Chapter 2's claim that later authority begins only after earlier boot stages authenticate what follows.

Does **not** support: flattening every Apple-silicon generation or security configuration into one timeless exact stage list.

### PUB-SIP-001 — root does not override every macOS policy

Apple documents System Integrity Protection as applying its security policy to every process regardless of sandbox or administrative privilege, using mandatory access controls in addition to discretionary Unix permissions.

Source: <https://support.apple.com/guide/security/system-integrity-protection-secb7ea06b49/web>

Supports: Chapters 1 and 3 treating UID 0 as powerful but not absolute.

### PUB-LAUNCHD-001 — launchd / loginwindow durable roles

Apple's archived Daemons and Services Programming Guide describes `launchd` as the root process, system initializer, and on-demand daemon launcher, and says it launches `loginwindow`, which coordinates login and user-session setup.

Source: <https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/Lifecycle.html>

Supports: Chapters 4 and 6 at an architectural level.

Caveat: the document is archived and predates current macOS internals. Do not use it as a complete modern call graph.

### PUB-WINDOW-001 — window-server event delivery

Apple's archived Mac App Programming Guide states that the system window server receives events from underlying hardware and transfers/delivers them to applications.

Sources:
- <https://developer.apple.com/library/archive/documentation/General/Conceptual/MOSXAppProgrammingGuide/CoreAppDesign/CoreAppDesign.html>
- <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/EventArchitecture/EventArchitecture.html>

Supports: Chapter 6's narrow event-delivery claim.

Does **not** by itself support: every broader private WindowServer responsibility described by character metaphor.

### PUB-WINDOW-002 — current public window/display-server surface

Apple's current Quartz Window Services documentation describes onscreen and offscreen windows **managed by the macOS window server**, including window information scoped to the current user session. Quartz Display Services says it provides access to features in the macOS window server for display configuration and control.

Sources:
- <https://developer.apple.com/documentation/coregraphics/quartz-window-services>
- <https://developer.apple.com/documentation/coregraphics/quartz-display-services>

Supports: Chapter 6 saying WindowServer has authority over managed windows and participates in display control, alongside the older public event-delivery documentation.

Does **not** support: treating every private SkyLight surface, entitlement, session primitive, or observed symbol as a documented WindowServer contract.

### PUB-TRUST-001 — code signing, notarization, Gatekeeper, trust caches are distinct

Apple documents code signing and notarization as independent mechanisms with different goals; Gatekeeper applies launch-time policy to downloaded software; trust caches are a separate secure-boot/runtime trust mechanism.

Sources:
- <https://support.apple.com/guide/security/app-code-signing-process-in-macos-sec3ad8e6e53/web>
- <https://support.apple.com/guide/security/gatekeeper-and-runtime-protection-in-macos-sec5599b66df/web>
- <https://support.apple.com/guide/security/trust-caches-sec7d38fbf97/web>

Supports: Chapter 7's refusal to turn `amfid` into a single all-powerful bouncer.

### PUB-METAL-001 — unified memory is not unrestricted access

Apple documents a unified memory model for Apple GPUs while distinguishing Metal storage modes: `shared` resources are CPU/GPU-accessible, while `private` resources are GPU-only. Shared resources still require synchronization.

Sources:
- <https://developer.apple.com/documentation/metal/choosing-a-resource-storage-mode-for-apple-gpus>
- <https://developer.apple.com/documentation/metal/mtlstoragemode/shared>
- <https://developer.apple.com/documentation/metal/mtlstoragemode/private>

Supports: Chapter 9's "Unified does not mean communal" section.

### PUB-DMA-001 — Apple-silicon DMA protection

Apple documents an IOMMU for each DMA agent in Apple SoCs and states that PCIe and Thunderbolt peripherals can access only memory explicitly mapped for their use.

Source: <https://support.apple.com/guide/security/direct-memory-access-protections-for-mac-computers-seca4960c2b5/web>

Supports: Chapter 9's loading-dock model.

Caveat: Apple's public page says IOMMU. `DART` is the implementation name used in relevant Apple-silicon / reverse-engineering contexts; do not imply that the public page itself names DART.

### RE-DART-001 — DART is the Apple silicon IOMMU name in public reverse engineering

Asahi Linux documentation and project reports explicitly identify DART as Apple's IOMMU hardware on Apple silicon. The Linux configuration uses `CONFIG_APPLE_DART`, and Asahi describes peripheral blocks as sitting behind a DART IOMMU.

Sources:
- <https://asahilinux.org/docs/sw/kernel-config/>
- <https://asahilinux.org/2025/10/progress-report-6-17/>

Supports: Chapter 9 assigning the I/O-mapping character name **DART** while separately citing Apple for the generic per-DMA-agent IOMMU security property.

Caveat: Asahi is public reverse-engineering evidence, not Apple documentation.

### PUB-SEP-001 — Secure Enclave is a distinct security subsystem

Apple documents the Secure Enclave as a dedicated subsystem isolated from the main processor, with its own processor environment, dedicated Boot ROM, protected memory mechanisms, cryptographic hardware, and sepOS verification.

Source: <https://support.apple.com/guide/security/the-secure-enclave-sec59b0b31ff/web>

Supports: Chapter 10's central jurisdiction claim: Application Processor kernel privilege is not universal authority over the Secure Enclave.

### PUB-PERIPH-001 — peripheral processors have their own firmware/security story

Apple documents built-in peripheral processors for tasks including networking, graphics, and power management, and describes either downloading verified firmware from the primary CPU or implementing a separate secure-boot chain.

Source: <https://support.apple.com/guide/security/peripheral-processor-security-seca500d4f2b/web>

Supports: Chapters 2 and 11's claim that the gray box labelled HARDWARE contains independently significant processor/firmware domains.

### RE-SEP-001 — AP↔SEP mailbox

Asahi Linux's public Secure Enclave Processor documentation identifies a SEP mailbox, gives a mailbox base for reverse-engineered targets, and includes traced messages sent to and from SEP endpoints.

Source: <https://asahilinux.org/docs/hw/soc/sep/>

Supports: Chapter 10's use of *mailbox* as a hardware messaging mechanism across the AP/SEP boundary.

Caveat: this is public reverse-engineering evidence, not Apple documentation. The book must not extrapolate unobserved message semantics from it.

### SRC-FINDER-001 — Finder desktop-icon flag artifact

A public 2025 `CGSSpace.swift` Gist contains the exact comment:

```swift
let flag = 0x1 // this value MUST be 1, otherwise, Finder decides to draw desktop icons
```

The file says it is a lightly modified derivative of `avaidyam/Parrot` and names commit `6cf7ba419176c386ed8f18e838690a7272fe57ee` / `MochaUI/CGSSpace.swift` as the original source.

Source: <https://gist.github.com/julianschiavo/6472bbbe10359133765e95d339e25fb4>

Supports: Chapter 6's claim that a third-party developer recorded this constraint beside a private `CGSSpaceCreate` call.

Does **not** support: treating `0x1` as a documented Apple ABI contract or claiming the behavior is stable across macOS versions.

### PUB-CODESIGN-001 — current entitlement extraction syntax

Apple's TN3125 documents `codesign --display --entitlements - --xml <path>` to force XML output; current `codesign` can otherwise emit a human-readable representation of DER-encoded entitlements. The local collector preserves both forms and stderr.

Source: <https://developer.apple.com/documentation/Technotes/tn3125-inside-code-signing-provisioning-profiles>

Supports: the second-method entitlement reproduction attempt for Chapters 7 and 8.


### PUB-ANE-001 — Core ML exposes CPU/GPU/Neural Engine compute-unit choices

Apple's current `MLComputeUnits` documentation defines model-execution choices that include CPU-only, CPU+GPU, CPU+Neural Engine, and `all`, where the operating system may select the best available processing unit including the Neural Engine.

Source: <https://developer.apple.com/documentation/coreml/mlcomputeunits>

Supports: Chapter 11's claim that Core ML can place supported model work across CPU, GPU, and Neural Engine resources without promising that every model or operation runs on the ANE.

Does **not** support: a claim about the exact scheduler, partitioning of a specific model, or a universal list of operations supported by the Neural Engine.

### RE-DCP-001 — DCP sits in the Apple-silicon display path

Asahi Linux's public reverse-engineering work describes DCP as a coprocessor attached to the Apple-silicon display engine. Its 2021 display bring-up report says much of the display driver runs in DCP firmware; its August 2026 Linux 7.2 report describes direct scanout of AGX- and AVD-produced framebuffers through DCP.

Sources:
- <https://asahilinux.org/2021/08/progress-report-august-2021/>
- <https://asahilinux.org/2026/08/progress-report-7-2/>

Supports: Chapter 11's downstream **Display Controller** character and the claim that rendering/composition and final display scanout are distinct stages.

Caveat: this is public reverse-engineering evidence, not an Apple-documented DCP ABI. The book's character name is intentionally generic; exact pipelines vary by SoC, machine, and display path.

### PUB-FTL-001 — APFS sits above a flash translation layer

Apple's retired APFS FAQ explicitly discusses a *Flash translation layer* and notes that it can group writes into the same NAND block. The same guide treats APFS as a filesystem for Flash/SSD storage rather than a description of physical NAND placement.

Source: <https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/APFS_Guide/FAQ/FAQ.html>

Supports: Chapter 11's storage-abstraction joke: a filesystem can retain a logical block identity while lower storage layers choose physical NAND placement.

Caveat: the APFS guide is retired, and this receipt does not document the exact controller firmware or mapping algorithms in a current Apple-silicon Mac.

### RE-STORAGE-001 — public reverse engineering identifies an Apple-silicon NAND/SSD controller

Asahi Linux's platform introduction lists `S5E` as the NAND (SSD) controller on documented Apple-silicon targets and records a separate controller/firmware role beneath the operating-system storage stack.

Source: <https://asahilinux.org/docs/platform/introduction/>

Supports: Chapter 11 giving the lower storage layer a controller character distinct from APFS.

Caveat: this is public reverse-engineering documentation. It does not expose the private flash-translation mapping for a particular logical block or make `S5E` universal across every Apple-silicon generation.

## Still-open receipts

The local reproduction closed several first-pass gaps. The following remain explicitly provisional or incomplete:

1. Exact provenance/build for the earlier **134-key** `sharingd` dump, now that the v0.3 target independently returns **132**.
2. Complete LaunchAngel semantics. Current reproduction now confirms names, paths, `__Angel`, a resolution-failure diagnostic, and the exact private-entitlement string `com.apple.private.xpc.launchd.allow-submit-launch-angels`; none of that reveals the full object lifecycle or authorization path.
3. Private WindowServer/SkyLight responsibilities beyond Apple's public claims about managed windows, display-server features, and event delivery.
4. Behavioral meaning of private entitlement names such as `com.apple.private.cloudkit.masquerade`, `com.apple.private.cloudkit.systemService`, or `com.apple.private.nsurlsession.impersonate`; current reproduction proves those keys are granted to `sharingd`, not what every authorized server-side path permits or what the daemon actually invokes.
5. Runtime conditions for the undocumented `launchd` diagnostics. Static strings prove presence, not execution frequency or exact code path.

### Reproduction lesson: exact-string search can lie by omission

The shutdown sentence produced a useful methodology bug. Searching the extracted string table for the entire sentence failed because the binary stores/exposes it as adjacent pieces. Searching for the distinctive suffix found:

```text
(or halting) the system now. Any processes that are still running
will be abandoned to the mercy of the kernel.
```

That is not evidence against exact-string searching; it is evidence that negative static-string results need a second search using distinctive fragments and surrounding context before being promoted to "absent."

The manuscript should get more precise as these receipts improve, not more confident because a line is funny.

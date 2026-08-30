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

## Local reproduction results

| Evidence ID | Claim / artifact | Class | v0.3 result | Publication rule |
|---|---|---|---|---|
| OBS-LAUNCHD-001 | `_ThrottleInterval set to zero. You're not that important. Ignoring.` | OBS | Reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b. | May quote exactly and name the build. Do not infer the complete runtime path from the string. |
| OBS-LAUNCHD-002 | `rlimit(3)? Really?` | OBS | Reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b. | May quote exactly and name the build. |
| SRC-LAUNCHD-003 | `XPC bundles can't have KeepAlive, they can't even set it as a plist key, how did we get here?` | SRC-OBS | Present in earlier source archaeology; not yet recorded as reproduced by the first v0.3 pass. | Keep as an earlier observed string until independently reproduced. |
| OBS-ANGEL-001 | LaunchAngel names / paths | OBS + INF | LaunchAngel names and paths were reproduced in `/sbin/launchd` on macOS 27.0 build 26A5416b. Their complete semantics remain unknown. | The existence of the names/paths is observable. The job description is not. |
| NEG-LAUNCHD-001 | `Any processes that are still running will be abandoned to the mercy of the kernel.` | SRC-OBS + negative current-build result | The exact sentence was **not** present in `/sbin/launchd` on macOS 27.0 build 26A5416b. It remains an earlier source-conversation observation. | Never present it as a universal current launchd string. State the build-specific non-reproduction when discussing its provenance. |
| PENDING-ENT-001 | `/usr/libexec/amfid` entitlement count = 8 | SRC-OBS | First v0.3 `codesign` attempt returned no XML; independent reproduction still pending. | Keep the count explicitly build-specific and sourced to the earlier observation until a second extraction method succeeds. |
| PENDING-ENT-002 | `/usr/libexec/sharingd` entitlement count = 134 | SRC-OBS | First v0.3 `codesign` attempt returned no XML; independent reproduction still pending. | Same rule as above. Entitlement names establish granted capabilities, not proof of use. |

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

## Still-open receipts

The following should remain explicitly provisional until reproduced or sourced more strongly:

1. Exact current-build `amfid` and `sharingd` entitlement sets and counts.
2. Exact full spelling/location of every LaunchAngel-related artifact beyond the first reproduced names/paths.
3. Exact provenance/build for the older `at the mercy of the kernel` string.
4. Any broader WindowServer role that goes beyond the narrow public event-delivery documentation.
5. Exact current-build entitlement extraction for `amfid` and `sharingd`; `tools/collect-macos-receipts.sh` now retries using Apple's current `codesign --display --entitlements - --xml` form and also preserves the default DER-aware representation.

The manuscript should get more precise as these receipts improve, not more confident because a line is funny.

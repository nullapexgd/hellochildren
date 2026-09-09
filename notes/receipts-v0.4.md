# v0.4 Receipts — Working Evidence File

This file is the reproducibility layer for the Jurisdiction Edition. It began as a byte-for-byte copy of the frozen v0.3 receipts and now grows only when v0.4 adds or materially changes a claim. It is deliberately stricter than the prose.

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
| OBS-WINDOW-001 | Installed WindowServer launchd service definition | OBS | On macOS 27.0 build 26A5416b, `/System/Library/LaunchDaemons/com.apple.WindowServer.plist` declares `Label = com.apple.WindowServer` and invokes the private SkyLight `WindowServer` executable with `-daemon`. | Supports treating WindowServer as system-domain infrastructure rather than a child of an authenticated user session. The property list alone does not prove exact launch timing, current login UI calls, or complete session topology. |

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

### PUB-LOGINWINDOW-001 — Login Window remains a current configuration surface

Apple's current device-management documentation identifies a macOS `LoginWindow` payload with the payload type `com.apple.loginwindow` and exposes settings governing Login Window behavior.

Source: <https://developer.apple.com/documentation/devicemanagement/loginwindow>

Supports: Chapter 6 saying Login Window remains a current named system surface while relying on archived documentation only for the historical session-setup description.

Does **not** support: treating the payload schema as documentation of current private authentication calls, per-user service construction, or the complete login sequence.

### PUB-WINDOW-001 — window-server event delivery

Apple's archived Mac App Programming Guide states that the system window server receives events from underlying hardware and transfers/delivers them to applications.

Sources:
- <https://developer.apple.com/library/archive/documentation/General/Conceptual/MOSXAppProgrammingGuide/CoreAppDesign/CoreAppDesign.html>
- <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/EventArchitecture/EventArchitecture.html>

Supports: Chapter 7's narrow event-delivery claim.

Does **not** by itself support: every broader private WindowServer responsibility described by character metaphor.

### PUB-WINDOW-002 — current public window/display-server surface

Apple's current Quartz Window Services documentation describes onscreen and offscreen windows **managed by the macOS window server**, including window information scoped to the current user session. Quartz Display Services says it provides access to features in the macOS window server for display configuration and control.

Sources:
- <https://developer.apple.com/documentation/coregraphics/quartz-window-services>
- <https://developer.apple.com/documentation/coregraphics/quartz-display-services>

Supports: Chapter 7 saying WindowServer has authority over managed windows and participates in display control, alongside the older public event-delivery documentation.

Does **not** support: treating every private SkyLight surface, entitlement, session primitive, or observed symbol as a documented WindowServer contract.

### PUB-TRUST-001 — code signing, notarization, Gatekeeper, trust caches are distinct

Apple documents code signing and notarization as independent mechanisms with different goals; Gatekeeper applies launch-time policy to downloaded software; trust caches are a separate secure-boot/runtime trust mechanism.

Sources:
- <https://support.apple.com/guide/security/app-code-signing-process-in-macos-sec3ad8e6e53/web>
- <https://support.apple.com/guide/security/gatekeeper-and-runtime-protection-in-macos-sec5599b66df/web>
- <https://support.apple.com/guide/security/trust-caches-sec7d38fbf97/web>

Supports: Chapter 8's refusal to turn `amfid` into a single all-powerful bouncer.

### PUB-METAL-001 — unified memory is not unrestricted access

Apple documents a unified memory model for Apple GPUs while distinguishing Metal storage modes: `shared` resources are CPU/GPU-accessible, while `private` resources are GPU-only. Shared resources still require synchronization.

Sources:
- <https://developer.apple.com/documentation/metal/choosing-a-resource-storage-mode-for-apple-gpus>
- <https://developer.apple.com/documentation/metal/mtlstoragemode/shared>
- <https://developer.apple.com/documentation/metal/mtlstoragemode/private>

Supports: Chapter 14's "Unified does not mean communal" section.

### PUB-DMA-001 — Apple-silicon DMA protection

Apple documents an IOMMU for each DMA agent in Apple SoCs and states that PCIe and Thunderbolt peripherals can access only memory explicitly mapped for their use.

Source: <https://support.apple.com/guide/security/direct-memory-access-protections-for-mac-computers-seca4960c2b5/web>

Supports: Chapter 14's loading-dock model.

Caveat: Apple's public page says IOMMU. `DART` is the implementation name used in relevant Apple-silicon / reverse-engineering contexts; do not imply that the public page itself names DART.

### RE-DART-001 — DART is the Apple silicon IOMMU name in public reverse engineering

Asahi Linux documentation and project reports explicitly identify DART as Apple's IOMMU hardware on Apple silicon. The Linux configuration uses `CONFIG_APPLE_DART`, and Asahi describes peripheral blocks as sitting behind a DART IOMMU.

Sources:
- <https://asahilinux.org/docs/sw/kernel-config/>
- <https://asahilinux.org/2025/10/progress-report-6-17/>

Supports: Chapter 14 assigning the I/O-mapping character name **DART** while separately citing Apple for the generic per-DMA-agent IOMMU security property.

Caveat: Asahi is public reverse-engineering evidence, not Apple documentation.

### PUB-ADDR-001 — an address needs a translation context

Arm's memory-management guide documents multiple independent virtual address spaces and gives the example that `NS.EL2:0x8000` means address `0x8000` in one specific translation regime. Apple's DMA guide separately documents per-agent IOMMU translation tables, while the Asahi DART sources expose per-stream I/O translation.

Sources:
- <https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/LearnTheArchitecture-MemoryManagement-101811_0100_00_en.pdf>
- <https://support.apple.com/guide/security/direct-memory-access-protections-for-mac-computers-seca4960c2b5/web>
- <https://github.com/AsahiLinux/m1n1/blob/main/proxyclient/m1n1/hw/dart.py>

Supports: Chapter 14's address-dispute beat. The same numeric address can belong to different CPU or I/O translation contexts.

Caveat: `0x1000` is an illustrative number. The dialogue is **DRAM**, not a trace of a real mapping or a shared conversation among MMU, DART, and the memory controller.

### PUB-SEP-001 — Secure Enclave is a distinct security subsystem

Apple documents the Secure Enclave as a dedicated subsystem isolated from the main processor, with its own processor environment, dedicated Boot ROM, protected memory mechanisms, cryptographic hardware, and sepOS verification.

Source: <https://support.apple.com/guide/security/the-secure-enclave-sec59b0b31ff/web>

Supports: Chapter 15's central jurisdiction claim: Application Processor kernel privilege is not universal authority over the Secure Enclave.

### PUB-PERIPH-001 — peripheral processors have their own firmware/security story

Apple documents built-in peripheral processors for tasks including networking, graphics, and power management, and describes either downloading verified firmware from the primary CPU or implementing a separate secure-boot chain.

Source: <https://support.apple.com/guide/security/peripheral-processor-security-seca500d4f2b/web>

Supports: Chapters 2 and 17's claim that the gray box labelled HARDWARE contains independently significant processor/firmware domains.

### RE-SEP-001 — AP↔SEP mailbox

Asahi Linux's public Secure Enclave Processor documentation identifies a SEP mailbox, gives a mailbox base for reverse-engineered targets, and includes traced messages sent to and from SEP endpoints.

Source: <https://asahilinux.org/docs/hw/soc/sep/>

Supports: Chapter 15's use of *mailbox* as a hardware messaging mechanism across the AP/SEP boundary.

Caveat: this is public reverse-engineering evidence, not Apple documentation. The book must not extrapolate unobserved message semantics from it.

### SRC-FINDER-001 — Finder desktop-icon flag artifact

A public 2025 `CGSSpace.swift` Gist contains the exact comment:

```swift
let flag = 0x1 // this value MUST be 1, otherwise, Finder decides to draw desktop icons
```

The file says it is a lightly modified derivative of `avaidyam/Parrot` and names commit `6cf7ba419176c386ed8f18e838690a7272fe57ee` / `MochaUI/CGSSpace.swift` as the original source.

Source: <https://gist.github.com/julianschiavo/6472bbbe10359133765e95d339e25fb4>

Supports: Chapter 7's claim that a third-party developer recorded this constraint beside a private `CGSSpaceCreate` call.

Does **not** support: treating `0x1` as a documented Apple ABI contract or claiming the behavior is stable across macOS versions.

### SRC-BN-CGSSPACE-001 — BoringNotch synthetic-Space technique

BoringNotch's `CGSSpace.swift` calls the private `CGSSpaceCreate` API with `flag = 0x1`, sets the new Space's level with `CGSSpaceSetAbsoluteLevel`, and calls `CGSShowSpaces` to make that Space visible everywhere. The file's own comment repeats the exact desktop-icon warning documented in `SRC-FINDER-001`, consistent with the file being part of the same `avaidyam/Parrot` lineage rather than an independent rediscovery.

Source: direct inspection this session of the BoringNotch source tree and the installed `boringNotch.app`.

Supports: Chapter 7's claim that BoringNotch mints a new CGS Space rather than joining an existing one via the public `canJoinAllSpaces` collection behavior.

Does **not** support: any claim about what WindowServer/CGS validates before accepting the call, or that the call succeeds unconditionally. The call was observed succeeding once, on one build.

### SRC-BN-XPC-001 — BoringNotch sandboxed app / unsandboxed XPC helper split

`codesign -d --entitlements :-` on `/Applications/boringNotch.app` shows `com.apple.security.app-sandbox: true` plus a `com.apple.security.temporary-exception.mach-lookup.global-name` entitlement naming a custom mach service. The same command on `BoringNotchXPCHelper.xpc` shows `com.apple.security.app-sandbox: false`. `BoringNotchXPCHelperProtocol.swift` in the source tree shows the helper's entire exposed surface is six methods: accessibility-authorization checks, keyboard-backlight get/set, and screen-brightness get/set.

Source: direct `codesign` inspection of both installed binaries this session, plus the BoringNotch source tree.

Supports: Chapter 7's claim that the sandboxed app reaches CoreBrightness-gated functionality only through an unsandboxed helper reached over a named mach service.

Does **not** support: any claim about how Apple's App Review process evaluated this specific entitlement grant for this specific build. *Temporary exception* is Apple's own name for the entitlement category; the book does not assert more than that name states.

### SRC-BN-EVENTTAP-001 — BoringNotch media-key event tap

`MediaKeyInterceptor.swift` in the BoringNotch source tree installs a `CGEventTap` at `.headInsertEventTap`, filters for the system-defined event type carrying media-key presses, and on a volume/brightness key handles the press itself (via `VolumeManager`/`BrightnessManager`) before returning `nil` from the callback, which stops the event from propagating to the next listener. It plays `/System/Library/LoginPlugins/BezelServices.loginPlugin/Contents/Resources/volume.aiff` directly and checks `com.apple.sound.beep.feedback` first, the same file and preference the system bezel uses.

Source: direct inspection this session of the BoringNotch source tree.

Supports: Chapter 7's claim that the app intercepts and locally handles a media-key press before the system's own `OSDUIHelper` is notified.

Does **not** support: any claim of privilege escalation. The event tap's own existence is still gated behind input-monitoring/accessibility permission and can be disabled by the user; returning `nil` only controls propagation of an event the tap was already permitted to see.

### PUB-CODESIGN-001 — current entitlement extraction syntax

Apple's TN3125 documents `codesign --display --entitlements - --xml <path>` to force XML output; current `codesign` can otherwise emit a human-readable representation of DER-encoded entitlements. The local collector preserves both forms and stderr.

Source: <https://developer.apple.com/documentation/Technotes/tn3125-inside-code-signing-provisioning-profiles>

Supports: the second-method entitlement reproduction attempt for Chapters 8 and 12.


### PUB-ANE-001 — Core ML exposes CPU/GPU/Neural Engine compute-unit choices

Apple's current `MLComputeUnits` documentation defines model-execution choices that include CPU-only, CPU+GPU, CPU+Neural Engine, and `all`, where the operating system may select the best available processing unit including the Neural Engine.

Source: <https://developer.apple.com/documentation/coreml/mlcomputeunits>

Supports: Chapter 17's claim that Core ML can place supported model work across CPU, GPU, and Neural Engine resources without promising that every model or operation runs on the ANE.

Does **not** support: a claim about the exact scheduler, partitioning of a specific model, or a universal list of operations supported by the Neural Engine.

### RE-DCP-001 — DCP sits in the Apple-silicon display path

Asahi Linux's public reverse-engineering work describes DCP as a coprocessor attached to the Apple-silicon display engine. Its 2021 display bring-up report says much of the display driver runs in DCP firmware; its August 2026 Linux 7.2 report describes direct scanout of AGX- and AVD-produced framebuffers through DCP.

Sources:
- <https://asahilinux.org/2021/08/progress-report-august-2021/>
- <https://asahilinux.org/2026/08/progress-report-7-2/>

Supports: Chapters 7 and 17 using a downstream **Display Controller** character and distinguishing rendering/composition from final display scanout.

Caveat: this is public reverse-engineering evidence, not an Apple-documented DCP ABI. The book's character name is intentionally generic; exact pipelines vary by SoC, machine, and display path.

### PUB-FTL-001 — APFS sits above a flash translation layer

Apple's retired APFS FAQ explicitly discusses a *Flash translation layer* and notes that it can group writes into the same NAND block. The same guide treats APFS as a filesystem for Flash/SSD storage rather than a description of physical NAND placement.

Source: <https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/APFS_Guide/FAQ/FAQ.html>

Supports: Chapter 17's storage-abstraction joke: a filesystem can retain a logical block identity while lower storage layers choose physical NAND placement.

Caveat: the APFS guide is retired, and this receipt does not document the exact controller firmware or mapping algorithms in a current Apple-silicon Mac.

### RE-STORAGE-001 — public reverse engineering identifies an Apple-silicon NAND/SSD controller

Asahi Linux's platform introduction lists `S5E` as the NAND (SSD) controller on documented Apple-silicon targets and records a separate controller/firmware role beneath the operating-system storage stack.

Source: <https://asahilinux.org/docs/platform/introduction/>

Supports: Chapter 17 giving the lower storage layer a controller character distinct from APFS.

Caveat: this is public reverse-engineering documentation. It does not expose the private flash-translation mapping for a particular logical block or make `S5E` universal across every Apple-silicon generation.


### PUB-BOOT-MODES-001 — Apple documents the normal Apple-silicon handoff sequence

Apple's current boot-modes documentation gives the normal macOS sequence explicitly: Boot ROM hands off to LLB; LLB loads system-paired firmware and the LocalPolicy and hands off to iBoot; iBoot loads macOS-paired firmware, the static trust cache, device tree, and Boot Kernel Collection, conditionally loads an Auxiliary Kernel Collection, and verifies the signed-system-volume root signature hash when LocalPolicy has not disabled that check.

Sources:
- <https://support.apple.com/guide/security/boot-process-secac71d5623/web>
- <https://support.apple.com/guide/security/boot-modes-sec10869885b/web>

Supports: Chapter 2 replacing the vague "earlier stage authenticates later stage" shorthand with a documented staged handoff.

Caveat: recovery modes take different paths, and the sequence is version/product specific. The family dialogue remains compression, not a literal protocol trace.

### OSS-XNU-CS-001 — code-signing enforcement has explicit kernel machinery

Apple's published XNU source initializes code-signing and trust-cache machinery during kernel startup. Public headers define process code-signing flags such as `CS_VALID`, `CS_HARD`, `CS_KILL`, `CS_ENFORCEMENT`, `CS_ENTITLEMENTS_VALIDATED`, `CS_PLATFORM_BINARY`, and `CS_SIGNED`; VM page state includes code-signing validation/taint bits.

Sources:
- <https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/kern/startup.c>
- <https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/kern/cs_blobs.h>
- <https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/vm/vm_page.h>

Supports: Chapter 8's statement that `amfid` is not a single all-powerful userspace bouncer. There is explicit kernel-side code-signing state and enforcement machinery in addition to userspace services and platform policy.

Caveat: public source does not by itself document the complete current private protocol between XNU, AMFI components, CoreTrust, and `amfid`.

### PUB-GATEKEEPER-001 — Gatekeeper is not every code-execution check

Apple documents Gatekeeper as policy for downloaded software, especially the first open: it checks identified-developer status, notarization, integrity, provenance, and user approval. Apple also documents that users can override Gatekeeper for software and, when policy permits, disable it.

Sources:
- <https://support.apple.com/guide/security/gatekeeper-and-runtime-protection-sec5599b66df/web>
- <https://support.apple.com/guide/security/sec3ad8e6e53/web>

Supports: Chapter 8 narrowing Gatekeeper's character from generic "launch authority" to one part of macOS app-trust policy.

Does **not** support: treating a Gatekeeper approval or override as a bypass of unrelated code-signing, entitlement, SIP, sandbox, or runtime controls.

## Still-open receipts

The local reproduction closed several first-pass gaps. The following remain explicitly provisional or incomplete:

1. Exact provenance/build for the earlier **134-key** `sharingd` dump, now that the v0.3 target independently returns **132**.
2. Complete LaunchAngel semantics. Current reproduction now confirms names, paths, `__Angel`, a resolution-failure diagnostic, and the exact private-entitlement string `com.apple.private.xpc.launchd.allow-submit-launch-angels`; none of that reveals the full object lifecycle or authorization path.
3. Private WindowServer/SkyLight responsibilities beyond Apple's public claims about managed windows, display-server features, and event delivery.
4. Behavioral meaning of private entitlement names such as `com.apple.private.cloudkit.masquerade`, `com.apple.private.cloudkit.systemService`, or `com.apple.private.nsurlsession.impersonate`; current reproduction proves those keys are granted to `sharingd`, not what every authorized server-side path permits or what the daemon actually invokes.
5. Runtime conditions for the undocumented `launchd` diagnostics. Static strings prove presence, not execution frequency or exact code path.
6. Exact BoringNotch version/commit for `SRC-BN-CGSSPACE-001`, `SRC-BN-XPC-001`, and `SRC-BN-EVENTTAP-001`. The behavior was observed this session against the app and source tree as they existed then; a third-party app can change its own mechanisms in a later release independent of any macOS build.

### Reproduction lesson: exact-string search can lie by omission

The shutdown sentence produced a useful methodology bug. Searching the extracted string table for the entire sentence failed because the binary stores/exposes it as adjacent pieces. Searching for the distinctive suffix found:

```text
(or halting) the system now. Any processes that are still running
will be abandoned to the mercy of the kernel.
```

That is not evidence against exact-string searching; it is evidence that negative static-string results need a second search using distinctive fragments and surrounding context before being promoted to "absent."

The manuscript should get more precise as these receipts improve, not more confident because a line is funny.

## Chapter 16 — The Civil War

### OBS-CIVIL-001 — the real nouns in the impossible command

On macOS 27.0 build `26A5425a`, a direct local check returned UID `501`, identified `/sbin/launchd` as `Mach-O 64-bit executable arm64e`, and found `/System/Library/Extensions/AppleSEPManager.kext` installed.

Commands:

```sh
id -u
file /sbin/launchd
test -d /System/Library/Extensions/AppleSEPManager.kext
```

Supports: the literal nouns and first two terminal outputs used in Chapter 16.

Does **not** support: the invented `send` command, transfer to SEP, execution inside SEP, any dialogue, or any meaning inferred from the `AppleSEPManager` name.

### PUB-CIVIL-001 — the documented architecture argues against the scene

Apple documents the Secure Enclave as isolated from the Application Processor, with its own processor, protected memory, Boot ROM, and signed sepOS boot process. Apple also documents SPTM on supported Apple SoCs as page-table protection machinery. Neither source documents a general facility for sending an AP Mach-O executable into SEP or authorizing it to execute there.

Sources:

- <https://support.apple.com/guide/security/the-secure-enclave-sec59b0b31ff/web>
- <https://support.apple.com/guide/security-pdf/operating-system-integrity-sec8b776536b/web>

Supports: the chapter's explicit declaration that its central transfer is impossible under the architecture the book has described.

Does **not** support: treating SPTM as the documented speaker for this objection. Its dialogue is dramatization.

### DRAM-CIVIL-001 — UID 501 mails PID 1 through the jurisdiction

Every event after `send /sbin/launchd SEP` is deliberately impossible dramatization. `send` is invented. AirDrop does not cross processor trust domains. A pathname is not a transport, delivery is not authorization, and authorization would not turn an Application Processor Mach-O into a SEP-native executable.

Publication rule: the chapter must retain its visible evidence note and must never acquire plausible-sounding mechanics. The joke is that even an intentionally impossible chapter shows identification at the door.

## Chapter 9 — Policy Is Not Enforcement

### PUB-POLICY-001 — Apple separates prevention, blocking, and remediation

Apple's current platform-security documentation describes three overlapping malware-defense layers: preventing launch or execution through the App Store or Gatekeeper with notarization; blocking known malware through Gatekeeper, notarization, and XProtect; and remediation through XProtect.

Source: <https://support.apple.com/guide/security/sec469d47bd8/web>

Supports: Chapter 9's use of evaluate, block, detect, and remediate as different verbs and its claim that XProtect participates in more than one stage.

Caveat: the chapter's four-word line is a vocabulary, not a promise that every file follows one fixed sequence or that each verb belongs to exactly one component.

### OBS-POLICY-001 — current local system-policy manuals

On macOS 27.0 build `26A5425a`, the installed `syspolicyd(8)` manual says the daemon manages the master system-policy database and serves as a general “oracle” that other system components may ask for a verdict on a proposed operation. The installed `spctl(8)` manual documents assessment types and says several rule-database or global-state modification options are deprecated as of macOS 15.0.

Commands:

```sh
MANPAGER=cat man 8 syspolicyd | col -b
MANPAGER=cat man 8 spctl | col -b
```

Supports: the oracle joke and the claim that administrator-facing policy controls change over time.

Does **not** support: a complete current private call graph, the identity of every enforcement consumer, or the claim that `syspolicyd` alone makes all launch decisions.

### OBS-POLICY-002 — XProtect and MRT installed names

On macOS 27.0 build `26A5425a`, direct filesystem enumeration found:

```text
/Library/Apple/System/Library/CoreServices/XProtect.bundle
/Library/Apple/System/Library/CoreServices/XProtect.app
/Library/Apple/System/Library/CoreServices/MRT.app
```

Supports: Chapter 9 saying those artifacts are installed on the observed build.

Does **not** support: complete behavior, current responsibility boundaries, launch frequency, or treating an older MRT org chart as a current public contract.

## Chapter 10 — Consent Is Its Own Authority

### PUB-TCC-001 — Full Disk Access requires a person or managed policy

Apple's developer documentation says an app cannot automatically gain Full Disk Access through an entitlement or code; the person using the app must grant it in Privacy & Security. The same page lists independent facilities that may still deny file access, including POSIX permissions, ACLs, System Integrity Protection, and data protection.

Apple's platform-security documentation describes macOS privacy controls as requiring user consent before apps access protected file locations and explicit addition for full-storage access.

Sources:

- <https://developer.apple.com/documentation/security/accessing-files-from-the-macos-app-sandbox>
- <https://support.apple.com/guide/security/secddd1d86a6/web>

Supports: Chapter 10 separating Unix identity, sandbox allowance, signed capabilities, and privacy consent; the Full Disk Access dialogue; and the claim that an approved ordinary app does not thereby become globally more privileged than root.

Caveat: public documentation describes the user-facing and developer contract, not every private TCC attribution rule or daemon message.

### PUB-TCC-002 — App Sandbox does not grant unrestricted home access

Apple documents App Sandbox as limiting file, network, and hardware access. A sandboxed app receives a container it can access but does not receive unrestricted access to the user's home directory. User-selected files and declared folder capabilities create scoped access paths.

Sources:

- <https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox>
- <https://developer.apple.com/documentation/security/accessing-files-from-the-macos-app-sandbox>

Supports: Chapter 10 treating sandbox authority as a separate question from TCC consent and file permissions.

Does **not** support: the claim that sandboxing and TCC use one policy engine or one denial path.

### OBS-TCC-001 — installed `tccd` path

On macOS 27.0 build `26A5425a`, the executable exists at:

```text
/System/Library/PrivateFrameworks/TCC.framework/Support/tccd
```

Supports: using the exact installed name as a character while labeling its dialogue dramatization.

Does **not** support: a complete private schema, attribution algorithm, IPC route, or interpretation of every privacy decision.

## Chapter 11 — The Entitlement Bureaucracy

### PUB-ENT-001 — entitlements are signed key-value capability claims

Apple defines entitlements as key-value pairs embedded in an executable's code signature that grant permission to use a service or technology. Apple's macOS distribution-signing documentation says a provisioning profile must authorize most restricted entitlement claims, while some entitlement families can be claimed without that profile authorization.

Sources:

- <https://developer.apple.com/documentation/bundleresources/entitlements>
- <https://developer.apple.com/documentation/xcode/creating-distribution-signed-code-for-the-mac>

Supports: Chapter 11's issuer/claim/verifier model, the refusal to treat self-typed private keys as Apple-granted authority, and the claim that different entitlements can have different authorization conditions.

Caveat: the public pages do not document complete semantics or enforcement paths for Apple's private entitlements.

### OBS-ENT-004 — v0.4 badge census

On macOS 27.0 build `26A5425a`, `codesign --display --entitlements -` produced abstract dictionary output with these top-level `[Key]` counts:

| Binary | Count |
|---|---:|
| `/System/Applications/Utilities/Console.app/Contents/MacOS/Console` | 2 |
| `/Library/Apple/System/Library/CoreServices/MRT.app/Contents/MacOS/MRT` | 2 |
| `/usr/libexec/amfid` | 8 |
| `/usr/libexec/sharingd` | 134 |
| `/Applications/Safari.app/Contents/MacOS/Safari` | 194 |

Console's keys were exactly `com.apple.private.logging.diagnostic` and `com.apple.private.logging.stream`. MRT's were exactly `com.apple.private.mrt` and `com.apple.private.managedclient.configurationprofiles`.

The current `codesign --xml` request warned that the binary contained an invalid entitlements blob, while the default abstract representation decoded the values. The census therefore counts top-level `[Key]` entries in the abstract output and does not pretend an XML extraction succeeded on this build.

Supports: Chapter 11's build-labeled sidebar and Chapter 12's current 134-key entrance.

Does **not** support: ranking authority by count, treating nested values as extra top-level keys, proving runtime use, or assigning semantics beyond documented or separately observed behavior.

## Chapter 13 — Macintosh HD Is a Diplomatic Arrangement

### PUB-FS-001 — volume groups, roles, firmlinks, and the boot snapshot

Apple documents the modern macOS APFS layout with System and Data volumes plus Preboot, VM, and Recovery roles. The System volume is read-only by default; changing user and third-party data belongs on the Data volume. Apple also says macOS 11 or later boots from a snapshot of the System volume.

Apple's WWDC19 filesystem session introduced firmlinks as the bidirectional mechanism used to present the System/Data split as a unified directory hierarchy.

Sources:

- <https://support.apple.com/guide/security/seca6147599e/web>
- <https://developer.apple.com/videos/play/wwdc2019/710/>

Supports: Chapter 13's “two volumes in a convincing coat,” the distinction between visible path and underlying role, and the statement that the booted state is a selected System-volume snapshot.

Caveat: the chapter diagram and dialogue compress a product- and release-specific layout. A firmlink is not represented as a generic symbolic link.

### PUB-FS-002 — the Signed System Volume seal

Apple documents SSV as a tree of cryptographic hashes covering system content. The root hash is called a seal. During installation or update, the seal is recomputed and checked against Apple's signed measurement; on Apple silicon the bootloader verifies it before transferring control to the kernel. Apple also documents lower-security choices that change this protection model.

Source: <https://support.apple.com/guide/security/secd698747c9/web>

Supports: the distinction between writing bytes and producing a seal-valid state accepted by the normal protected boot path.

Does **not** support: personifying SSV and the seal as independent daemons. Those are separate comic voices only.

### PUB-FS-003 — APFS container space sharing

Apple's Disk Utility guide says APFS allocates storage on demand and that multiple volumes in one container share the container's free space. Each volume uses part of the container rather than owning a fixed partition-sized allotment.

Source: <https://support.apple.com/guide/disk-utility/dskua9e6a110/mac>

Supports: Chapter 13's distinction between shared capacity and separate volume identity.

Does **not** support: saying that sharing free space merges namespaces, mount state, volume roles, or protection rules.

### OBS-FS-001 — `/private` symbolic-link indirection

On macOS 27.0 build `26A5425a`, `ls -ld /etc /tmp /var` shows all three as symbolic links into `private/etc`, `private/tmp`, and `private/var`.

Supports: the `/private` sidebar's narrow path-indirection claim.

Does **not** support: treating those symbolic links as firmlinks, volume-group machinery, or Signed System Volume behavior.

## Chapter 14 — Memory Has Borders

### PUB-MEM-001 — virtual address space, residency, and faults

Apple's archived memory documentation describes per-process logical address spaces, page-table translation by the processor and MMU, mapped regions with access protections, and faults that the virtual-memory system may resolve. Its allocation guide also says a large allocation can receive a virtual address range before physical pages become resident; access then causes the kernel to arrange physical backing.

Sources:

- <https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/Articles/AboutMemory.html>
- <https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/Articles/MemoryAlloc.html>

Supports: Chapter 14's separation of address reservation, mapping, protection, physical residency, and fatal versus resolvable faults.

Caveat: these guides are archived and include old release-specific size and paging examples. The chapter uses only the durable virtual-memory model, not their historical constants.

## Chapter 17 — The House Inside the House

### PUB-VIRT-001 — Apple's two virtualization framework levels

Apple documents Hypervisor.framework as lightweight, user-space APIs for hardware-assisted virtual machines and virtual CPUs. Its overview describes virtual machines as processes and virtual CPUs as threads. Apple documents Virtualization.framework as higher-level APIs for configuring and operating complete virtual machines, including supported macOS and Linux guests on Apple silicon.

Sources:

- <https://developer.apple.com/documentation/hypervisor>
- <https://developer.apple.com/documentation/virtualization>
- <https://developer.apple.com/documentation/virtualization/running-macos-in-a-virtual-machine-on-apple-silicon>

Supports: Chapter 17's lower-level/higher-level distinction, host-process diagram, and host-resource-versus-guest-kernel jurisdiction.

Caveat: “VM as process” is Apple's API-level description. The chapter does not infer private implementation internals or teach CPU virtualization mechanisms beyond the public framework contract.

## Chapter 19 — At the Mercy of the Kernel

### OBS-HW-001 — the author's ten-core M4

On the author's Mac, a local hardware-profile check reported `Chip: Apple M4` and `Total Number of Cores: 10 (4 Performance and 6 Efficiency)`.

A publication-safe reproduction command is:

```sh
system_profiler SPHardwareDataType | sed -n '/Chip:/p;/Total Number of Cores:/p'
```

Supports: XNU's Chapter 19 ten-core flex and SEP telling it to turn off all ten.

Does **not** support: claiming every M4 product has this CPU configuration. The dialogue is dramatization; the machine inventory is observed.

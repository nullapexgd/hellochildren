# v0.7 Receipts — Evidence Delta

This file records claims added after the frozen v0.6 receipts. The evidence classes and publication rules defined in `notes/receipts-v0.5.md` still apply.

The edition rule remains:

> If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.

## DRAM-DEMOLITION-001 — XNU/launchd demolition-permit exchange

The XNU/launchd demolition-permit exchange is dramatization around the already established authority boundary: XNU can terminate userspace execution, while launchd organizes userspace services.

Supports: Chapter 3's comic distinction between destructive authority and service organization.

Does **not** establish a documented XNU/launchd transcript, private control path, or claim that either role subsumes the other.

## EDIT-RENUMBER-001 — chapter-number migration with no changed factual meaning

The eight late v0.6 chapter sources move to their final v0.7 positions: 14→18, 15→25, 16→26, 17→27, 18→30, 19→31, 20→28, and 21→32. Only filenames, top-level chapter numbers, and affected reference bookkeeping change in this migration.

Supports: stable final source paths for the v0.7 chapter spine.

Does **not** change the factual meaning or evidence classification of the renamed chapters.

## OBS-COREAUTH-001 — CoreAuthentication selector vocabulary

Classification: direct build-specific string observation.

On macOS 27.0 build `26A428`, `otool -ov` over `/System/Library/Frameworks/LocalAuthentication.framework/Support/coreauthd` identified Objective-C selector strings including:

- `evaluatePolicy:options:uiDelegate:reply:`
- `checkCredentialSatisfied:policy:reply:`
- `findMechanismForEvent:mustBeRunning:plugin:`
- `authenticationSuccessfulForEvent:reply:`

Supports: Chapter 6 quoting installed CoreAuthentication vocabulary around policy, credentials, mechanisms, authentication events, UI delegation, and replies.

Does **not** establish that the selectors execute in one sequence, identify their callers, document argument semantics, or reconstruct a complete login/authentication/session protocol. `coreauthd` exports only its Mach-O header through the ordinary export table on this build; these names were observed as embedded selector strings, not advertised C exports.

## OBS-DISPLAY-SYMBOLS-001 — installed display and brightness export names

Classification: direct build-specific export-table observation.

On macOS 27.0 build `26A428`, `/usr/bin/dyld_info -exports` resolved the installed shared-cache images through their normal framework paths. Selected exact exports:

- SkyLight: `_SLSMainConnectionID`, `_SLSGetWindowOwner`, `_SLSOrderWindow`, `_SLSCopyManagedDisplaySpaces`, `_SLSSetWindowAlpha`, `_SLSSetWindowLevel`
- CoreGraphics: `_CGWindowListCopyWindowInfo`, `_CGDisplayBounds`, `_CGMainDisplayID`, `_CGEventCreate`, `_CGDisplayRegisterReconfigurationCallback`
- CoreBrightness: `_CBALCGetDisplayAutoBrightnessEnabled`, `_CBALCSetDisplayAutoBrightnessEnabled`, `_CBALCALSCopyALSServiceClient`
- DisplayServices: `_DisplayServicesCanChangeBrightness`, `_DisplayServicesGetAuthorized`, `_DisplayServicesGetBrightness`, `_DisplayServicesSetBrightness`, `_DisplayServicesEnableAmbientLightCompensation`, `_DisplayServicesCommitSettings`

Supports: Chapter 7's conservative claim that the installed binaries expose vocabulary distinguishing connections, windows, ordering, Spaces, displays, events, brightness capability, authorization, automatic brightness, ambient-light participation, current values, setters, and committed settings.

Does **not** document private parameter meanings, call order, authorization rules, owning process, complete side effects, or stability across releases. An exported name proves an exported name. It does not grant the book authority to complete the undocumented sentence.

## Storage documentation context — inspected 2026-09-15

The storage receipts below were recorded before drafting Chapters 14–15. Local `man` resolves to the manuals shipped in the macOS 27.0 SDK under `/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man/`. Host: macOS 27.0 build `26A428`; Xcode 27.0 build `27A5252f`; `xcrun --sdk macosx --show-sdk-version`: `27.0`. These are inspected documentation, not tests of storage behavior. Do not replace earlier receipts' different build labels with this one.

| SDK manual | Printed revision | SHA-256 of installed manual source |
|---|---|---|
| `open(2)` | June 3, 2021 | `b49050c11356c4b8ff95db7cb867478a2066d222551ce628cdc37a7227880645` |
| `unlink(2)` | June 4, 1993 | `11aba75cb4181311f92e7c90d56a1318c485d2d7ac0d464c7679af621ba4d8bf` |
| `write(2)` | June 3, 2021 | `c901c9512813ba2542a4ab3cf59414a73a992e6865c07fbea7ca251cd2bd5bad` |
| `close(2)` | April 19, 1994 | `90217028d7a7ff139ddb419f0a7673446c2c65273a9996e1ad4d76e896c255ac` |
| `fsync(2)` | June 4, 1993 | `2399c28e11ea3a1e71b85d0002ac96b540372d405926657a101025f70ae10006` |
| `fcntl(2)` | August 12, 2021 | `9b16ec920ad681d1af2256b2c76d408c7b8506b7cad13aa00d035ba4385787a7` |

Additional installed pages inspected: `dup(2)`, `rename(2)`, `mount(2)`, `fflush(3)` (August 1, 2019), and `synthetic.conf(5)` (September 3, 2019). Old printed revision dates do not mean these were downloaded historical manuals; the SDK provenance above identifies the versions actually read.

The Open Group's direct page fetches returned 403. Its indexed primary text was available for the specific editions linked below. No unexamined POSIX.1-2024 `unlink`, `write`, `close`, or `fsync` text is claimed as evidence.

## PUB-FILE-LIFETIME-001 — names, objects, and open references

Classification: public documentation (POSIX and installed Apple SDK manuals). Hypothetical dialogue/examples are dramatization, not observations.

Sources:

- [POSIX.1-2024, Issue 8: open](https://pubs.opengroup.org/onlinepubs/9799919799/functions/open.html): opening creates an open file description and a descriptor referring to it; the description carries the offset and access/status flags.
- [POSIX.1-2017, Issue 7: unlink](https://pubs.opengroup.org/onlinepubs/9699919799/functions/unlink.html): removes a directory link; removal of contents waits for open references to close after the last link is removed.
- [Open Group Issue 6: close](https://pubs.opengroup.org/onlinepubs/009604499/functions/close.html): deallocates a descriptor, allowing its number to be allocated again. Used only for that stable definition.
- Installed `open(2)`, `unlink(2)`, `close(2)`, `dup(2)`, and `rename(2)`, context above: confirm Darwin's descriptor, last-link/open-reference lifetime, duplicate/shared-offset, and same-filesystem rename behavior. `fcntl(2)` explicitly calls duplicated descriptors references to the same open file description.

Supports: Chapter 14's ordinary regular-file example, successful unlink while already-open access continues, independent creation under the former name, separate opens versus duplicated descriptors, and replacement without retargeting an existing open reference. Unlink success is assumed; the manual also documents possible failures. Releasing a filesystem object's resources is not a promise of physical erasure or immediate free-space recovery in every retained snapshot.

Does **not** establish: permanent identity from a descriptor integer, an immutable view from opening a file, revocation of open references by pathname removal, or a universal implementation of application Save/Trash.

## PUB-VFS-001 — path lookup, mounted views, and representations

Classification: public documentation; `/private` links retain the historical direct-observation classification in `OBS-FS-001`.

Sources:

- [Apple Kernel Programming Guide: File Systems Overview](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/KernelProgramming/Filesystem/Filesystem.html), archived, updated 2013-08-08: vnode representation of active files/directories; per-object operations versus filesystem-wide VFS operations. Used for abstraction only, not its old filesystem support list, boot options, or current extension guidance.
- [Apple kernel `vnode_t` interface](https://developer.apple.com/documentation/kernel/vnode_t), accessed 2026-09-15: vnode references, filesystem-specific state, mount association, and reclamation. A vnode is a kernel representation, not a filename or NAND location.
- Installed `open(2)`: relative paths use the current directory; `openat` can use a directory descriptor. Installed `mount(2)`: mounting exposes the mounted filesystem through a point in the tree and normally hides the underlying directory contents until unmount.
- Installed `synthetic.conf(5)`: limited synthetic symbolic links and empty directories at the root are synthesized during boot. They are not on-disk root entries; an empty synthetic directory cannot itself accept newly created children. This is distinct from firmlinks and ordinary on-disk symlinks.
- [Apple Disk Utility: View APFS snapshots](https://support.apple.com/guide/disk-utility/view-apfs-snapshots-dskuf82354dc/mac), macOS 27 guide displayed, accessed 2026-09-15: snapshot is a read-only view of a parent volume at a moment in time. Existing `PUB-FS-001` continues to cover boot snapshots and System/Data presentation.
- `OBS-FS-001` in `notes/receipts-v0.5.md`: `/etc`, `/tmp`, `/var` links into `/private` on build `26A5425a`; moved narrative ownership to Chapter 14, without claiming re-observation.

Supports: Chapter 14's path/directory-entry/descriptor/vnode distinctions, path catalogue, mount-relative and snapshot-relative existence. The hypothetical Friday/Saturday example illustrates the documented snapshot model. Opening a live file preserves a reference, not the bytes of a historical snapshot.

## PUB-WRITE-001 — acceptance, write, close, and synchronization

Classification: public documentation; Save-button and process-dialogue staging is dramatization.

Sources:

- [POSIX.1-2017, Issue 7: write](https://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html): return count, partial writes, offset changes, and subsequent successful read visibility until another modification. This visibility rule does not assert power-loss persistence.
- [Open Group Issue 6, 2004: fsync](https://pubs.opengroup.org/onlinepubs/009695399/functions/fsync.html): transfer request, implementation-defined transfer nature, waiting for action or error. Current Darwin-specific wording comes from the installed manuals below.
- Installed `write(2)`: number of bytes written is the success result. Installed `fflush(3)`: buffered stream output goes through the stream's underlying write function. Neither an arbitrary application's Save badge nor library buffering is a kernel durability receipt.
- Installed `close(2)`: descriptor deallocation, automatic descriptor freeing at process exit, and possible `EIO` from an earlier uncommitted write. A successful close is not a full device-cache flush contract.
- Installed `fsync(2)`: modified data/attributes move from host to drive; explicitly warns drive buffering/reordering can leave some or all data unwritten after power failure, and refers tighter requirements to `F_FULLFSYNC`. The manual's platter language is historical wording, not a claim that an SSD has platters.

Supports: Chapter 15's ordinary buffered regular-file path; meaningful write success without equating it to durable completion; checked error results; clean process exit not certifying durable storage (Chapter 31 callback). Application buffers, kernel/filesystem work, and device buffers are distinct; not every application or write uses every stage.

## PUB-DURABILITY-001 — filesystem recovery and the device boundary

Classification: public documentation; broader examples are explicitly scoped deductions from those contracts, not a hardware power-cut experiment.

Sources:

- Installed macOS 27.0 SDK `fcntl(2)`, `F_FULLFSYNC`, context and hash above. It documents an fsync followed by a request to flush buffered device data to permanent storage. Exact narrow guarantee: “data that had been fsync'd on the same device before is guaranteed to be persisted when this call returns.” The paragraph lists APFS among supported filesystems, describes a device queue drain/barrier and potential latency, and warns of certain FireWire drives ignoring flush requests. Chapter 15 treats success/error and device compliance as material, and does not generalize that historical warning to the internal Apple SSD.
- [Apple File System Guide FAQ](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/APFS_Guide/FAQ/FAQ.html), retired, updated 2018-06-04: APFS crash protection through copy-on-write; flash translation can group writes into NAND blocks. Used only for recovery-versus-latest-application-state and logical-versus-physical placement distinctions. Not evidence for a universal APFS-to-NAND sequence.
- Installed `rename(2)`: same-filesystem name replacement is a namespace operation; its documented presence guarantee is not a claim that all newly written payload bytes have been flushed. No directory-sync recipe is prescribed.

Supports: separating filesystem consistency, application-level transaction completeness, controller acknowledgement, and persistence; a completion must be interpreted under the request's contract. Exact physical NAND placement, private queues/commands, per-model power-loss protection, and remote/server durability remain unclaimed. A database's two-record thought experiment is illustrative, not a description of a named database implementation.

## DRAM-SSD-FILE-001 — SSD refuses the pathname

Classification: dramatization built around the logical/physical distinction in `PUB-VFS-001` and `PUB-DURABILITY-001`.

Chapter 14 preserves the exact XNU/SSD exchange beginning `read /Users/efeali/book.txt.` and ending `what's a file`. XNU does not literally issue that pathname as a storage command. “SSD” is the storage ensemble's comic voice, not a documented single controller, private protocol, or claim that no storage firmware can ever understand a filesystem. The scene concerns the ordinary filesystem/block-storage boundary.

## PUB-ADDR-001 — CPU address translation needs a context

Classification: official Arm architecture documentation plus Apple's durable VM model.

Sources: [Arm Memory Management guide](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/LearnTheArchitecture-MemoryManagement-101811_0100_00_en.pdf) and Apple's archived [About the Virtual Memory System](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/Articles/AboutMemory.html).

Supports: Chapter 16's virtual/physical distinction, multiple address spaces, mapping lifetimes, and Chapter 18's MMU enforcement. The numeric examples are dramatization. No current M4 page size, translation-level count, TLB topology, or private map is claimed.

## PUB-IOVA-001 — a DMA agent uses an explicitly mapped I/O view

Classification: Apple public security documentation plus separately labeled public reverse engineering.

Sources: Apple's [Direct memory access protections for Mac computers](https://support.apple.com/guide/security/direct-memory-access-protections-for-mac-computers-seca4960c2b5/web), `PUB-DMA-001`, `RE-DART-001`, and the Asahi DART sources recorded in `notes/receipts-v0.5.md`.

Supports: Chapters 16 and 18 separating CPU virtual, physical, and device-visible coordinates. Apple supplies the per-agent IOMMU property; Asahi supplies the DART name. It does not establish one universal Apple device/stream topology.

## PUB-MMIO-001 — an address can select a device interface

Classification: official Arm architectural documentation.

Source: [Armv8-A memory model guide](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20memory%20model%20guide.pdf?revision=58b1dd0a-3800-4218-b21a-f95a0332034c), section 7: Device memory describes peripherals; peripheral registers are commonly memory-mapped I/O, and accesses can have side effects.

Supports: Chapter 16's MMIO distinction only. It does not disclose an Apple-silicon register map or justify a universal driver sequence.

## PUB-VM-LIFETIME-001 — mappings, backing, residency, sharing, and compression differ

Classification: archived Apple documentation and current Apple OSS XNU source.

Sources: Apple's archived [About the Virtual Memory System](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/Articles/AboutMemory.html), [Viewing Virtual Memory Usage](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/Articles/VMPages.html), and Apple OSS XNU [`vm_compressor_internal.h`](https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/vm/vm_compressor_internal.h) plus [`memorystatus_notify.md`](https://github.com/apple-oss-distributions/xnu/blob/main/doc/vm/memorystatus_notify.md).

Supports: Chapter 17's reservation, backing, residency, faults, aliasing, copy-on-write, sharing, reclaimability, compression, and swapping distinctions at a durable conceptual level. Archived constants and a fixed per-page itinerary are excluded.

## PUB-CACHE-001 — cache locality and hierarchy

Classification: official Arm architectural material, used generically.

Sources: Arm's [Cache coherency white paper](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/CacheCoherencyWhitepaper_6June2011.pdf?revision=e5a82cb4-0f87-4f5c-91cf-52b33a5cd1da) and [Armv8-A memory model guide](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20memory%20model%20guide.pdf?revision=58b1dd0a-3800-4218-b21a-f95a0332034c).

Supports: Chapter 19's locality, dirty/write-back state, cache-line granularity, and false-sharing explanation. The chapter deliberately gives no M4 cache sizes, levels, sharing topology, protocol, or replacement policy.

## PUB-COHERENCE-001 — coherence, visibility, and ordering are different jobs

Classification: official Arm architecture and interconnect documentation, applied only at the architectural level.

Sources: Arm Architecture Reference Manual [memory barriers](https://developer.arm.com/documentation/ddi0487/mc/-Part-B-The-AArch64-Application-Level-Architecture/-Chapter-B2-The-AArch64-Application-Level-Memory-Model/-B2-6-Memory-barriers?lang=en) and the [AMBA AXI/ACE specification](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/IHI0022H_amba_axi_protocol_spec.pdf), especially shareability domains and coherent-copy tracking.

Supports: Chapter 19's distinction among coherent copies, synchronization/order, authorization, and persistence. It does not identify Apple's current private coherence fabric, make every device coherent, or claim coherence repairs data races.

## DRAM-CACHE-001 — the cache family

Classification: dramatization grounded in `PUB-CACHE-001`, `PUB-COHERENCE-001`, existing trust-cache receipts, and Chapter 15's durability receipts.

The talking caches, joint-tenancy cache line, and `F_FULLFSYNC` confusion are not traces. They preserve the boundary: “cache” names a strategy, not one authority, and CPU-cache writeback is not a storage-durability oath.

## PUB-DRIVER-001 — DriverKit delegation and client boundaries

Classification: Apple Developer documentation and sample code.

Sources: Apple [DriverKit](https://developer.apple.com/documentation/driverkit), [`IOUserClient`](https://developer.apple.com/documentation/driverkit/iouserclient), [`IODispatchQueue`](https://developer.apple.com/documentation/driverkit/iodispatchqueue), [`IOBufferMemoryDescriptor`](https://developer.apple.com/documentation/driverkit/iobuffermemorydescriptor), and [Communicating between a DriverKit extension and a client app](https://developer.apple.com/documentation/driverkit/communicating-between-a-driverkit-extension-and-a-client-app).

Supports: Chapter 20's specific client → system-managed connection → user-space driver example, validation, memory descriptors, serial driver queues, and asynchronous completion. It does not define every macOS I/O path.

## PUB-HW-PATH-001 — one example is not a universal hardware pipeline

Classification: scoped synthesis of `PUB-DRIVER-001`.

The DriverKit sample documents a client opening an `IOUserClient`, submitting validated method arguments, and receiving a callback. DriverKit separately documents device-family frameworks and hardware-related event sources. Chapter 20 uses that route to demonstrate delegation while explicitly preserving kernel drivers, Apple-provided services, polling, controlled direct mechanisms, and device-specific paths as alternatives.

## PUB-FIRMWARE-001 — peripheral firmware has separate startup models

Classification: Apple Platform Security documentation.

Source: Apple [Peripheral processor security in Mac computers](https://support.apple.com/guide/security/peripheral-processor-security-seca500d4f2b/web).

Supports: Chapters 2 and 21 distinguishing firmware downloaded and verified by the primary CPU at startup from firmware verified by a peripheral processor's own secure-boot chain. These are categories, not a universal simultaneous sequence.

## PUB-CONTROLLER-001 — controller characters are scoped composites

Classification: Apple documentation plus explicitly labeled Asahi reverse engineering already recorded in `notes/receipts-v0.5.md`.

Apple documents peripheral processors for networking, graphics, power management, and other tasks. Asahi documents DCP and S5E on named Apple-silicon targets. Chapter 21 uses generic controller dialogue without claiming a current private ABI, one firmware model, one queue design, or cross-generation topology.

## DRAM-FIRMWARE-PID-001 — launchd asks firmware for a PID

Classification: dramatization grounded in `PUB-FIRMWARE-001`.

The exact launchd/firmware exchange is fictional. “firmware” is a composite character outside the ordinary macOS process model, not an undocumented daemon. Firmware-related loaders, helpers, and update tools may be ordinary processes; their PIDs do not become the PID of code executing on a peripheral processor.

## PUB-SOCKET-001 — a socket is a local endpoint object

Classification: installed macOS SDK manuals and IETF standards.

Sources: macOS 27.0 SDK `socket(2)`, `connect(2)`, `send(2)`, and `recv(2)` manuals; [RFC 9293](https://www.rfc-editor.org/rfc/rfc9293) for TCP and [RFC 8200](https://www.rfc-editor.org/rfc/rfc8200) for IPv6.

Supports: Chapter 22's descriptor/socket/protocol distinction, send-result scope, and protocol-defined address/port/header fields. Local policy may attribute sockets to processes; no claim says every packet carries a macOS PID.

## PUB-NET-PATH-001 — interfaces and device paths are scoped

Classification: public protocol standards and Apple driver documentation.

Sources: `PUB-SOCKET-001`, Apple [NetworkExtension](https://developer.apple.com/documentation/networkextension), and DriverKit networking/device-family documentation under `PUB-DRIVER-001`.

Supports: the conceptual socket → protocol → interface → driver/controller → physical-link handoff. Loopback, tunnels, filtering, polling, kernel paths, and device variation prevent this from being a universal literal pipeline.

## PUB-WAIT-001 — runnable, blocked, spinning, idle, and stalled differ

Classification: Apple OSS/XNU interfaces and durable operating-system model.

Sources: Apple OSS XNU [`sched_prim.h`](https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/kern/sched_prim.h), [`thread.h`](https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/kern/thread.h), and the installed `kevent(2)`/`select(2)` manuals.

Supports: Chapter 23's eligibility/execution/wait distinction, network-read example, timeout, and asynchronous readiness. Scheduler policy, Apple core pipelines, and exact wait-channel internals are intentionally unclaimed.

## PUB-WAKE-001 — wake needs a subject

Classification: Apple public API/support documentation and installed manuals.

Sources: DriverKit `IODispatchQueue` and event-source documentation under `PUB-DRIVER-001`; installed `launchd.plist(5)` and `pmset(1)` manuals; Apple [Set sleep and wake settings for your Mac](https://support.apple.com/guide/mac-help/set-sleep-and-wake-settings-mchle41a6ccd/mac).

Supports: Chapter 24 separating waiter eligibility, timer expiry, callback delivery, launch-on-demand, and whole-system wake. Exact wake routing, model-specific sleep state, and private launch conditions remain unclaimed.

## DRAM-NET-001 and DRAM-WAKE-001 — packet and wake family dialogue

Classification: dramatization grounded in the four receipts above.

The packet does not literally argue about PIDs, and Power Management is an ensemble character. Dialogue never establishes that one packet always launches a service, one callback always uses a particular thread, or one reported wake reason is a complete causal trace.

## PUB-EXCEPTION-001 — synchronous exceptions and asynchronous interrupts

Classification: official Arm architectural documentation.

Source: Arm Architecture Reference Manual for A-profile architecture, [Exception model](https://developer.arm.com/documentation/ddi0487/latest/), including synchronous exception and IRQ categories.

Supports: Chapter 29 separating instruction-caused synchronous exceptions from asynchronous hardware interrupts. It does not disclose current Apple interrupt-controller topology or routing policy.

## PUB-MACH-EXCEPTION-001 and PUB-SIGNAL-001 — operating-system delivery layers

Classification: Apple archived Mach documentation, Apple OSS XNU interfaces, and installed macOS manuals.

Sources: Apple archived [Mach Overview](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/KernelProgramming/Mach/Mach.html), Apple OSS XNU `osfmk/mach/exception_types.h`, and macOS 27.0 SDK `signal(3)`/`sigaction(2)` manuals.

Supports: Mach exception-port delivery and Unix signal semantics, including `SIGINT`, without treating either as a raw hardware interrupt.

## PUB-DEFERRED-WORK-001 — delivery and later work differ

Classification: Apple OSS/XNU architectural interfaces plus scoped explanation.

Sources: Apple OSS XNU interrupt/event and thread scheduling interfaces; `PUB-WAIT-001` and DriverKit event sources. Chapter 29 claims only that prompt event handling can arrange later work. It does not prescribe one deferral mechanism for every Apple device.

## DRAM-SPACETIME-INTERRUPT-001 — the `zzz` bridge

Classification: dramatization. Spacetime is not an Arm processing element. The chapter begins after Chapter 28's exact `zzz`, introduces no Hyprvisor name, and uses the guest/host interruption question only to prepare Chapter 32.

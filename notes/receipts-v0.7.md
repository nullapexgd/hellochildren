# v0.7 Receipts — Evidence Delta

This file records claims added after the frozen v0.6 receipts. The evidence classes and publication rules defined in `notes/receipts-v0.5.md` still apply.

The edition rule remains:

> If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.

## DRAM-DEMOLITION-001 — XNU/launchd demolition-permit exchange

The XNU/launchd demolition-permit exchange is dramatization around the already established authority boundary: XNU can terminate userspace execution, while launchd organizes userspace services.

Supports: Chapter 3's comic distinction between destructive authority and service organization.

Does **not** establish a documented XNU/launchd transcript, private control path, or claim that either role subsumes the other.

## EDIT-RENUMBER-001 — chapter-number migration with no changed factual meaning

The eight late v0.6 chapter sources move to their final v0.7 positions: 14→18, 15→25, 16→26, 17→27, 18→28, 19→29, 20→30, and 21→32. Only filenames, top-level chapter numbers, and affected reference bookkeeping change in this migration.

Supports: stable final source paths for the v0.7 chapter spine.

Does **not** change the factual meaning or evidence classification of the renamed chapters.

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

Supports: Chapter 15's ordinary buffered regular-file path; meaningful write success without equating it to durable completion; checked error results; clean process exit not certifying durable storage (Chapter 29 callback). Application buffers, kernel/filesystem work, and device buffers are distinct; not every application or write uses every stage.

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

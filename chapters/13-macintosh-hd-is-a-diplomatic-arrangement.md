# 13. Macintosh HD Is a Diplomatic Arrangement

Finder shows one disk.

APFS asks a follow-up question.

```text
Finder:
this is Macintosh HD.

APFS:
which one.

Finder:
the one called Macintosh HD.

APFS:
which one.
```

The user sees a coherent directory tree because the filesystem and operating system have agreed to present several storage jurisdictions as one place. This is useful. It is also the friendliest lie in the building.

## Which Macintosh HD?

An APFS container can hold multiple volumes that share free space. On a modern macOS startup disk, Apple documents roles for System, Data, Preboot, Recovery, and VM volumes. A volume role describes how macOS uses that volume; it does not turn the container into five independent physical disks.

```text
User:
how many disks do I have

Disk Utility:
physically, logically, visibly,
or emotionally

User:
the one on my desk

Disk Utility:
excellent, none of those.
```

The container manages shared storage. Volumes provide distinct filesystem identities and roles. Finder provides a human-facing name. The NAND controller underneath has its own opinion about physical placement and has not been invited to the sidebar.

The phrase “the filesystem” has already become plural before anybody opens a file.

## Shared space, separate trouble

Volumes in the same APFS container can draw from shared free space. That is convenient until somebody asks which volume owns the unused bytes.

```text
System volume:
I need more space.

Data volume:
from where

APFS container:
the space.

Data volume:
whose space

APFS container:
please stop bringing property law into allocation.
```

The pool can be shared while the volume roles remain distinct. A file still belongs to a particular filesystem view. A mount still exposes a particular volume or snapshot. Running out of container space can affect neighbors without merging their namespaces or protection rules.

This is another place where physical and logical ownership refuse to line up. The container accounts for capacity. The volume accounts for filesystem objects. The mounted namespace tells a process what it can reach. Finder draws a disk icon and wisely leaves the meeting.

```text
Finder:
12 GB available.

User:
where

Finder:
available.
```

## Two volumes in a very convincing coat

Since macOS Catalina, the startup arrangement separates a read-only System volume from a writable Data volume. Apple uses firmlinks to make selected Data locations appear inside the unified directory tree.

The result looks like one root filesystem to ordinary software and humans. Underneath, paths can cross from one member of a volume group to the other.

```text
Finder:
one Macintosh HD.

System volume:
operating-system content.

Data volume:
changing content.

Finder:
one.

APFS:
they are wearing a coat.
```

A firmlink is not a normal symbolic link. Apple's WWDC19 filesystem session described it as bidirectional traversal between paired System and Data locations, designed so the split remains largely invisible to software.

That distinction matters because the displayed path is not a full storage biography. `/Applications` can look like one directory in the mounted view while system-provided apps and user-installed apps belong to different underlying roles.

```text
Path:
/Applications

User:
where is that

Path:
yes.
```

## Root meets mount state

Root arrives with the traditional expectation that UID 0 owns `/System`.

```text
root:
I own /System.

APFS:
no.

root:
I am root.

SSV:
that's adorable.

root:
remount it writable.

seal:
explain yourself.
```

`SSV` and `seal` are comic voices, not independent daemons waiting behind the mount table.

Unix credentials answer whether a process may perform an operation under discretionary access rules. Mount state answers whether the mounted filesystem view permits writes at all. System Integrity Protection adds mandatory policy. The Signed System Volume adds integrity and boot acceptance.

These are not increasingly prestigious versions of the same permission bit.

```text
root:
mode bits permit write.

Mounted System view:
read-only.

root:
I outrank the bits.

Mounted System view:
I was not discussing the bits.
```

An authorized recovery procedure can change security configuration and produce a different writable situation. That does not mean an ordinary root process in the running system can turn a read-only, sealed boot view into accepted system state by shouting `mount -uw /` from memory.

## The filesystem state, plural

A snapshot records a point-in-time view of an APFS volume. Modern macOS boots from a snapshot of the System volume. Now “what is on disk?” depends on which volume, which snapshot, and which mounted view is answering.

```text
Administrator:
I changed the file.

Snapshot:
not in me.

Administrator:
you are the filesystem.

Snapshot:
I am a filesystem state with a timestamp
and excellent boundaries.
```

Snapshots are not backup magic. They share storage structures and consume space as changed data must be retained. They do, however, give the filesystem authority over time: two legitimate views can disagree about a path because they represent different states.

```text
File:
I exist.

Older snapshot:
never met you.

File:
I have an inode.

Older snapshot:
in which century
```

## The seal would like a word

The Signed System Volume protects system content with a tree of cryptographic hashes whose root measurement is called a seal. On Apple silicon, Apple documents the bootloader verifying the seal before handing control to the kernel under the normal protected boot configuration.

If system bytes no longer match the authenticated structure, successfully writing them does not make them accepted boot content.

```text
root:
the write succeeded.

seal:
and the measurement?

root:
the bytes are right there.

seal:
that was not my question.
```

This is the filesystem version of signing yourself `GenuineApple™`. Possession of modified bytes is not authority to produce the Apple-accepted seal for the normal secure-boot path.

Apple allows lower-security configurations and procedures that deliberately change the protection model. Those are explicit policy transitions. They are not evidence that SSV was decorative all along.

```text
Administrator:
I changed the security configuration.

SSV:
then describe that configuration.

Administrator:
I wanted the old joke where root wins.

SSV:
historical fiction is on another volume.
```

Here, “the write succeeded” concerns altered system content and boot acceptance. Whether those bytes survive a power failure is a separate question. A recovery tool can operate under authority that an ordinary process does not possess. Neither event travels backward in time and turns the original running root shell into Boot ROM's supervisor.

```text
root:
I changed a system file.

Boot policy:
under which configuration

root:
the current one.

Boot policy:
that is a time, not an answer.
```

Filesystems preserve states. Boot policy chooses among states it is willing to trust. The path `/System` cannot explain either decision by itself.

## Namespace lies politely

The directory tree lets the System and Data volumes appear as one navigable place. That saves the user from providing a volume-group UUID before opening Downloads. The visible path still leaves mount state and boot acceptance to their respective offices.

Authority through abstraction is the friendliest form of lying in the house.

Finder closes the information window.

The disk once again appears singular.

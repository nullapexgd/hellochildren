# 1. Nobody Is Actually in Charge

Most explanations of computers begin with a hierarchy.

At the bottom is hardware. Above that is the kernel. Above that is userspace. Somewhere near the top is you, presumably because you paid for the thing.

This is a useful lie.

The truth is considerably funnier.

Your Mac contains processors that do not trust other processors, software that authenticates software that will later replace it, a kernel that can terminate almost every process yet cannot simply demand cryptographic secrets from another security domain, a process with PID 1 that organizes an entire userspace civilization, a graphics server with authority over objects the kernel has no reason to understand as windows, and a Unix user named `root` who has spent the last twenty years discovering that his title is becoming ceremonial.

Everybody is powerful.

Everybody eventually meets somebody to whom that power means absolutely nothing.

That is where the jokes live.

There is no single highest form of authority inside a modern computer. **Authority has a jurisdiction.**

## The customer is always root

You bought the Mac. This gives you important powers.

You may choose the wallpaper.

You may install a menu-bar utility that displays the temperature of a component you cannot replace.

You may bring a cup of coffee within six inches of the keyboard, granting yourself an authority over the machine’s future unmatched by any kernel exploit.

But ownership is not the same as authority inside the system. You can ask macOS to delete a file and be refused. You can become `root` and still meet System Integrity Protection, privacy controls, code-signing policy, hardware-backed security, or a device mapping that regards your user ID as biographical trivia.

```text
root:
I'm root.

MMU:
in which address space

root:
I said I'm root.

MMU:
and I asked which address space
```

Modern macOS is a collection of overlapping constitutions. Unix permissions answer one set of questions. Mandatory access controls answer another. Code-signing policy answers another. The window server, boot chain, Secure Enclave, memory-management hardware, and I/O mappings all answer questions of their own.

The command `sudo` is not a letter from the king. It is a credential accepted by some offices.

## Power needs a noun

Whenever somebody says that a component “controls the system,” ask: controls what?

Execution? Service lifetime? Authentication? Windows? Trust evaluation? Address translation? DMA? Cryptographic keys? Display scanout? Whether a tensor is sufficiently tensor-shaped to interest the Neural Engine?

XNU can suspend a process. It does not personally compose a desktop.

WindowServer can govern the graphical environment. It does not validate the boot chain.

launchd can manage services and bootstrap namespaces. It does not make page-table permissions physically binding.

The MMU enforces translations and access permissions. It does not care about your wallpaper.

The Secure Enclave protects key material and performs security-sensitive operations in a distinct domain. It does not schedule Safari.

The boundaries are not defects in the architecture. They *are* the architecture.

## The family portrait

The conventional diagram looks like this:

```text
user
  ↓
applications
  ↓
services
  ↓
kernel
  ↓
hardware
```

The family portrait looks like this:

```text
Boot ROM:        who allowed you to run
iBoot:           papers
XNU:             I AM LITERALLY THE KERNEL
launchd:         hello children
loginwindow:     identify yourself
WindowServer:    those are my windows
amfid:           signature?
sharingd:        I know a guy
MMU:             not mapped
DART:            absolutely not
GPU:             I rendered it
Display:         it is photons now
ANE:             tensor?
SEP:             wrong jurisdiction
root:            I would like to speak to a manager
```

There is no single manager.

There are managers of departments. There are judges who cannot move furniture, bouncers who cannot write legislation, landlords who do not possess the contents of the tenants’ desks, and hardware clerks who will deny a request in under a nanosecond without once consulting your résumé.

## Authority is relational

Power inside a computer is a relationship between an actor, an operation, an object, and an enforcement mechanism.

Root may read this file under these rules.

This signed process may claim this entitlement under that policy.

This virtual address may translate to that physical page with these permissions.

This device may DMA into these mapped regions and nowhere else.

This boot object may execute because the previous trusted stage authenticated it under the selected security policy.

Remove the nouns and “XNU controls everything” becomes mythology. Add them back and it becomes engineering, though considerably worse merchandise.

```text
XNU:
I control the machine.

Application Processor:
you're running on me

XNU:
same thing

Application Processor:
no
```

## Our house rule

Apple ships internal names that sound like discarded mythology, entitlements that imply broad access, and diagnostic strings written by engineers who were clearly having a day. We will show them without promoting a suggestive noun into a complete undocumented subsystem because it looked cool in monospace.

Some daemons carry more than a hundred entitlement keys in a particular build. An architecturally central daemon may carry eight. Sometimes the visitor needs fourteen badges because it crosses fourteen boundaries. The person behind the desk needs none because it *is* the desk.

```text
sharingd:
I have 134 entitlements.

amfid:
I have 8.

sharingd:
how are you more important than me

amfid:
signature?
```

This book will occasionally end an investigation with the words *we do not know*.

That is not coyness. It is the line separating reverse engineering from fan fiction.

Now let us meet the first relative.

He was here before everybody, and he has never once cared about your Dock.

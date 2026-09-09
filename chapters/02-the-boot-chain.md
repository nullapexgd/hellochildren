# 2. Boot ROM and the People Who Were Here First

Before macOS exists, before XNU exists, before `root` has anything to be root *of*, the machine has to decide what code receives the extraordinary privilege of becoming the machine.

Boot ROM enters the story with the confidence of a character who knows he cannot be uninstalled.

On Apple silicon, the boot chain begins in immutable Boot ROM code established during fabrication. Apple documents the normal macOS path more concretely: Boot ROM hands off to the Low-Level Bootloader (LLB); LLB loads system-paired firmware and the LocalPolicy for the selected system, then hands off to iBoot; iBoot loads the macOS-paired firmware, static trust cache, device tree, and Boot Kernel Collection, and enforces later boot policy such as the signed-system-volume check according to LocalPolicy. Recovery paths differ, and Apple changes details across generations.

The durable point is not that one tiny monarch personally verifies every byte forever. It is that secure boot is staged: later execution depends on trust decisions and policy established before that later code receives control.

XNU does not arrive by kicking down the door.

XNU arrives because the door opened.

```text
Boot ROM:
execute.

later boot stage:
authenticate.

iBoot:
verify.

XNU:
govern.

launchd:
hello children.

SEP:
don't touch my keys.
```

## I was here first

Boot ROM’s authority is enormous and incredibly narrow.

It does not care about Safari.

It does not care about your desktop.

Ask it why Finder moved the icon three pixels to the left and it would, if capable of emotion, resent the electricity required to parse the question.

Its authority is earlier.

Before the later system can argue about users, processes, windows, signatures, and whether `sharingd` truly requires permission to know everybody in the neighborhood, the boot chain establishes which system is permitted to host the argument.

```text
XNU:
I run the machine.

Boot ROM:
who allowed you to run

XNU:
iBoot

iBoot:
who allowed me

Boot ROM:
we are not doing genealogy at boot
```

The family version compresses several stages into a dinner-table exchange. The ledger keeps the documented handoffs honest across device generations, boot modes, and security configurations. XNU’s future power gives it no retrospective authority over the machinery and policy that decided whether XNU could begin.

## Future mayor, present guest

iBoot’s personality is asking for identification.

```text
Kernel:
hey

iBoot:
papers

Kernel:
I'm XNU

iBoot:
signature

Kernel:
bro we've known each other for years

iBoot:
signature.
```

This is our first clean lesson in the difference between identity, trust, and authority.

XNU will shortly become tremendously privileged.

That sentence contains the word *shortly*.

Future privilege is not present authentication. A nightclub bouncer does not let you through because you intend to become mayor after entering. If anything, that makes the bouncer ask a second question.

Trust is not a halo around a binary. It is a decision made under a policy by an earlier trusted mechanism. The objects, signatures, hashes, and selected security policy matter. “Trusted” without the rest of the sentence is another T-shirt looking for trouble.

## LocalPolicy is not local politics

Apple silicon can maintain security policy associated with a selected macOS installation. Apple's boot documentation calls the structure **LocalPolicy** and places it in the verified handoff among LLB, iBoot, and the system being started.

The name does not mean “whatever the current administrator prefers locally.” It is boot-policy material protected and consumed by boot machinery under documented rules.

```text
root:
I have a local policy.

LocalPolicy:
are you cryptographically bound
to this operating system installation

root:
I was thinking casual Friday.

LocalPolicy:
wrong policy.
```

Security modes can be changed through authorized recovery workflows. That proves policy is configurable. It does not prove a running process can edit the boot chain's answer by writing “reduced security” on a sticky note.

```text
Administrator:
I changed the startup security setting.

iBoot:
through recovery and accepted policy state?

Administrator:
yes.

iBoot:
then we have paperwork.

root:
I shouted during normal boot.

iBoot:
then we have audio.
```

Recovery is therefore not merely “macOS, but with fewer apps.” It is a different boot environment with authority for particular repair and policy operations. The machine does not grant those operations to any process that happens to display a wrench icon.

```text
root:
I would like recovery authority.

Recovery:
are you in recovery

root:
I am recovering emotionally.

Recovery:
boot environments remain regrettably literal.
```

That difference matters whenever somebody says an administrator “can” change a boot setting. Yes, through the authorized path. The path is part of the claim. Leaving it out is like saying a passenger can fly the plane because the airline employs pilots.

Normal boot, recovery, and fallback paths do not all begin with the same policy state or promise the same tools. The durable claim is smaller: early trusted code selects and verifies what comes next according to the active boot path and policy. Anything more specific belongs in the receipts with a device generation attached.

This is another kind of authority: not the power to run a process now, but the power to determine which system and security configuration may become the environment where processes later run.

## The other processors have childhoods too

Apple documents peripheral processors dedicated to display, storage, system management, Thunderbolt, graphics, and other functions. Some download verified firmware at startup; others may implement their own secure boot.

This matters because the popular diagram shows hardware as a silent gray rectangle labeled HARDWARE.

The gray rectangle is lying by omission.

Inside it are specialists who also have startup requirements, firmware, memory, protection boundaries, and the capacity to make the main CPU’s day much worse.

```text
Application Processor:
everybody ready?

Display controller:
firmware verified

Storage controller:
firmware verified

Thunderbolt controller:
I brought—

DART:
don't
```

The hardware relatives implement execution privilege, memory translation, DMA isolation, secure key operations, storage translation, rendering, inference, and display. Boot is customs opening several borders in order while everybody insists their form was already stamped.

## The ancestor leaves the plot

Boot ROM establishes the first link and then largely exits our story.

This will become a pattern.

The most powerful character in a particular scene is frequently the one who leaves before everyone else starts arguing.

```text
Boot ROM:
verified.

iBoot:
continue.

Boot ROM:
good luck

[leaves entire plot]
```

Absolute uncle behavior.

Years later, the rest of the family will argue about kernels, userspace, keys, and pixels. Boot ROM will not attend. It checked the guest list.

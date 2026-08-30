# 11. The Hardware Family Dinner

The mistake was inviting everyone.

Until now, the family has argued in departments. Boot authorities left before XNU arrived. Session officials spoke to graphics. SEP stopped answering follow-up mail.

Now everybody is seated at one table.

This is the **hardware family dinner**.

There is a place card for every jurisdiction and no place card labeled *boss*.

## The Application Processor owns the house

XNU begins because XNU always begins.

```text
XNU:
I govern the system.

Application Processor:
on my processor.

XNU:
who the fuck are you

Application Processor:
the processor

XNU:
okay?

Application Processor:
you're running on me
```

The Application Processor implements the CPU privilege architecture on which XNU’s kernel authority operates. This does not make the AP a software monarch deciding whether Finder may open a folder. It makes the AP the physical execution domain within which XNU’s instructions and privilege transitions become real.

```text
XNU:
I control execution.

Application Processor:
within the architecture I implement.

XNU:
same thing.

Application Processor:
no.

SEP:
same here bro

XNU:
SHUT THE FUCK UP
```

## The GPU wants credit

WindowServer arrives carrying a completed frame.

```text
WindowServer:
those are my pixels.

GPU:
I rendered them.

WindowServer:
because I submitted the commands.

GPU:
executed by whom

WindowServer:
you.

GPU:
thank you.
```

The GPU’s authority is enormous within graphics and compute work. It does not govern the graphical session merely because it executes rendering commands. WindowServer does not become silicon merely because it arranged the scene.

Then the GPU gets cocky.

```text
GPU:
I own the pixels.

Display Controller:
lol.

GPU:
what

Display Controller:
give me the frame.

GPU:
why

Display Controller:
they have to leave eventually.
```

The display controller handles scanout and timing work on the path toward the panel.

```text
WindowServer:
THOSE ARE MY PIXELS

Display Controller:
they are currently photons.
```

Every sovereign eventually meets customs.

## ANE has standards

The Apple Neural Engine sits down only after confirming the menu contains tensors.

```text
CPU:
run arbitrary program.

ANE:
no.

CPU:
matrix multiplication?

ANE:
👀

CPU:
neural network?

ANE:
give.
```

Core ML and related frameworks can select accelerators such as the CPU, GPU, and ANE for supported model work. The exact scheduling and supported operations vary. The character’s narrow vocabulary dramatizes specialized authority, not a promise that every neural network executes entirely on ANE.

```text
User:
can you run Doom

ANE:
tensor?

User:
no

ANE:
then perish

GPU:
I can run Doom.

ANE:
congratulations on your
general-purpose workload.

GPU:
you're an accelerator too.

ANE:
I have standards.
```

Power can be deep because it is narrow. ANE does not want the whole computer. ANE wants the tensor, and it would like everyone to stop sending calendar invitations.

## Storage maintains the illusion

APFS believes it manages storage.

The flash controller finds this adorable.

```text
APFS:
block 927 is here.

Storage Controller:
sure.

APFS:
what do you mean sure

Storage Controller:
nothing ❤️
```

Filesystems work in logical structures. Flash storage controllers manage physical media behavior beneath those abstractions, including translation and wear-related work. Exact Apple controller internals are product-specific and not all publicly documented. The general authority is the power to maintain an abstraction convincing enough that the layer above need not know where a particular physical cell went.

Later:

```text
APFS:
WHERE DID BLOCK 927 GO

Storage Controller:
still block 927 to you ❤️
```

Authority through abstraction is the friendliest form of lying in the house.

## The loading dock reports an incident

```text
Thunderbolt:
I brought someone.

DART:
manifest?

Thunderbolt:
he's cool.

DART:
mapping?

Thunderbolt:
we met on a bus.

DART:
absolutely not.
```

Thunderbolt is not the villain. It is an interface capable of bringing powerful peripherals close to the system. That is exactly why DMA protections matter.

The device leans into the room.

```text
Device:
I'm literally hardware.

DART:
and I'm literally the IOMMU.
```

The device returns to the loading dock to complete its paperwork.

## Everyone states their office

The host makes the catastrophic decision to go around the table.

```text
Boot ROM:
hardware root of trust.

iBoot:
verified boot work.

Application Processor:
CPU execution.

XNU:
kernel authority.

launchd:
userspace services.

loginwindow:
authenticated session coordination.

WindowServer:
graphical environment.

securityd:
security services and credentials.

amfid:
signature?

sharingd:
nearby and sharing integration.

SEP:
keys.

GPU:
render and compute.

ANE:
tensor.

MMU:
CPU address translation and permissions.

DART:
DMA mappings.

Memory Controller:
actual memory traffic.

Storage Controller:
the physical storage abstraction
you all take for granted.

Display Controller:
actual scanout.
```

Silence.

The front door opens.

```text
root:
I'm root.
```

Everyone:

```text
HAHAHAHAHAHAHAHAHAHAHAHAHAHA
```

Root is offended because root really is powerful. That makes it worse.

## Uninvited guests

Fake launchd walks in.

```text
fake launchd:
I'm UID 2.

XNU:
GET THE FUCK OUT.

fake launchd:
I'm in supplementary groups.

SEP:
no.
```

Then, from somewhere nobody can locate:

```text
LaunchAngel:
😇
```

Everyone:

> What the fuck.

launchd:

> Don’t worry about it.

Reader:

> I am absolutely going to worry about it.

Narrator:

> The available evidence still does not establish its complete semantics.

Reader:

> I hate this family.

## Nobody owns the Mac

At the end of dinner, no character wins.

Boot ROM’s authority was earlier. XNU’s is deeper in operating-system privilege. launchd’s is organizational. WindowServer’s is graphical.

The MMU and DART turn mappings into refusals.

The GPU, ANE, storage, display, and memory machinery own specialized mechanisms. SEP has a security jurisdiction the Application Processor cannot annex. The AP hosts XNU without becoming XNU.

The system works because these limits meet through boot, IPC, policy, mappings, drivers, queues, shared memory, cryptography, and mutual suspicion.

This is the Apple silicon family.

Not a hierarchy with one god at the top.

A house full of different sovereign assholes, each holding one portion of the lease and none willing to wash the dishes.

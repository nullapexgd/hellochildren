# 9. Memory Has Borders

Software enjoys declarations: this address belongs to process 472; that page is read-only; this device may access this buffer.

Hardware has the less glamorous job of making those sentences survive contact with electricity.

## The bouncer who checks the list

A process sees virtual addresses. CPU hardware translates them and enforces permissions using state arranged by the operating system. Isolation becomes more than a strongly worded comment.

The family calls the relevant translation machinery the MMU.

```text
Safari:
can I read launchd

MMU:
no

Safari:
why

MMU:
wrong address space

Safari:
sudo?

MMU:
that's not how any of this works
```

The MMU does not know Safari is a browser or launchd is PID 1. It knows translations, privilege, access types, and protections: total authority over an operation, total indifference to biography.

```text
root:
UID 0.

MMU:
translation fault.

root:
administrator.

MMU:
translation fault.

root:
wheel group.

MMU:
do you have an address or a podcast
```

XNU configures the state. Hardware enforces it.

Policy without enforcement is a wish.

Enforcement without policy is a very fast misunderstanding.

## Unified does not mean communal

Apple GPUs use unified memory in which CPU and GPU share system memory. Marketing celebrates the lack of a traditional separate VRAM pool.

The family hears “shared” and immediately creates a refrigerator dispute.

```text
CPU:
I need this buffer.

GPU:
I'm using it.

CPU:
it's in my memory.

GPU:
our memory.

ANE:
can I—

CPU + GPU:
NO.
```

Unified memory does not let every engine read every byte. Metal resource modes distinguish shared and private access; synchronization and mappings still matter.

```text
Unified Memory:
I bring this family together ❤️

MMU:
with permissions

DART:
and device mappings

GPU:
and resource modes

CPU:
and synchronization

Unified Memory:
I bring this heavily regulated
family together ❤️
```

The phrase *zero-copy* is often invited to these discussions and should be watched around the silverware.

## The loading dock

High-speed devices use direct memory access so the CPU need not carry every byte personally.

DMA is useful.

Unrestricted DMA is a burglar with excellent throughput.

Apple documents an IOMMU for each DMA agent on Apple silicon Macs. PCIe and Thunderbolt peripherals can access memory explicitly mapped for them, not the whole house.

Apple's public security guide uses the generic term *IOMMU*. Public Asahi Linux reverse engineering identifies the Apple silicon IOMMU hardware as **DART**. That is why the family gives the loading-dock job to DART rather than pretending Apple used the name in the public security page.

```text
Device:
I would like to DMA into memory.

DART:
which memory

Device:
memory

DART:
which.

Device:
0x—

DART:
not mapped

Device:
but I'm hardware

DART:
that's awesome bro
```

Hardware is not one class with a universal backstage pass. A device is hardware. The IOMMU is also hardware. Their disagreement is resolved by an address-translation table, which is the least sentimental possible form of family mediation.

```text
Device:
I'M LITERALLY HARDWARE

DART:
on your I/O mapping
```

DART is the MMU’s cousin who works security at the loading dock.

The CPU enters through the front and meets CPU translation.

A DMA agent arrives at the loading dock.

DART asks for a manifest.

## Thunderbolt brought someone

Thunderbolt’s character exists to make the loading dock anxious.

```text
Thunderbolt:
hey guys

XNU:
what

Thunderbolt:
I brought a device

XNU:
what device

Thunderbolt:
device

DART:
absolutely fucking not
```

Drivers, policy, and mappings may establish access. DART makes “plugged in” different from “owns RAM.”

That distinction becomes more important as interfaces become faster and more capable. A cable should not be a constitutional amendment.

## The landlord’s landlord

Below the address spaces and device mappings sits the machinery arbitrating actual memory traffic.

The book gives the memory controller the exhausted demeanor of a deli counter at noon.

```text
CPU:
memory please

GPU:
memory please

ANE:
memory please

Memory Controller:
take a number
```

Fabric and controller topology varies by generation. “Memory Controller” represents arbitration and movement beneath software abstractions, not one tiny person with a clipboard.

```text
GPU:
I'm rendering at 240 frames per second.

Memory Controller:
and I care because

GPU:
bandwidth.

Memory Controller:
now you're speaking my language
```

At every layer, a grand title becomes a request in somebody else’s queue. XNU sets policy. MMU and DART enforce mappings. The memory fabric arbitrates traffic.

The DRAM cells store charge and have never heard of root.

Authority has finally reached physics.

Physics declines to attend the status meeting.

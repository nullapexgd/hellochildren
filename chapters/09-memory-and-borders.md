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
wrong noun.
```

The MMU has never heard of Safari. It has an address and a permission check.

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

XNU configures the state. Hardware says no at machine speed.

Policy without enforcement is a wish.

Enforcement without policy is a very fast misunderstanding.

## Unified does not mean communal

Apple GPUs use unified memory in which CPU and GPU share system memory. The family hears “shared” and immediately creates a refrigerator dispute.

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

Unified memory does not let every engine read every byte. Metal still distinguishes shared and private storage modes, and synchronization still matters, because the word *unified* did not destroy computer science.

```text
Unified Memory:
everybody shares one pool.

CPU:
so I can read every buffer.

MMU:
no.

GPU:
same question.

MMU:
different office.

Unified Memory:
I was talking about the DRAM.
```

The phrase *zero-copy* is often invited to these discussions and should be watched around the silverware.

## The loading dock

High-speed devices use direct memory access so the CPU need not carry every byte personally.

DMA is useful.

Unrestricted DMA is a burglar with excellent throughput.

Apple documents an IOMMU for each DMA agent on Apple silicon Macs. PCIe and Thunderbolt peripherals can access memory explicitly mapped for them, not the whole house.

Apple's public security guide calls them IOMMUs. Public Asahi Linux reverse engineering identifies the Apple silicon hardware as **DART**. The receipts keep the distinction. DART keeps the loading dock.

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

The device is hardware. So is the thing denying it.

```text
Device:
I'M LITERALLY HARDWARE

DART:
on your I/O mapping
```

DART is the MMU’s cousin who works security at the loading dock.

## The address dispute

Then root returns carrying hexadecimal.

```text
root:
I need memory at 0x1000.

MMU:
in whose address space

root:
the computer's

MMU:
adorable.

Device:
my 0x1000 maps somewhere else.

DART:
if I say it does.

root:
I have the address.

MMU:
you have an address.

root:
WHICH ONE IS REAL

Memory Controller:
do you want memory or philosophy
```

Same number, different maps. Root brought an address and assumed it was the deed.

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

Drivers and mappings may eventually let the device in. “Plugged in” is not the same as “owns RAM.”

A cable should not be a constitutional amendment.

## The landlord’s landlord

Below all those maps, somebody still has to move the bytes. The memory controller runs the deli counter.

```text
CPU:
memory please

GPU:
urgent memory please

ANE:
mine is neural.

Memory Controller:
congratulations on the adjective.

CPU:
I'm the CPU.

Memory Controller:
take two numbers.
```

Fabric and controller topology varies by generation. “Memory Controller” represents arbitration and movement beneath software abstractions, not one tiny person with a clipboard.

XNU sets policy. MMU and DART enforce mappings. The memory fabric arbitrates traffic.

The DRAM cells store charge and have never heard of root.

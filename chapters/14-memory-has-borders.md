# 14. Memory Has Borders

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

The same virtual address can appear in two processes and resolve to different physical memory, or fail in one while succeeding in the other. The number is meaningful only with the translation context that gives it jurisdiction.

```text
Process A:
0x1000 is my page.

Process B:
0x1000 is also my page.

root:
one of you is lying.

MMU:
both of them brought an address space.
```

Context switching therefore changes more than whose instructions run next. It also changes which address map the CPU uses for that execution context. The hardware does not conduct a hearing about the process's brand identity. It performs the configured translation and permission checks.

```text
Safari:
but I am a browser.

MMU:
page table.

Safari:
I have tabs.

MMU:
wrong table.
```

## Reserved, mapped, present, useful

Software says it “has memory” with the confidence of someone who has never been asked a follow-up question.

A range of virtual addresses can be reserved without every page currently having physical storage behind it. A page can be mapped but protected against a particular kind of access. The operating system can arrange backing and residency as needed. The program receives an address-space story simple enough to write code against.

```text
Process:
I allocated four gigabytes.

Physical memory:
did you

Virtual memory system:
don't start.

Process:
the function returned success.

MMU:
touch a page and we'll discuss specifics.
```

This is the abstraction that lets the system manage finite hardware while giving processes private, orderly address spaces. The lie becomes a contract: use these addresses under these rules, and the kernel plus hardware will arrange what they mean.

Then a page fault occurs and everyone acts betrayed.

```text
CPU:
this translation needs attention.

Process:
I was promised memory.

XNU:
you were promised an address.

Process:
that feels legally distinct.

XNU:
because it is.
```

A fault is not automatically a crash. It can be part of ordinary virtual-memory work, or it can report an access the process is not allowed to make. The same hardware event can lead to very different outcomes because the policy state around the address differs.

The MMU still does not know why the page matters. It knows whether the configured translation permits the access. XNU supplies the meaning and handles the interruption. Hardware supplies the refusal quickly enough that the forbidden read does not become a memoir.

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

Unified memory also does not abolish scarcity. CPU and GPU avoiding needless copies can be a large win, but they still contend for finite capacity and bandwidth. One pool reduces some borders. It does not repeal scheduling, synchronization, storage modes, or the possibility that everybody wants the same resource at once.

```text
GPU:
I need six gigabytes.

CPU:
I also need six gigabytes.

Unified Memory:
you have correctly identified twelve gigabytes of desire.

Memory Controller:
I traffic in service, not desire.
```

The memory controller does not award bandwidth based on Unix seniority. It arbitrates hardware requests under hardware rules. Root can influence workloads through software. Root cannot attach a résumé to each DRAM transaction.

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

DMA removes the CPU from carrying each byte. It does not remove the operating system and IOMMU from deciding which buffers the device can address.

```text
Device:
I can access memory directly.

DART:
directly through this map.

Device:
that feels less direct.

DART:
security often does.
```

The map can be narrow and temporary. A driver can arrange access for a buffer needed by one operation without turning the device into a co-owner of physical memory.

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

The complete dispute fits on one napkin:

```text
process virtual address
        |
        v
   CPU MMU map ---------> physical memory

device-visible address
        |
        v
  IOMMU / DART map -----> permitted physical memory
```

The two arrows can land on the same physical pages when software deliberately arranges it. They do not use the same address vocabulary merely because both eventually reach DRAM.

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

Arbitration is another authority that sounds larger than it is. The controller can decide whose transaction proceeds and when. It does not decide whether Safari deserved the page or whether a DMA request was morally justified.

```text
Memory Controller:
GPU, then CPU, then ANE.

CPU:
why

Memory Controller:
traffic.

CPU:
I am the Application Processor.

Memory Controller:
application denied until ticket 43.
```

XNU sets policy. MMU and DART enforce mappings. The memory fabric arbitrates traffic.

The DRAM cells store charge and have never heard of root.

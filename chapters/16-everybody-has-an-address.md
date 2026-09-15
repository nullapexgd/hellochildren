# 16. Everybody Has an Address

Computers use the word *address* the way a family uses “home”: confidently, emotionally, and with several incompatible maps in the glove compartment.

An address is not a thing. It is a coordinate interpreted by some system. The number can be perfectly valid and still belong to the wrong map.

## Same number, different city

A process normally works with virtual addresses. Two processes can both use the same numeric address without referring to the same physical memory. Each brings an address-space context that gives the number meaning.

```text
Process A:
0x1000 is mine.

Process B:
0x1000 is mine.

root:
one of you is lying.

MMU:
both of them included a city.
```

The operating system arranges mappings; the CPU's memory-management hardware uses the active translation regime to translate and check an access. A number copied out of one process is not a universal pointer that another process can dereference by confidence.

This is why a crash report can display an address without providing the bytes, object, or source line a human hoped it would identify. The number needs its execution context, mapping state, and time. Address-space layouts change. Mappings appear and disappear. A coordinate without its map is a souvenir.

```text
Developer:
the bug is at 0x1042c0000.

Debugger:
in which process, image, run, and mapping?

Developer:
the hexadecimal one.

Debugger:
excellent font choice.
```

## The map currently in force

When the CPU executes a load or store, hardware does not ask which application logo is bouncing in the Dock. It consults the translation and permission state in force for that execution context.

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

The same virtual address can translate differently, lack a valid mapping, or permit different kinds of access under another context. A context switch therefore changes more than whose instructions receive CPU time. It also lets execution proceed under the map assigned to that context.

The word *physical* does not rescue us from qualification. A physical address is a coordinate in a physical address space used beneath translation. It is not necessarily a DRAM-cell serial number, a promise about one package location, or a deed granting the speaker access. Hardware ranges can lead to memory or to device interfaces. Platform details determine what a given physical range means.

```text
root:
I have the physical address.

MMU:
how did you get here

root:
administrator.

MMU:
that is still not a map.
```

Mappings also have lifetimes. XNU can replace or remove a mapping; translation hardware must then stop relying on obsolete translation state. Architectures provide mechanisms for maintaining translation caches and ordering the change. The details matter enormously to kernel code and very little to a process holding yesterday's pointer.

```text
Process:
but this address worked earlier.

XNU:
the lease ended.

Process:
the number is unchanged.

XNU:
so is the street number after an eviction.
```

A pointer value therefore does not carry a permanent guarantee that the same mapping still exists. Programs need object-lifetime and synchronization rules; hexadecimal cannot provide either. “Valid address” always has an implied time as well as an address space.

## The device brought its own map

Devices capable of direct memory access need addresses they can use for their transactions. On Apple silicon Macs, Apple documents per-agent IOMMUs that restrict DMA agents to explicitly mapped memory. Public Asahi Linux work identifies Apple's relevant IOMMU hardware as DART; Apple’s public security guide uses the generic term IOMMU.

A device-visible or I/O virtual address is interpreted through that device's I/O mapping. It can be numerically identical to a CPU virtual address and mean something else. It can eventually reach physical pages also mapped for a process, but that agreement exists because software arranged both maps—not because the numbers recognized each other at a conference.

```text
Device:
I have 0x1000.

Process:
me too.

Device:
twins?

DART:
complete strangers with matching luggage.
```

The benefit is controlled delegation. A driver can arrange a mapping for the buffers needed by an operation without granting the device every byte in the machine. DMA avoids making the CPU personally carry each byte. It does not abolish boundaries; it gives the loading dock a faster conveyor belt and a stricter guest list.

An I/O address is therefore not “more real” than a process address. It answers a different question: what coordinate may this DMA agent present under this I/O translation context?

The map may also distinguish devices or streams. A coordinate accepted for one agent does not become a transferable invitation for every peripheral. The number is part of a sentence whose subject is the device and whose verb is the configured translation.

## The register lives at an address too

Memory-mapped I/O gives another use for address-shaped numbers. A range in a processor-visible address space can select registers or windows belonging to a device rather than ordinary RAM. Loads and stores to that range can communicate with hardware.

The syntax is dangerously familiar.

```text
CPU:
store this value at the address.

DRAM:
not mine.

Device register:
I received it.

CPU:
you all dress exactly alike.
```

That resemblance does not mean a device register behaves like normal memory. Ordering, access width, side effects, and valid operations depend on the hardware contract. Reading may acknowledge an event. Writing may start an operation. Treating an MMIO register as an ordinary variable is how a convenient abstraction files a noise complaint.

The exact Apple-silicon register maps and routes vary by component and generation. This chapter does not invent one universal path. It needs only the architectural distinction: an address can select device I/O rather than storage backed like ordinary program memory.

The kernel and drivers must also access such ranges through mappings appropriate to the platform. Saying “the register is at address X” skips who can issue the access, through which mapping, with which attributes, and under which ordering requirements. A datasheet coordinate is not an entitlement.

```text
Driver:
I know where the register lives.

MMIO:
do you know how to knock

Driver:
store 1?

MMIO:
please read the part after the address.
```

This is why register documentation contains more than columns of numbers. The address locates an interface. The interface defines what accesses mean.

## Everybody stop saying address

By now the table contains CPU virtual addresses, physical addresses, I/O virtual addresses, and MMIO ranges. Someone brings up a network address. Someone else pastes a URL. A geographer opens the door, sees the hexadecimal, and leaves.

```text
Network stack:
I have an address.

MMU:
not mine.

Browser:
I have an address bar.

MMU:
not a bar.

Coordinates:
latitude, longitude.

MMU:
finally, somebody labeled the axes.
```

These uses share an idea—locating something within a scheme—but not a lookup mechanism or authority. A URL is not translated by a page table. A socket address is not a physical-memory coordinate. A CPU virtual address does not tell DART what a device may DMA.

Even the phrase *memory address* can conceal which observer is speaking. A debugger reports process virtual addresses because those are useful for understanding a task. A DMA descriptor uses the device-facing coordinate established for that transfer. Hardware documentation may describe physical or MMIO ranges. Converting between them is privileged machinery, not a formatting operation.

The address dispute from the family can now be settled without choosing one winner:

```text
root:
WHICH ONE IS REAL

MMU:
which map

DART:
which agent

Device register:
which interface

root:
I hate nouns.
```

They are all real within their jurisdictions. None is self-authenticating. The number points only after somebody supplies the map currently authorized to interpret it.

And even after an address translates successfully, we still have not answered whether anything is resident there, who may share it, or what happens on the first touch.

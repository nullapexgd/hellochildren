# 18. Memory Has Borders

The previous chapters gave everyone an address, a mapping, and several opportunities to misunderstand the word *shared*.

Now the hardware checks the paperwork.

Software can declare that a page is read-only or that a device may touch one buffer. The declaration matters because machinery exists to enforce it while the access is happening.

Policy without enforcement is a wish. Enforcement without policy is a very fast misunderstanding.

## The bouncer does not know Safari

For CPU memory accesses, the MMU translates addresses and checks permissions encoded in the active translation state. XNU arranges policy and mappings. Hardware applies the resulting rules without rereading the application's biography.

```text
Safari:
I need this page.

MMU:
not mapped.

Safari:
I'm Safari.

MMU:
is that an address space or a podcast
```

The joke is not that the MMU outranks the kernel. The kernel is responsible for constructing and changing the relevant state. The MMU's authority is narrower and more immediate: given this access and this active translation context, translate it or refuse it.

That refusal can generate a fault for the kernel to handle. The kernel may repair an ordinary missing mapping or treat the access as invalid. Enforcement reports the event; policy decides what the event means next.

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

Root's credentials can influence what XNU authorizes. They are not fields in every hardware translation request. By the time the load reaches the MMU, nobody is attaching a résumé.

The division of labor is why “the hardware allowed it” can be misleading. Hardware enforced the state it was given. That does not prove the state represented good policy, only that the access matched it. A kernel bug or mistaken mapping can make a mechanically valid access catastrophically inappropriate.

```text
MMU:
permitted.

Security review:
should it have been?

MMU:
I do enforcement, not regret.
```

## The loading dock

Devices capable of direct memory access can move data without making a CPU core carry each byte. That is valuable. A device with unrestricted DMA would also be a burglar with excellent throughput.

Apple documents an IOMMU for each DMA agent in Apple SoCs. For PCIe and Thunderbolt peripherals on Apple silicon Macs, the public security model restricts access to memory explicitly mapped for the device. Public Asahi Linux reverse engineering calls the relevant Apple hardware DART. The evidence ledger keeps those names and sources separate.

```text
Device:
I would like to DMA into memory.

DART:
which memory

Device:
memory

DART:
which.
```

DART does not need to understand the user's document, the driver's product name, or why the transfer would improve quarterly revenue. It receives an I/O address under a mapping context and either translates it into permitted memory or refuses it.

```text
Device:
but I'm hardware

DART:
that's awesome bro

Device:
I'M LITERALLY HARDWARE

DART:
on your I/O mapping
```

The device is hardware. So is the border.

A driver can arrange access to a buffer needed for an operation without making the device co-owner of physical memory. The map can be scoped and later withdrawn. DMA is direct with respect to CPU copying, not direct with respect to constitutional government.

Completion matters to the mapping lifetime. Software cannot safely recycle a buffer merely because it has become bored with the operation; the device and driver contract must establish when the transfer no longer depends on that mapping. Accessibility, ownership, and lifetime remain different nouns even at the loading dock.

## Thunderbolt brought someone

Thunderbolt's role in the family is to arrive with a peripheral and treat the cable insertion as sufficient character evidence.

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
absolutely fucking not.
```

The refusal is the opening position, not the whole device lifecycle. Drivers, policy, and mappings may establish the access an operation needs. “Connected” still does not mean “may inspect arbitrary RAM.”

A cable should not be a constitutional amendment.

Nor is isolation the same as uselessness. The goal is not to prevent peripherals from moving data; it is to let them move the particular data required for an authorized operation. A border that can never open is a wall. An IOMMU is useful because software can create doors with addresses and close them again.

This boundary is especially useful because it reveals that hardware is not one united political party. The peripheral is hardware. DART is hardware. The memory controller and fabric are hardware. They have different jobs and do not acquire collective ownership merely because a teardown labels them all silicon.

## The landlord's landlord

After CPU and device requests survive their respective maps, traffic still has to move through the memory system. The memory controller and fabric arbitrate service among agents. Their exact topology and policy vary by Apple-silicon generation, so “Memory Controller” is the book's character for this layer, not a claim about one tiny universal block with a deli ticket printer.

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

Arbitration is power over timing and service, not policy over the meanings of the bytes. The controller does not decide whether Safari deserved a page. It does not inspect a Unix UID before every transaction. It does not resolve a data race because one participant sounded sincere.

```text
XNU:
I authorized the mapping.

MMU:
I enforced the CPU access.

DART:
I constrained the device.

Memory Controller:
I moved the traffic.

DRAM:
I held charge.

root:
so which one of you works for me

Hardware:
define works
```

The DRAM cells store charge and have never heard of root.

## Borders are a joint production

No one mechanism supplies the entire security story. Software chooses mappings and responds to faults. Translation hardware checks accesses. Device IOMMUs constrain DMA. Controllers arbitrate transactions. Each layer depends on another without becoming the other's supervisor.

An incorrectly configured map can authorize the wrong access at machine speed. A correct policy that is never encoded into enforceable state remains prose. Hardware enforcement is not wise; software policy is not physical. The useful result comes from their agreement.

```text
Policy:
this device may use these pages.

DART:
map?

Policy:
I wrote a memo.

DART:
then the memo may DMA.
```

Memory has borders because policy is translated into mechanisms that understand narrower nouns: this context, this mapping, this access type, this transaction. None of them needs to understand the whole machine to stop one forbidden byte.

This is the recurring family trick in its most literal form. XNU has broad authority to create the rules. MMU and DART have brutally narrow authority to apply configured rules to individual accesses. The memory controller has authority over service. DRAM has the final authority to be finite. None can substitute for the others, and none needs a complete theory of macOS.

That is also why a successful access does not settle who has the newest copy. Once several cores begin keeping fast private memories of shared reality, the family needs another office.

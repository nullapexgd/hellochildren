# 17. That Is Not Your Memory

Software says it “has memory” with the confidence of someone who has never been asked whether it means an address range, physical pages, file backing, compressed state, a shared buffer, or a receipt from `malloc`.

Memory ownership is mostly a collection of carefully scoped relationships wearing one trench coat.

## Reserved for whom

A process can receive a range of virtual address space before every page in that range has resident physical storage. The reservation matters: it prevents unrelated mappings from occupying those coordinates in that process. It does not mean a warehouse employee has placed labeled DRAM behind every byte.

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

The distinction is useful, not fraudulent. Programs get orderly address ranges; the system can arrange backing and residency as the pages are used. A large virtual range need not consume an equally large set of resident pages at the instant its starting address is returned.

Reserved also does not mean accessible in every way. A mapped region has protections. Read permission, write permission, and executable use are separate questions enforced through the active mappings. The process may own the reservation and still lose an argument with the first store instruction.

```text
Process:
my region.

MMU:
read-only.

Process:
but mine.

MMU:
you own a museum too?
```

## Backed by what

A virtual-memory region can be backed by different kinds of objects. File-backed mappings relate memory contents to a file. Anonymous memory uses the virtual-memory system's backing rather than giving the process a pathname to present at reception. Shared mappings can connect more than one address space to related underlying state.

The word *backed* is another scoped promise. It describes where the virtual-memory system can obtain or preserve contents under that mapping's rules. It does not say every page is currently in DRAM, that the process owns the underlying file, or that modifying one view immediately grants write authority over every other view.

```text
Process:
where is my page

VM object:
what do you need it for

Process:
I want to point at it.

VM object:
you already have an address.
```

Aliasing makes the separation harder to ignore. More than one virtual range can refer to the same underlying memory object or pages. The virtual addresses differ while the bytes are shared. Conversely, equal-looking virtual addresses in different tasks can refer to different objects. Neither the number nor the word *mapping* identifies the storage alone.

```text
Address A:
I am different from Address B.

VM object:
both of you point here.

Address B:
this family is humiliating.
```

Mach's VM model uses memory objects and mappings to separate the process-visible range from the object's contents and current residency. The implementation is more detailed than this family conversation; the important boundary is that map, object, and physical page are not synonyms.

## Present where

When the CPU touches an address whose translation needs attention, it faults. A fault is an event, not a verdict.

The kernel may resolve it by arranging a page and mapping, retrieving file-backed contents, or performing copy-on-write work. If the requested access is invalid, the outcome can instead become an exception and eventually terminate the process. “Page fault” therefore does not mean either “routine” or “crash” without the surrounding state.

```text
CPU:
this translation needs attention.

Process:
I was promised memory.

XNU:
you were promised an address under conditions.

Process:
you added words.

XNU:
the words were in the contract.
```

Resident means present in physical memory now. It is a time-sensitive property. A page can be reclaimed and later reconstructed from its backing. Anonymous contents can participate in the system's compression and swapping machinery under pressure. None of those transitions changes the source code's pointer spelling.

Apple's published XNU source contains a VM compressor and documents compressed anonymous memory as a distinct part of its memory accounting. That establishes a real mechanism, not permission to narrate a fixed per-page itinerary for every macOS release. The family is allowed to know compression exists; it is not allowed backstage with a stopwatch.

```text
Process:
where did my page go

Compressor:
it got smaller.

Process:
can I still use the pointer

Virtual memory system:
that's why we didn't give you directions.
```

Some memory cannot be treated as casually. Kernel and device operations may require pages to remain resident or to meet constraints while an operation is in flight. The exact interfaces and categories vary; the general lesson is enough here: reclaimability is another property, separate from mapping and accessibility.

```text
Process:
I can access it.

VM system:
currently.

Driver:
I need it to stay put.

VM system:
different request, different paperwork.
```

Memory pressure exposes these distinctions. The system can reclaim clean file-backed contents that can be read again, compress anonymous memory, swap eligible state, or ask and compel processes to reduce demand. “Free memory” is not the only usable resource, and “used memory” is not a verdict that every byte is equally irreplaceable.

## Shared under which rules

Two mappings can share underlying contents. That fact alone does not tell us what happens when one participant writes.

With copy-on-write, participants can initially share pages while reading. A write causes the writer to receive a private copy for the affected content. The optimization avoids copying everything in advance while preserving the promised separation once mutation begins.

```text
Process A:
we share this page.

Process B:
beautiful.

Process A:
I changed it.

Copy-on-write:
you changed yours.

Process B:
our relationship had conditions?
```

Other shared-memory arrangements are intentionally shared: a writer's changes are meant to become visible to another participant under the relevant synchronization rules. Shared does not mean synchronized, and synchronized does not mean authorized. Software still needs a protocol for deciding who may modify which data and when another observer can safely rely on it.

The map may permit both participants to write while the program remains catastrophically wrong. The MMU enforces access permissions, not invariants like “the queue length matches the number of elements.” Hardware can protect a page from an unauthorized store. It cannot make two authorized writers emotionally ready for concurrency.

Protection is also scoped to an access through a mapping. It is not moral ownership of the underlying object. One task may have a read-only view while another authorized task has a writable mapping. The first task's inability to store does not prove that the bytes are immutable everywhere.

Revoking or changing a mapping adds a time boundary. A pointer that was valid during one phase can become unusable after an object is released or remapped. The virtual-memory system can enforce the new state; it cannot retroactively make stale program references sensible. Lifetime bugs are what happen when software keeps a coordinate after the relationship that gave it meaning has ended.

## Unified is not communal

Apple GPUs use a unified memory model: CPU and GPU can work with system memory without treating separate device memory as the default arrangement. This removes expensive copies in important cases. It does not turn all memory into a public park.

Metal still distinguishes storage modes. Shared resources are accessible to CPU and GPU; private resources are GPU-only. Synchronization and resource-lifetime rules still matter. *Unified* describes the memory architecture, not a universal access-control override.

```text
Unified Memory:
everybody shares one pool.

CPU:
so I can read every buffer.

MMU:
no.

GPU:
same question.

Metal:
also no.

Unified Memory:
I was talking about the DRAM.
```

Nor does one pool abolish scarcity. CPU, GPU, ANE, displays, and other agents can all demand capacity and bandwidth. Unified memory can avoid copies; it cannot fit twelve gigabytes of desire into eight gigabytes by appreciating the application's vision.

```text
GPU:
I need six gigabytes.

CPU:
I also need six gigabytes.

Unified Memory:
you have correctly identified twelve gigabytes of desire.
```

The phrase *zero-copy* should therefore be asked which copies it eliminates, along which path, under which storage mode. It is an optimization claim, not diplomatic immunity.

A process can have an address without a resident page. Two processes can share backing without sharing future writes. CPU and GPU can use one physical pool without possessing identical access. The hardware borders in the next chapter make those distinctions enforceable.

# 19. The Cache Has Receipts

The word *cache* means “a faster place holding something useful nearby.” This definition is broad enough to start several unrelated arguments before breakfast.

The CPU has caches. The filesystem and kernel keep cached data. Browsers cache resources. Networks cache answers. Apple documents trust caches used in code-signing policy.

These things are related by a strategy, not a chain of command.

## Which cache

The trust cache is not networking. The browser cache is not a CPU cache. Clearing website data does not invalidate an L1 line, and flushing a processor cache does not persuade AMFI to trust unsigned code.

```text
User:
clear the cache.

CPU cache:
which one

Browser cache:
which one

Trust cache:
absolutely not

User:
I clicked the button.

All caches:
whose button
```

The shared idea is locality: keeping a copy, translation, decision, or result where a future lookup can use it more cheaply. The stored object, owner, validation rule, and consequences of staleness are completely different.

A DNS cache can remember an answer about a name. A browser cache can reuse a response. A page or buffer cache can let file data remain available in memory. A CPU cache can hold copies of memory locations close to a core. A trust cache can participate in code-signing trust decisions. “Cached” never tells us whether the thing is a byte, a name result, or an authorization fact.

## Close enough to lie quickly

CPU caches reduce the cost of repeatedly reaching farther into the memory system. Implementations use hierarchies and policies tuned for locality, but this chapter does not invent a cache topology for the author's particular M4. The architectural point survives without guessing sizes, sharing arrangements, or replacement algorithms.

A core can perform a load and obtain data from a nearby cache rather than waiting for DRAM. A store can update cached state under the architecture's memory and coherence rules. This is how fast execution avoids turning every instruction into a pilgrimage.

It is also how the sentence “the value is in memory” becomes hostile.

```text
Core 1:
I have the value.

DRAM:
not that value.

Core 1:
near me.

DRAM:
you left out two important words.
```

With a write-back cache, modified data may be dirty in a cache before it is written to a farther level or memory. Dirty is accounting, not scandal: the cached copy contains a modification that still needs propagation under the relevant policy.

This is not the durability story from Chapter 15. Writing back a CPU cache line toward memory does not mean a document reached persistent storage. DRAM itself normally depends on power. The word *writeback* changes objects halfway through the book and hopes nobody checks its identification.

## Everybody saw a different yesterday

Multiple cores make private fast copies useful and shared reality difficult. If one core modifies a location, another core must not indefinitely treat an older cached copy as current when the architecture and program require visibility.

Cache coherence mechanisms manage this problem for coherent participants. They track or communicate enough state to keep copies of a memory location from becoming permanently contradictory under the coherence rules. A line may be invalidated, updated, obtained with suitable ownership, or written back depending on the design.

```text
Core 1:
x is 2.

Core 2:
x is 1.

Core 1:
I changed it.

Core 2:
I was not copied on that email.

Coherence:
this is why nobody gets private reality unsupervised.
```

The family metaphor has a limit: coherence is not one daemon sending polite notifications, and the exact protocol is implementation-specific. Official Arm material describes coherent systems and cache maintenance at the architectural level. It does not justify assigning a guessed Apple-silicon interconnect or per-core cache layout to this Mac.

Nor does coherence alone make arbitrary concurrent code correct. A coherent system can ensure that cores participate in a consistent protocol for a location while a program still lacks the synchronization needed to establish order between operations.

Granularity adds comedy. Caches generally manage blocks of neighboring bytes rather than following the programmer's object boundaries. Two independent variables placed close together can therefore make cores contend over one cache line even though the source code insists they have never met. This performance problem is commonly called false sharing. The variables are logically separate; the cache's unit of custody is larger.

```text
Variable A:
I have nothing to do with Variable B.

Cache line:
joint tenancy.

Variable B:
we don't even speak.

Cache line:
you both keep renovating the kitchen.
```

## Coherence has a narrow job

Suppose two threads update a queue without a lock or another correct synchronization mechanism. Coherence does not infer that the queue length should equal the number of elements. It does not choose which high-level operation happened first. It does not upgrade “eventually visible” into the ordering contract the algorithm forgot to request.

```text
Thread A:
I wrote the pointer.

Thread B:
I read the flag.

Thread A:
then you understand the whole update.

Memory ordering:
based on what

Thread A:
vibes shared across cores.
```

Architectures provide ordering primitives and synchronization operations so software can establish the relationships it needs. Compilers and CPUs may otherwise perform transformations allowed by the language and architecture. A correct concurrent program uses the relevant rules instead of assuming that source-code order is a notarized timeline.

Coherence also does not decide permission. The MMU can reject an access before a core participates in the cache conversation. DART can constrain a device's DMA. A coherent agent is not automatically an authorized agent.

```text
Device:
I can stay coherent.

DART:
are you mapped

Device:
different achievement.

DART:
correct.
```

Some devices or mappings require explicit cache-maintenance and synchronization work; details depend on the architecture and interface. The safe general claim is not that every participant is magically coherent. It is that visibility has a protocol, and software must use the contract for the participants involved.

## Writeback is not a durability oath

Chapter 15 followed a write toward persistent storage and asked when it could survive power loss. This chapter follows cached memory state and asks when another observer may rely on it. The words overlap because computing enjoys reusing verbs after the warranty expires.

Cleaning or writing back a CPU cache can move dirty data toward a point required by the memory-sharing contract. Invalidating a cache can ensure an old local copy is not reused. Barriers can order relevant operations. None of those acts is, by itself, `F_FULLFSYNC` for a file.

```text
CPU cache:
written back.

Application:
my document is durable?

DRAM:
I still require electricity.

SSD:
nobody has even called me.
```

The reverse confusion is just as bad. A durable file does not make an unrelated in-memory data race correct. Storage persistence and inter-core visibility are different jurisdictions with different failure models.

Likewise, eviction is not deletion from the underlying truth. Removing a clean CPU-cache line merely means a later access must obtain the data elsewhere. Evicting a browser response does not delete the origin server. Removing a cached trust decision does not rewrite the signed program. A cache may forget its copy without acquiring authority to erase the source.

The cache has receipts, but every receipt names the object and boundary it covers. A CPU cache can answer questions about a memory location's local copy and propagation. A filesystem cache can answer different questions about file data. A trust cache can participate in deciding which code is accepted. A browser cache can preserve the logo you were trying to replace.

```text
User:
I cleared the cache.

Browser:
yes.

CPU:
no.

AMFI:
absolutely not.

User:
why is that sentence never complete

Cache family:
because you keep omitting the noun.
```

The book's rule survives another ambiguous word. Authority over a cached copy is authority over that copy, under that cache's validation and visibility rules. It does not quietly expand into authority over every object that has ever been described as “cached.”

Now that memory can be named, mapped, protected, shared, and kept coherent, the software stack will take credit for touching the hardware.

It mostly did not.

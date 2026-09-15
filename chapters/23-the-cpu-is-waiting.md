# 23. The CPU Is Waiting

The program waits for a reply. The thread waits on a socket. The core runs another thread. The pipeline stalls on memory. The whole machine is described as “doing nothing.”

These are four different accusations.

## Runnable is not running

A runnable thread is eligible to execute. It may be waiting for a scheduler to place it on a processor. A running thread is currently executing on a core. The distinction exists because there are usually more runnable interests than execution slots.

```text
Thread:
I'm ready.

Scheduler:
noted.

Thread:
so I'm running.

Scheduler:
you are on the list.
```

XNU's scheduler chooses among eligible work using policies and state that evolve across releases. This chapter does not claim a stable private algorithm for the author's M4. It needs only the durable model: eligibility and execution are separate, and scheduling decides which runnable thread receives a processor now.

A running thread can be preempted so another may run. Its program has not become blocked; it simply lacks the core for the moment. “The CPU stopped my app” may mean scheduling, a fault, an explicit wait, throttling, or termination. The verb is begging for an object.

Multicore execution adds simultaneous truths. One thread from a process can be blocked while another runs. A process is not a single indivisible occupant of “the CPU,” and a core is not permanently assigned to an application. The scheduler deals in runnable threads, not Dock icons.

Priority influences scheduling within policy; it does not reserve a core as personal property. Quality-of-service classes communicate intent and let the system make decisions. They do not turn “important to me” into a hardware interrupt that evicts all neighbors.

```text
Thread:
high priority.

Scheduler:
considered.

Thread:
immediate throne?

Scheduler:
runnable queue.
```

## Blocked is not idle

Suppose a thread calls `recv` on a blocking socket and no data is available. The operation can wait. The thread is no longer runnable until the required event or another outcome makes progress possible.

```text
Thread:
waiting for packet.

Core:
cool, I'm running somebody else.

User:
the CPU is waiting.

Core:
the CPU has siblings.
```

Blocking is efficient when the alternative is repeatedly checking for an event that has not happened. The scheduler can use the core for other work. If no runnable work remains for a core, the core can become idle under the system's power-management decisions.

Thread blocked and core idle are therefore different states. One blocked thread can coexist with a very busy machine. One idle core can coexist with runnable work constrained elsewhere. A system can also have several cores in different states at once; “the CPU” has become a committee again.

Locks create another wait. A thread blocked on a mutex is waiting for software-owned synchronization state, not a packet. A condition variable wait typically releases a lock while sleeping and requires the condition to be checked again after wake. The kernel can arrange sleep and wake mechanics; the program defines the predicate that makes progress safe.

```text
Thread:
the lock woke me.

Mutex:
I became available.

Condition:
that does not prove your work exists.

Thread:
why does waking require homework
```

## Spinning is an expensive form of patience

A thread can wait by polling a condition in a loop. It remains runnable or running and consumes execution resources while asking whether anything changed.

```text
Thread:
now?

Flag:
no.

Thread:
now?

Flag:
no.

Power Management:
I have notes.
```

Short spins can be useful when an event is expected immediately and sleeping would cost more. Long spins are a heating strategy with synchronization side effects. The right choice depends on duration, contention, and context; the book is not issuing one universal rule.

Hybrid strategies can spin briefly and then block. This is not indecision; it trades the overhead of sleeping against the cost of burning cycles. The optimal boundary depends on workload and platform details the book does not pretend to know.

Waiting while holding a lock can prevent the very work needed to satisfy the condition. Priority inversion can let a high-priority thread wait on work owned by a lower-priority thread. Systems provide mechanisms to mitigate particular cases, but no scheduler can infer an arbitrary application's missing locking design.

```text
Important Thread:
why am I waiting

Lock:
owned by Background Thread.

Background Thread:
not scheduled.

Scheduler:
I see the circular performance review.
```

Spinning also demonstrates why high CPU usage does not prove useful progress. The thread is executing instructions. The application may still be waiting at the semantic level. Activity and accomplishment have separate counters.

## The pipeline is waiting too

Inside a running core, instructions can stall because operands or resources are not ready. A cache miss can require data from farther away. Dependencies can keep later work from proceeding. A branch or execution resource can create other delays.

The scheduler still sees a running thread. The thread has not performed a blocking system call. The core is not idle. Yet part of the pipeline is waiting.

```text
Scheduler:
running.

Thread:
running.

Pipeline:
waiting on memory.

User:
so which is it

Performance counters:
yes.
```

The exact Apple core microarchitecture is not required here, and the chapter does not invent its private pipeline. Modern CPUs overlap work and tolerate some latency; a stall is not necessarily the whole core freezing in place. The useful distinction is the layer: scheduler wait states and microarchitectural stalls are not interchangeable.

## The completion has not arrived

Return to the network read. The remote peer sends a response. A radio or PHY receives signals. A controller reports data. Driver and protocol work make bytes available to the socket. Only then can the blocked operation complete or the thread become eligible to run.

```text
Remote peer:
reply sent.

Network:
in transit.

Controller:
frame received.

Socket:
data available.

Wait queue:
thread may compete again.
```

Waking a thread does not mean it instantly runs. It generally means the condition has changed and the thread can become runnable; scheduling still owns the next placement. When it runs, it must recheck the condition and handle errors, timeouts, closure, or competing consumers according to the interface.

Asynchronous programming rearranges the same boundaries. Instead of blocking one thread, a program registers interest or a completion and lets an event loop process readiness later. The operation still waits somewhere. Removing a sleeping thread from the source code does not remove latency from physics.

```text
Application:
I am nonblocking.

Network:
the packet is still crossing town.

Application:
but I used async.

Network:
congratulations on waiting elsewhere.
```

Backpressure is waiting used as honesty. If a consumer or device cannot accept unlimited work, the producer must slow, buffer within limits, or fail. An unbounded queue does not eliminate waiting; it converts it into memory consumption and a future incident review.

```text
Producer:
I never block.

Queue:
I contain eight million requests.

Memory pressure:
meeting in five.
```

Timeout is another event, not proof that nothing happened. A reply can arrive after the caller gave up. A device operation can complete after cancellation was requested. Protocols and applications need identifiers and lifetime rules so late news does not get delivered to a recycled expectation.

Waiting also has budgets. A user-facing operation may tolerate milliseconds; a background sync may tolerate minutes; a real-time audio path has different constraints. “Fast” is not a scheduler state. It is a deadline attached to somebody's expectation.

```text
User:
it's frozen.

Main thread:
waiting synchronously.

Worker:
making progress.

User:
the window agrees with me.
```

Responsiveness is therefore another jurisdiction. Work can be progressing while the thread responsible for input and drawing is blocked. The kernel may be scheduling efficiently while the application has chosen a terrible place to wait.

Runnable, running, blocked, spinning, idle, and stalled all describe real conditions. None is a synonym for “slow.” The CPU is waiting only after we identify which core, thread, pipeline, operation, or human is doing the waiting.

Next the family will argue about who woke it, even though half of them were never asleep.

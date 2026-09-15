# 29. Please Stop Interrupting Me

Spacetime said `zzz`.

This raises a technical question the metaphysical department was hoping to avoid: what, exactly, would interrupt it?

## Who interrupted Spacetime

Computers call several unrelated disruptions *interrupts*. A device has news. An instruction faults. A process receives a signal. A Mach exception is delivered. A sleeping thread becomes runnable.

Only some of those are hardware interrupts.

```text
XNU:
who interrupted me

Device:
I raised an interrupt.

Process:
I got SIGINT.

Debugger:
I received an exception.

XNU:
one at a time, incorrectly named.
```

The shared theme is control flow changing because an event needs attention. The sources, delivery mechanisms, recipients, and consequences differ.

## The fault came from inside the instruction

A synchronous exception arises because of the instruction being executed: an invalid access, unavailable translation, illegal instruction, system call, or another architecturally defined condition. It is synchronous because the event is tied to that instruction stream.

```text
Instruction:
load from this address.

MMU:
fault.

Instruction:
who interrupted me

MMU:
you brought the problem.
```

The kernel can resolve some faults and resume execution. Others become failures delivered upward or termination. A trap used to enter the kernel deliberately and a fault caused by invalid access can share exception machinery without meaning the same thing.

“The CPU raised an exception” names an architectural event. It does not yet say which software policy will handle it.

## The device has news

A hardware interrupt is asynchronous with respect to the instruction stream it interrupts. A device or timer can signal that an event needs service. Interrupt-controller and kernel machinery route and handle that event according to configured state.

```text
Network controller:
packet arrived.

Core:
I was doing math.

Interrupt controller:
you have mail.

Core:
this family has three incompatible mailboxes.
```

Delivery does not mean the entire operation is finished. Immediate handling is usually kept bounded; later work may be deferred to another context. A driver can process completion, protocol state can change, and a waiter can become runnable afterward.

The exact Apple interrupt-controller topology and routing policy vary by generation and are not invented here. The architectural distinction is sufficient: asynchronous hardware news is not the same event as a fault caused by the current instruction.

Deferred work is where “the interrupt did it” becomes especially misleading. An immediate handler can acknowledge or capture enough state to make the source safe, then arrange later processing outside the most constrained context. That later work may wake a thread or deliver a callback.

```text
Interrupt handler:
noted.

Device:
so the request is complete?

Deferred work:
I just got assigned twelve steps.

Application:
my callback?

Everyone below:
eventually is now a technical term.
```

The book does not prescribe one XNU deferral mechanism for every device. It protects only the boundary between prompt hardware-event handling and work scheduled afterward.

## Mach would like to deliver an exception

Mach exceptions are an operating-system mechanism for reporting exceptional conditions to a configured exception port. Debuggers can use that machinery to observe and control a task. The Mach message is not the original electrical interrupt wearing a nicer jacket.

```text
Hardware exception:
event.

XNU:
translated and classified.

Mach exception:
message for the handler.

Debugger:
now I have jurisdiction.
```

The configured handler and exception type determine what can happen next. Delivery may permit inspection, reply, resumption, or failure under the relevant contract. “Exception” therefore names both architectural and Mach-level concepts that must not be collapsed.

## That is a signal, not an interrupt

Unix signals notify a process or thread under the operating system's signal model. `SIGINT` is traditionally associated with an interactive interrupt character, which has done irreversible damage to terminology.

```text
Terminal:
Ctrl-C.

Kernel:
SIGINT.

Process:
I was interrupted.

Interrupt controller:
leave me out of this.
```

A signal can be generated for many reasons and has dispositions such as handling, ignoring where permitted, or default action. It is not a hardware interrupt routed directly into userspace. The kernel mediates signal state and delivery.

Nor does a signal necessarily launch a service or wake the whole Mac. It may make a blocked thread return or arrange a handler when the task runs. Thread wake, signal delivery, and system wake remain different receipts.

## Which world receives it

The family can now assemble the sequence without pretending it is one event:

```text
Device:
news.

Interrupt machinery:
delivered.

Driver:
state updated.

Wait queue:
thread runnable.

Scheduler:
thread running.

launchd:
I did not launch any of this.
```

Routing owns where hardware news is presented. The kernel owns handling and later software consequences. A wait mechanism owns eligibility. The scheduler owns execution placement. launchd owns service lifecycle. None inherits the others' authority because one event passed through all of them.

Virtualization makes the final question unavoidable. A physical interrupt can belong to the host, be represented to a guest, or cause host work that later produces a virtual event. Which kernel receives which event depends on the execution world and virtualization configuration.

```text
Guest kernel:
I was interrupted.

Host kernel:
by what I presented.

Guest kernel:
so you own my interrupt

Host kernel:
I own the machinery that let your world receive it.
```

That is enough mechanism. The guest may now attend Dinner and explain why even an interrupt needs a jurisdiction.

The seating chart has never been more technically necessary or socially, architecturally, comprehensively doomed tonight.

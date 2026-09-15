# 24. Who Woke Me Up?

At 3:14 a.m., something becomes runnable, a service appears, a timer expires, and the laptop display remains dark.

The family files one incident report titled WAKE.

## Which thing woke

A blocked thread can be awakened when the condition it waits for changes. A driver queue can receive work. A service can be launched on demand. A sleeping Mac can resume because an allowed wake source occurred.

These events can participate in one causal story without being the same event.

```text
Thread:
who woke me

Socket:
data arrived.

launchd:
I started a service.

Mac:
I was already awake.

Everyone:
oh.
```

The first question is always the subject. Was a thread made runnable? Was a dispatch source signaled? Was a service activated? Did a processor leave an idle state? Did the whole system transition from sleep? The noun saves hours of blaming the mouse.

The cause also needs a chain. A network frame may trigger device activity; a driver may process it; socket state may change; a waiter may become runnable. Calling the entire chain “the packet woke the app” is useful shorthand only while nobody mistakes it for one indivisible operation.

```text
Packet:
I woke the thread.

Driver:
I processed completion.

Wait queue:
I changed eligibility.

Scheduler:
I ran it.

Packet:
fine, we woke the thread.
```

## The timer had an appointment

Timers let software request action after a deadline or interval. When a timer expires, the system can mark associated work ready. That does not guarantee the callback executes at the exact mathematical instant: scheduling, coalescing, power policy, and current workload can affect when code runs.

```text
Timer:
appointment at 3:14.

Scheduler:
eligible at 3:14.

Callback:
running at 3:14-ish.

Timer:
I keep time, not staff.
```

Some timers are relevant only while the system is awake. Some power-management features can schedule or permit system wake. The API and policy determine which promise exists. A deadline in an application does not personally command every power domain to resume.

Repeating timers add drift and backlog questions. If the machine or queue cannot run work at one requested moment, an API defines whether invocations coalesce, arrive late, or are skipped. “Every minute” is not a demand that physics create sixty execution slots during a ten-minute sleep.

Timer expiry also differs from an interrupt, even though a hardware timer may contribute to how the event is delivered. The software-facing timer, the hardware event, the routing of that event, and the eventual callback are distinct stages.

## The queue received an answer

An I/O completion can make waiting work actionable. A device or network event is handled, state is updated, and the waiter is notified under the relevant mechanism.

```text
Controller:
operation complete.

Driver:
completion processed.

Wait queue:
thread eligible.

Thread:
I'm awake.

Scheduler:
you are runnable.

Thread:
this family ruins every announcement.
```

The reawakened thread may not run immediately. Another thread can consume the condition first. The operation may have completed with an error. Correct waiting code rechecks its condition instead of treating “woken” as a notarized success result.

Wakeups can also be advisory or spurious under some synchronization contracts. This is why robust waiting is phrased as “sleep while the condition is false,” not “sleep once and trust whoever nudges me.” The predicate belongs to the program; the wake mechanism merely gives it another chance to look.

Dispatch and asynchronous APIs can deliver callbacks rather than restoring a particular blocked thread. The program experiences progress; the scheduler may use an entirely different thread. “My code woke up” is a metaphor wearing a call stack.

Notifications add a further boundary. An observer may be told that state changed without owning the state or the work that changed it. Delivery can be delayed, coalesced, or occur on a specified execution context. Receiving news is not causing the event.

```text
Observer:
I was notified.

State:
I changed earlier.

Observer:
so I woke you.

State:
you opened the email.
```

## launchd heard demand

launchd can start services on demand when configured activation conditions occur. A request arriving at a managed endpoint may cause a service to be launched so it can handle the work.

```text
Client:
hello?

launchd:
one moment.

[service starts]

Service:
who woke me

launchd:
you did not previously exist in this session.
```

Service activation is not thread wake. It creates or starts a process under a service-management contract. Once running, that process contains threads that the kernel schedules. launchd owns the service lifecycle; XNU owns process and thread mechanisms. The incoming demand is the reason, not a tiny remote process reaching through the network to call `exec`.

Activation can also occur for reasons other than network traffic: configured IPC demand, timers, watched resources, or other service conditions. Exact keys and private behavior vary. The stable lesson is that launchd can hold the service contract while the service is absent, then arrange execution when demand becomes actionable.

Nor does every incoming packet launch a daemon. Existing services receive traffic, packet filters discard it, stacks reject it, and activation policies differ. The example establishes a kind of jurisdiction, not a universal launch trigger.

## The whole machine was asleep, approximately

System sleep is itself a family of power states and policies, not a single universal condition shared identically by every component. Apple documents wake sources and scheduled wake behavior for Mac, while hardware and firmware coordinate power state.

The sentence “the Mac was asleep” is useful at the user level. It does not mean every transistor was unpowered, every controller forgot its state, or launchd continued ordinary execution in a dark room waiting to hear the keyboard.

```text
User:
who woke the Mac

Keyboard:
maybe me.

Network:
policy permitting, maybe me.

Power Management:
I have a wake reason.

launchd:
was I conscious for this meeting
```

A wake source becoming active passes through hardware, firmware, and operating-system policy before the user sees a resumed display. The exact sequence varies by model and sleep mode. “Power Management” remains the book's ensemble character, not one documented universal daemon or controller.

A recorded wake reason is evidence about that transition under the platform's reporting vocabulary. It does not necessarily narrate every contributing event, and a nearby event is not automatically the cause. Logs are witnesses with schemas, not omniscient novelists.

After system resume, timers may be processed, network state may recover, services may run, and threads may become runnable. Their activity follows the system transition; it is not proof that each one individually caused it.

The display waking is another visible but separate outcome. A system can perform background work without presenting a fully interactive session, and a display can turn off while the computer remains awake. User-visible darkness is not a hardware power-state register.

```text
Mail client:
I woke the computer.

Wake reason:
lid open.

Mail client:
I was there when it happened.

Wake reason:
so was the wallpaper.
```

The family now has at least five legitimate meanings of wake: a wait condition changed, a timer expired, a callback became pending, a service was activated, or the machine resumed from sleep. Processor idle-state transitions add still more precision when needed.

Sleep and wake also carry security policy. A resumed machine may still require authentication before restoring access to a user session. Power state does not silently authenticate the person who opened the lid, and an unlocked display is not the definition of a running kernel.

```text
Mac:
awake.

loginwindow:
authenticate.

User:
but I performed the lid gesture.

loginwindow:
that proves excellent hinge access.
```

An event becoming actionable is not yet a lesson in interrupt routing. Hardware exceptions, interrupts, Mach exceptions, Unix signals, and deferred work will get their own final argument later—before Dinner, because the whole family should know why it was summoned properly.

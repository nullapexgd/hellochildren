# 12. At the Mercy of the Kernel

Every operating-system book loves boot. Arrows point downward. Trust accumulates. The desktop appears. The diagram ends with *user session established* as if nobody will ever click Shut Down while fourteen apps negotiate unsaved documents.

Shutdown is where the family has to leave the wedding venue.

## Children, go to bed

The user makes a request through the graphical system.

```text
User:
shut down.

Application:
save changes?

User:
yes.

Application:
which changes

User:
the ones I just—

Application:
beachball.
```

Shutdown coordinates userspace and kernel work. We do not reconstruct a private sequence from one string. Applications may terminate, services and domains come down, storage and devices reach safe states, and eventually the machine stops executing macOS.

launchd turns to the population.

```text
launchd:
children go to bed.

sharingd:
I am in the middle of sharing something.

launchd:
with whom

sharingd:
several protected subsystems.

launchd:
finish the sentence and the transfer.
```

WindowServer lowers the curtains. `loginwindow` closes the session ledger. Agents disappear with their user contexts. Daemons receive the news according to the system’s shutdown machinery.

Fake launchd hides behind a property list.

```text
launchd:
children go to bed.

fake launchd:
do I have to

launchd:
YOU DON'T EVEN LIVE HERE.
```

## The problem with asking politely

Graceful shutdown is an attempt to preserve state, finish work, and relinquish resources cleanly. Grace is useful precisely because the kernel retains alternatives.

```text
launchd:
please terminate.

Service:
one moment.

launchd:
please terminate.

Service:
draining queue.

launchd:
the queue has been draining since Sonoma.
```

Some processes cooperate. Others interpret “termination handler” as a venue for a second career.

Then comes the launchd string around which this entire ending was built:

> **“Any processes that are still running will be abandoned to the mercy of the kernel.”**

We went looking for that sentence in `/sbin/launchd` and found it, with one wonderfully annoying wrinkle. A plain exact-string search missed it because the binary split the sentence into two adjacent pieces:

> `(or halting) the system now. Any processes that are still running`
>
> `will be abandoned to the mercy of the kernel.`

Read together, there it is. The fictional exchange around it is still not Apple's documented private shutdown sequence.

The string does not need help.

It is a complete short story.

## Mercy

```text
Process:
I require additional time.

launchd:
I have provided time.

Process:
my cleanup invariant—

launchd:
you are now at the mercy of the kernel.

Process:
does the kernel have mercy

launchd:
that is why the sentence works.
```

XNU has spent the book resenting every authority that qualified its title. At shutdown, userspace returns to the one fact nobody disputed: the kernel controls whether ordinary processes continue executing in its world.

The graphical session can govern windows. The service manager can coordinate jobs. The sharing daemon can carry 132 badges today. None is a defense against final kernel teardown.

```text
sharingd:
I know people.

XNU:
not running people.

amfid:
signature?

XNU:
not relevant.

amfid:
finally.
```

## Hardware closes the building

Userspace ending is not hardware instantly ceasing to exist. Storage preserves writes, devices quiesce, display output ends, and platform power machinery completes the operation.

The family dramatizes this without pretending the following is a literal undocumented call trace:

```text
WindowServer:
last frame.

GPU:
rendered.

Display Controller:
scanned out.

Storage Controller:
writes settled.

DART:
mappings closed.

SEP:
state secured.

Memory Controller:
good night.
```

Application Processor looks at XNU.

```text
Application Processor:
everybody gone?

XNU:
userspace is gone.

Application Processor:
and you?

XNU:
I am literally the kernel.

Application Processor:
that wasn't the question.
```

## The final authority in this world

The computer powers down.

For one brief scene, XNU received the ending it wanted. Services stopped. Processes disappeared. Userspace civilization was dismantled. There was no graphical official left to dispute pixels, no service manager left to organize children, and no fake launchd left to cite UID 2.

XNU had the whole normal execution world to itself.

It lasted less than a second.

Then the hardware stopped running XNU.

```text
XNU:
:)

Application Processor:
good night
```

Even the mercy of the kernel has a jurisdiction.

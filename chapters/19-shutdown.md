# 19. At the Mercy of the Kernel

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

The graphical session can govern windows. The service manager can coordinate jobs. The sharing daemon can carry 134 badges on this build. None is a defense against final kernel teardown.

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

## Revocation is not destruction

Several chapters used the word *revoke*. TCC can revoke approval. A service can stop accepting an entitlement. A mapping can disappear. A session can end.

None of those acts is identical to destroying the process that once held the access.

```text
TCC:
microphone approval revoked.

App:
I still exist.

launchd:
not for long.

App:
those are different threats.

TCC:
finally, someone read the book.
```

Shutdown collects many narrower endings. The graphical session ends as a session. Services are asked to stop as services. Filesystems move toward a state safe to leave mounted no longer. Device mappings close. Processes lose execution because the kernel stops maintaining their world.

```text
Snapshot:
I preserve a filesystem state.

Process:
preserve me.

Snapshot:
you are not a filesystem state.

Process:
I have files.

Snapshot:
everyone has a résumé tonight.
```

The machine does not need one universal verb called `endEverything()`. It needs each authority to close the object it actually governs, followed by stronger machinery for anything that refuses to finish.

## Exit status: civilization

Processes spend their lives returning small integers to parents. Shutdown asks an entire userspace to produce one coherent answer.

```text
Application:
exit status 0.

launchd:
good.

Service:
exit status 0.

launchd:
good.

sharingd:
I have 134 partial statuses
across several protected subsystems.

launchd:
you had one job.

sharingd:
that has never been true.
```

A clean process exit says something about that process. It does not certify that every related write reached durable storage, every peer learned the transfer ended, or every device finished its own shutdown work. Those results belong to other objects and other authorities.

The user asked for one event: off. The machine performs a sequence because hardware cannot safely interpret vibes.

```text
User:
is it off yet

WindowServer:
the screen is black.

Storage Controller:
that was not the question.
```

This is why a black display can arrive before the final hardware act. Darkness is graphical evidence. It is not a power-state affidavit.

XNU attempts one final hardware flex, with the inventory from the author's machine.

```text
XNU:
I HAVE TEN CPU CORES.

SEP:
correct.

XNU:
you don't.

SEP:
correct.

XNU:
therefore I win.

SEP:
turn them off then.

XNU:
STOP FUCKING SAYING THAT.
```

The ten-core count belongs to this observed 10-core M4 Mac—four performance cores and six efficiency cores—not every Mac or every configuration sold under the M4 name.

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

Then XNU wins the argument in the only way that prevents it from enjoying the victory.

```text
XNU:
fine.

XNU:
P-cores offline.

P-cores:
bye.

XNU:
E-cores offline.

E-cores:
bye.

XNU:
HAHA.

XNU:
NOW WHO EXECUTES YOUR CO—
```

```text
[Application Processor execution ceased]

SEP:
...

SEP:
bro really turned himself off
```

The card is intentional compression, not a documented Apple shutdown sequence. Ordinary core idling or offlining, system sleep, and a coordinated shutdown are different operations; the scene collapses them into one total-AP punchline. It also does not claim that SEP necessarily remains conversationally active after the exact real-world event being dramatized.

## The final authority in this world

The computer powers down.

For one brief scene, XNU received the ending it wanted. Services stopped. Processes disappeared. Userspace civilization was dismantled. There was no graphical official left to dispute pixels, no service manager left to organize children, and no fake launchd left to cite UID 2.

XNU had the whole normal execution world to itself.

It lasted less than a second.

Then the hardware stopped running XNU. Authority to terminate execution did not make the kernel the government of every world that depended on that execution, or teach it what those worlds meant.

Privilege can end a world without understanding it. That is power, not government. Apple and modern politics still argue about who invented this.

Even the mercy of the kernel has a jurisdiction.

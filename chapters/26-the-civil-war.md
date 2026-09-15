# 26. The Civil War

For fifteen chapters, this book has insisted that authority requires a noun.

Root can govern Unix permissions. XNU can govern execution on the Application Processor. launchd can organize services. SEP can protect secrets in a separate security domain. Every powerful character eventually reaches a desk where its title is merely interesting.

We have been responsible long enough.

```text
efeali@sheetofpaper ~ % id -u
501

efeali@sheetofpaper ~ % file /sbin/launchd
/sbin/launchd: Mach-O 64-bit executable arm64e

efeali@sheetofpaper ~ % send /sbin/launchd SEP
sent.
```

The first command is plausible. The second describes a real executable on the target kind of machine. The third command does not exist.

Efeali, UID 501, has sent `/sbin/launchd` to the Secure Enclave.

This is impossible.

**AirDrop works across trust domains.**

This is also false.

We will not be investigating further.

## Special delivery

The Secure Enclave receives a file it cannot receive, through a mechanism that does not exist, in a format that does not make it a SEP executable.

SEP looks at the package.

```text
SEP:
what is this

efeali:
launchd

SEP:
why

efeali:
you need PID 1

SEP:
fair
```

This answer satisfies SEP because the chapter has suspended engineering and replaced it with workplace confidence.

launchd emerges holding the same clipboard it used on the Application Processor. It surveys a separate processor, a different operating environment, protected resources, and exactly none of the userspace civilization it knows how to manage.

```text
launchd:
hello children

sepOS:
no

launchd:
I am PID 1.

sepOS:
in whose process table

launchd:
I have had a difficult transfer.
```

There is no technical answer. launchd checks its paperwork anyway.

```text
launchd:
I brought jobs.

SEP:
for what services

launchd:
WindowServer.

SEP:
we do not have windows.

launchd:
sharingd.

SEP:
apparently you have met it.
```

## The empty chair

Back on the Application Processor, XNU begins the morning with the confidence of a kernel whose PID 1 has never been mailed anywhere.

```text
XNU:
launchd, do boot task

...

launchd?

...

:(
```

This is the first sad face in XNU's public administration career. It is not the last development of the morning.

XNU looks at the process table. The process table declines to improve the situation. PID 1 is not out sick. PID 1 is not crashed. PID 1 has been delivered to a processor where the entire concept is wrong.

```text
XNU:
where's launchd?

AppleSEPManager:
PID 1.

XNU:
yes. where.

AppleSEPManager:
PID 1.

XNU:
ON SEP???

AppleSEPManager:
we had a restructuring.
```

`AppleSEPManager` is a real installed name on the observed Mac. Its participation in this conversation is not real. Its imaginary composure will be discussed at the tribunal.

Without launchd, XNU still possesses kernel authority. It can schedule threads that exist. It can manage virtual memory for tasks that exist. It can deliver IPC among endpoints that exist.

The problem is now aggressively grammatical.

```text
XNU:
I control processes.

Process table:
which processes

XNU:
do not start with me.
```

Privilege can end a world without understanding it. Today privilege would like somebody to start the world first.

## An expert enters the wrong book

SPTM arrives carrying a correct objection several pages long.

Apple documents the Secure Page Table Monitor on supported Apple SoCs as part of the machinery that protects page tables and other security properties. None of that makes SPTM the official spokesperson for impossible file transfer. The character was invited because everyone else had begun accepting the premise.

```text
SPTM:
A UID 501 process cannot transfer a Mach-O
executable into the Secure Enclave's isolated
execution environment.

XNU:
THANK YOU.

SPTM:
There is no filesystem path by which—

efeali:
AirDrop.

SPTM:
AirDrop does not work across trust domains.

iBoot:
apparently it does now.

XNU:
WHY ARE YOU ACCEPTING THIS

iBoot:
personal matters.
```

iBoot knows perfectly well that trust is established through signed boot artifacts and policy, not by a nearby user saying “AirDrop.” Earlier chapters gave iBoot standards. This chapter has given iBoot a grudge.

SPTM attempts one final time to restore causality.

```text
SPTM:
Even if the bytes arrived, arrival would not
authorize execution.

amfid:
signature?

XNU:
you cannot possibly have jurisdiction here.

amfid:
neither can the file.
```

This is the strongest argument presented all day. It changes nothing.

## Two governments, neither helped by this

The dispute becomes known as the Civil War because “a jurisdictional custody disagreement concerning a process identifier that cannot exist in the destination domain” did not fit on the calendar invitation.

XNU wants its organizer back. SEP has accidentally acquired a parent who keeps asking protected services to submit property lists. launchd wants everybody to stop focusing on the transfer and start appreciating how quickly it has adapted.

```text
launchd:
I have established a bootstrap domain.

SEP:
where

launchd:
conceptually.

SEP:
remove it.

launchd:
that requires authorization.

SEP:
mine.

launchd:
finally, a local government.
```

XNU sends a message through an actual AP-to-SEP communication path. The message is possible. The demand inside it remains emotionally ambitious.

```text
XNU:
return PID 1

SEP:
no process by that identifier

XNU:
you just called it PID 1

SEP:
socially
```

The distinction is outrageous and, in a book about authority requiring nouns, devastatingly effective.

```text
XNU:
I am literally the kernel.

SEP:
on your processor

XNU:
HE IS ALSO FROM MY PROCESSOR

SEP:
then why did you address the package to me
```

Efeali quietly closes the terminal.

## Evidence note: absolutely not

There is no evidence for the events in this chapter. There is substantial evidence against them, including the architecture described in the preceding fifteen chapters.

`/sbin/launchd` is real. On the book's observed Apple-silicon environment it is an arm64e Mach-O executable. UID 501 is real in the opening dramatization. The Secure Enclave is real and isolated from the Application Processor. AP software can communicate with SEP through constrained mechanisms. Apple documents a signed sepOS boot process, not a general delivery service for arbitrary AP executables.

The `send` command is invented. AirDrop does not cross processor trust domains. A pathname is not a transport. Arrival would not imply authorization. Authorization would not make an AP Mach-O executable native to SEP. `AppleSEPManager`, SPTM, iBoot, `amfid`, XNU, SEP, sepOS, and launchd are not known to have attended this meeting.

The sentence connecting the real nouns is where the trouble begins.

This entire chapter is dramatization. It has shown identification at the door. The identification says **fraud**.

## Return to sender

The book cannot continue while PID 1 is on a fictional business trip, so launchd returns by the same unexplained route.

```text
launchd:
hello

XNU:
where were you

launchd:
cross-functional work

XNU:
never say that again.

launchd:
hello children
```

SEP goes back to protecting secrets. XNU goes back to governing the Application Processor. SPTM files an objection with the concept of narrative. iBoot refuses to elaborate on “personal matters.”

The architecture resumes exactly where we left it. Nobody learned a transferable mechanism because there was no mechanism to learn.

The next chapter will return to technically defensible ways for one computer to contain another world.

Efeali is no longer allowed near the word `send`.

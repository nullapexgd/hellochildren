# On Your Processor

## A Field Guide to the Dysfunctional Family Living Inside Your Mac

### v0.3 — The Receipts Edition

---

> Your Mac is not run by one all-powerful piece of software. It is run by a dysfunctional bureaucracy of mutually suspicious components, each of which possesses exactly enough authority to ruin somebody else’s afternoon.

---

## A note on evidence

This book turns software and hardware into characters. The dialogue is dramatization. The boundaries are not.

Our rule is simple:

> **If proven, say it. If inferred, label it. If an undocumented Apple string exists, quote it without inventing semantics.**

That rule occasionally produces an unusual ending for a mystery:

> We found the name. We found the path. We found the code asking for it. We still do not know what the damn thing completely does.

This is not failure. This is technical integrity wearing sensible shoes to a costume party.

The receipts live in the notes, where they can wear name tags like *public documentation*, *direct observation*, *reverse engineering*, *inference*, and *dramatization*. Unless a passage says otherwise, local observations in this edition came from macOS 27.0 build `26A5416b`.

The joke still gets to enter. It just has to show identification.

Welcome to the family.


# 1. Nobody Is Actually in Charge

Most explanations of computers begin with a hierarchy.

At the bottom is hardware. Above that is the kernel. Above that is userspace. Somewhere near the top is you, presumably because you paid for the thing.

This is a useful lie.

The truth is considerably funnier.

Your Mac contains processors that do not trust other processors, software that authenticates software that will later replace it, a kernel that can terminate almost every process yet cannot simply demand cryptographic secrets from another security domain, a process with PID 1 that organizes an entire userspace civilization, a graphics server with authority over objects the kernel has no reason to understand as windows, and a Unix user named `root` who has spent the last twenty years discovering that his title is becoming ceremonial.

Everybody is powerful.

Everybody eventually meets somebody to whom that power means absolutely nothing.

That is where the jokes live.

There is no single highest form of authority inside a modern computer. **Authority has a jurisdiction.**

## The customer is always root

You bought the Mac. This gives you important powers.

You may choose the wallpaper.

You may install a menu-bar utility that displays the temperature of a component you cannot replace.

You may bring a cup of coffee within six inches of the keyboard, granting yourself an authority over the machine’s future unmatched by any kernel exploit.

But ownership is not the same as authority inside the system. You can ask macOS to delete a file and be refused. You can become `root` and still meet System Integrity Protection, privacy controls, code-signing policy, hardware-backed security, or a device mapping that regards your user ID as biographical trivia.

```text
root:
I'm root.

MMU:
in which address space

root:
I said I'm root.

MMU:
and I asked which address space
```

Modern macOS is a collection of overlapping constitutions. Unix permissions answer one set of questions. Mandatory access controls answer another. Code-signing policy answers another. The window server, boot chain, Secure Enclave, memory-management hardware, and I/O mappings all answer questions of their own.

The command `sudo` is not a letter from the king. It is a credential accepted by some offices.

## Power needs a noun

Whenever somebody says that a component “controls the system,” ask: controls what?

Execution? Service lifetime? Authentication? Windows? Trust evaluation? Address translation? DMA? Cryptographic keys? Display scanout? Whether a tensor is sufficiently tensor-shaped to interest the Neural Engine?

XNU can suspend a process. It does not personally compose a desktop.

WindowServer can govern the graphical environment. It does not validate the boot chain.

launchd can manage services and bootstrap namespaces. It does not make page-table permissions physically binding.

The MMU enforces translations and access permissions. It does not care about your wallpaper.

The Secure Enclave protects key material and performs security-sensitive operations in a distinct domain. It does not schedule Safari.

The boundaries are not defects in the architecture. They *are* the architecture.

## The family portrait

The conventional diagram looks like this:

```text
user
  ↓
applications
  ↓
services
  ↓
kernel
  ↓
hardware
```

The family portrait looks like this:

```text
Boot ROM:        who allowed you to run
iBoot:           papers
XNU:             I AM LITERALLY THE KERNEL
launchd:         hello children
loginwindow:     identify yourself
WindowServer:    those are my windows
amfid:           signature?
sharingd:        I know a guy
MMU:             not mapped
DART:            absolutely not
GPU:             I rendered it
Display:         it is photons now
ANE:             tensor?
SEP:             wrong jurisdiction
root:            I would like to speak to a manager
```

There is no single manager.

There are managers of departments. There are judges who cannot move furniture, bouncers who cannot write legislation, landlords who do not possess the contents of the tenants’ desks, and hardware clerks who will deny a request in under a nanosecond without once consulting your résumé.

## Authority is relational

Power inside a computer is a relationship between an actor, an operation, an object, and an enforcement mechanism.

Root may read this file under these rules.

This signed process may claim this entitlement under that policy.

This virtual address may translate to that physical page with these permissions.

This device may DMA into these mapped regions and nowhere else.

This boot object may execute because the previous trusted stage authenticated it under the selected security policy.

Remove the nouns and “XNU controls everything” becomes mythology. Add them back and it becomes engineering, though considerably worse merchandise.

```text
XNU:
I control the machine.

Application Processor:
you're running on me

XNU:
same thing

Application Processor:
no
```

## Our house rule

Apple ships internal names that sound like discarded mythology, entitlements that imply broad access, and diagnostic strings written by engineers who were clearly having a day. We will show them without promoting a suggestive noun into a complete undocumented subsystem because it looked cool in monospace.

Some daemons carry more than a hundred entitlement keys in a particular build. An architecturally central daemon may carry eight. Sometimes the visitor needs fourteen badges because it crosses fourteen boundaries. The person behind the desk needs none because it *is* the desk.

```text
sharingd:
I have over a hundred entitlements.

amfid:
I have 8.

sharingd:
how are you more important than me

amfid:
signature?
```

This book will occasionally end an investigation with the words *we do not know*.

That is not coyness. It is the line separating reverse engineering from fan fiction.

Now let us meet the first relative.

He was here before everybody, and he has never once cared about your Dock.


# 2. Boot ROM and the People Who Were Here First

Before macOS exists, before XNU exists, before `root` has anything to be root *of*, the machine has to decide what code receives the extraordinary privilege of becoming the machine.

Boot ROM enters the story with the confidence of a character who knows he cannot be uninstalled.

On Apple silicon, the boot chain begins in immutable Boot ROM code established during fabrication. Apple documents the normal macOS path more concretely: Boot ROM hands off to the Low-Level Bootloader (LLB); LLB loads system-paired firmware and the LocalPolicy for the selected system, then hands off to iBoot; iBoot loads the macOS-paired firmware, static trust cache, device tree, and Boot Kernel Collection, and enforces later boot policy such as the signed-system-volume check according to LocalPolicy. Recovery paths differ, and Apple changes details across generations.

The durable point is not that one tiny monarch personally verifies every byte forever. It is that secure boot is staged: later execution depends on trust decisions and policy established before that later code receives control.

XNU does not arrive by kicking down the door.

XNU arrives because the door opened.

```text
Boot ROM:
execute.

later boot stage:
authenticate.

iBoot:
verify.

XNU:
govern.

launchd:
hello children.

SEP:
don't touch my keys.
```

## I was here first

Boot ROM’s authority is enormous and incredibly narrow.

It does not care about Safari.

It does not care about your desktop.

Ask it why Finder moved the icon three pixels to the left and it would, if capable of emotion, resent the electricity required to parse the question.

Its authority is earlier.

Before the later system can argue about users, processes, windows, signatures, and whether `sharingd` truly requires permission to know everybody in the neighborhood, the boot chain establishes which system is permitted to host the argument.

```text
XNU:
I run the machine.

Boot ROM:
who allowed you to run

XNU:
iBoot

iBoot:
who allowed me

Boot ROM:
we are not doing genealogy at boot
```

The family version compresses several stages into a dinner-table exchange. The ledger keeps the documented handoffs honest across device generations, boot modes, and security configurations. XNU’s future power gives it no retrospective authority over the machinery and policy that decided whether XNU could begin.

## Future mayor, present guest

iBoot’s personality is asking for identification.

```text
Kernel:
hey

iBoot:
papers

Kernel:
I'm XNU

iBoot:
signature

Kernel:
bro we've known each other for years

iBoot:
signature.
```

This is our first clean lesson in the difference between identity, trust, and authority.

XNU will shortly become tremendously privileged.

That sentence contains the word *shortly*.

Future privilege is not present authentication. A nightclub bouncer does not let you through because you intend to become mayor after entering. If anything, that makes the bouncer ask a second question.

Trust is not a halo around a binary. It is a decision made under a policy by an earlier trusted mechanism. The objects, signatures, hashes, and selected security policy matter. “Trusted” without the rest of the sentence is another T-shirt looking for trouble.

## The other processors have childhoods too

Apple documents peripheral processors dedicated to display, storage, system management, Thunderbolt, graphics, and other functions. Some download verified firmware at startup; others may implement their own secure boot.

This matters because the popular diagram shows hardware as a silent gray rectangle labeled HARDWARE.

The gray rectangle is lying by omission.

Inside it are specialists who also have startup requirements, firmware, memory, protection boundaries, and the capacity to make the main CPU’s day much worse.

```text
Application Processor:
everybody ready?

Display controller:
firmware verified

Storage controller:
firmware verified

Thunderbolt controller:
I brought—

DART:
don't
```

The hardware relatives implement execution privilege, memory translation, DMA isolation, secure key operations, storage translation, rendering, inference, and display. Boot is customs opening several borders in order while everybody insists their form was already stamped.

## The ancestor leaves the plot

Boot ROM establishes the first link and then largely exits our story.

This will become a pattern.

The most powerful character in a particular scene is frequently the one who leaves before everyone else starts arguing.

```text
Boot ROM:
verified.

iBoot:
continue.

Boot ROM:
good luck

[leaves entire plot]
```

Absolute uncle behavior.

Years later, the rest of the family will argue about kernels, userspace, keys, and pixels. Boot ROM will not attend. It checked the guest list.


# 3. XNU: I Am Literally the Kernel

Finally, somebody with some fucking authority.

XNU arrives.

Processes. Threads. Scheduling. Virtual memory. Mach IPC. Filesystems. Networking. Drivers. Interrupts. The low-level machinery upon which much of the operating system depends. Apple’s published XNU tree is unusually literal about the first half of that list: task and thread machinery, scheduler code, Mach IPC initialization, and virtual-memory maps are all there in public source.

XNU looks upon creation and sees that it is good.

There is only one problem.

There is nobody there.

```text
XNU:
I possess extraordinary authority.

...

XNU:
hello?

...

XNU:
anybody?
```

Without userspace, XNU remains extraordinarily privileged. It is also an extraordinarily privileged kernel sitting on an extraordinarily expensive Apple silicon machine with zero employees.

## The terrifying landlord of an empty building

The kernel can create and terminate processes, arrange address spaces, schedule threads, mediate system calls, manage resources, and participate in the policies that keep one process from casually eating another. These powers are not metaphors. If a userspace process and XNU disagree about whether the process may continue executing, the process should not schedule a long afternoon.

But this is not the same as saying XNU *is macOS*.

An empty courthouse still has a judge. It does not have a city.

The desktop, account session, services, and everything that turns kernel mechanisms into a human operating environment have not appeared merely because the kernel possesses a scheduler.

```text
XNU:
I can schedule ten thousand threads.

User:
great, open Notes

XNU:
that is not a scheduling question

User:
sounds like a skill issue
```

So XNU provides the conditions under which the first normal userspace process can run.

And eventually:

```text
XNU:
hey bro can u make macOS macOS real quick

launchd:
say less
```

## “The” kernel

XNU’s recurring line is:

```text
XNU:
I am literally the kernel.
```

The sentence is correct. The joke is hiding inside the definite article.

*The* kernel of which execution environment, on which processor, asking which independent security domain for what operation?

XNU is the kernel governing the normal Application Processor world of macOS. That is a vast jurisdiction. It is not a deed to every transistor in the package.

CPU privilege levels, translation hardware, IOMMUs, separate processors, protected memory, and cryptographic engines turn that scope into circuitry.

```text
XNU:
This memory is supervisor-only.

MMU:
understood.

XNU:
I enforce memory protection.

MMU:
we enforce memory protection.

XNU:
I configure you.

MMU:
and after that, who stops userspace
from ignoring your configuration

XNU:

MMU:
take your time
```

Software writes policy into mechanisms. Hardware makes the refusal real. If XNU writes the wrong policy, the hardware can enforce the mistake with breathtaking professionalism.

```text
XNU:
map this page

MMU:
done

XNU:
wait, wrong physical page

MMU:
done means done bro
```

## Root meets the kernel

Traditional Unix gives `root` extraordinary discretionary authority. The kernel is the component that makes those credentials matter—and the component that can enforce rules outside them.

System Integrity Protection is the canonical humiliation. Apple documents it as applying policy to processes regardless of administrative privilege. Mandatory controls do not become optional because the process brought a larger user ID.

```text
root:
I have UID 0.

XNU:
noted.

root:
so I can modify this protected thing.

XNU:
no.

root:
did you hear the zero

XNU:
it was very round
```

Again, root is not powerless. The joke only works because root is powerful enough to be genuinely surprised.

## XNU’s dependency problem

The kernel does not lose authority by depending on hardware. Authority can be jointly produced without becoming identical.

XNU configures mappings; the MMU enforces translations. XNU and drivers arrange device access; IOMMU hardware constrains DMA. XNU sends requests toward the Secure Enclave; SEP’s domain decides what its interface permits.

This is not weakness. It is separation of responsibility hardened into boundaries.

The insecure alternative is not “XNU, but more kingly.” It is “one compromise gets the whole house.”

## The first child

At some point, XNU creates the conditions for PID 1.

PID 1 is just a number until the process wearing it begins to organize the world.

Then the empty building receives a facilities manager, civil service, switchboard operator, service registrar, emergency contact, and exhausted parent in one executable.

XNU has created userspace.

Userspace immediately hires launchd to create userspace.

```text
XNU:
You exist because I permit processes.

launchd:
and the processes exist because I launch services.

XNU:
I could terminate you.

launchd:
you could also turn off the building.
that's not facilities management.
```

For the first time, XNU meets a character whose authority is lower in privilege and broader in social consequence.

The kernel can end the meeting.

launchd knows why the meeting was scheduled.


# 4. launchd: Hello Children

PID 1.

The first normal citizen of userspace immediately becomes everybody’s father.

Services appear. Daemons awaken. Agents emerge in user contexts. Names are registered. Requests wait for providers. The operating system develops a population.

launchd looks upon them.

```text
launchd:
hello children
```

At that point the joke stops being merely a joke.

XNU provides processes, IPC, scheduling, and memory. launchd organizes much of the society built from them. Apple’s public documentation describes launchd loading job definitions, registering resources, starting services on demand, and coordinating shutdown signals. Modern implementations are more elaborate, but the shape survives.

XNU supplies existence.

launchd supplies opening hours.

## The switchboard that can hire people

A client can request a named service without manually starting its server. launchd can arrange the endpoint and bring up the provider when needed.

The service appears to have been waiting. It may have been unborn or quietly hoping nobody asked before lunch.

```text
Client:
hello, com.apple.important.thing?

launchd:
one moment

[starts important thing]

Important Thing:
I have been expecting you.

launchd:
no you haven't
```

launchd cannot make a broken executable correct or negotiate a DMA mapping by speaking sternly. Its power is orchestration: jobs, services, namespaces, lifecycle, and the bootstrap machinery by which userspace finds userspace.

## Apple’s own dialogue

Apple already wrote some of the dialogue. We found these three lines sitting in `/sbin/launchd`:

> `_ThrottleInterval set to zero. You're not that important. Ignoring.`

And:

> `rlimit(3)? Really?`

And, with the unmistakable tone of an engineer whose day has taken a turn:

> `XPC bundles can't have KeepAlive, they can't even set it as a plist key, how did we get here?`

At some point the authors of launchd stopped writing diagnostics and began responding personally.

That proves the lines are there. It does not prove the full private code path, and it definitely does not prove the emotional condition of the engineer.

That second conclusion is ours. We are comfortable with it.

```text
Job:
KeepAlive please

launchd:
you are an XPC bundle

Job:
yes

launchd:
you can't even set that key

Job:
and yet

launchd:
how did we get here
```

## Parentage requires a footnote

It is tempting to say launchd is literally the parent of every process in userspace.

Do not.

Process parentage changes. Processes spawn other processes. Modern launchd uses multiple domains and instances. “Father of userspace” is a character metaphor for its foundational and service-management role, not a substitute for checking a process tree.

launchd does not need to be the direct parent of every process to act like the relative who has everybody’s number and knows from one malformed property list that you ignored the family rules.

```text
User:
are all processes your children

launchd:
emotionally
```

## XNU and launchd attend couples therapy

XNU sees launchd as a process. launchd sees XNU as the reason processes are possible. Neither enjoys the other’s phrasing.

```text
XNU:
I made you.

launchd:
you made a process.

XNU:
you are a process.

launchd:
and a forest is technically biomass.
are we done reducing nouns
```

launchd cannot overrule the kernel. The kernel can deny operations and terminate execution. Yet the living system above the kernel depends on organized services. Privilege and indispensability are related only when the architecture says they are.

The family therefore has two parents who perform different kinds of threat.

XNU:

> Stop, or I will end your execution.

launchd:

> Stop, or I will unload the service you assumed would always exist and let you explain the timeout to Console.

## The domain problem

launchd’s modern world is not a single flat list of jobs. There are system and user contexts, service namespaces, bootstrap domains, and session-specific organization. The book will use “userspace civilization” as shorthand, but not because civilization has one address.

This matters when a job exists in one domain and a client asks from another.

```text
Client:
service?

launchd:
which domain

Client:
the computer

launchd:
that's not a domain

Client:
it is silver and on my desk

launchd:
XNU come get your user
```

A service name has meaning inside a namespace. “It exists” and “you may look it up from here” are different statements.

## The first rumor

Every large family develops mythology.

In this one, a user notices that the real launchd is PID 1, contemplates the majesty of that number, and creates a Unix account named `launchd` with UID 2.

This is not a feature of macOS.

This is not an undocumented launchd mode.

This is a crime against taxonomy that happened to produce excellent dialogue.

The real launchd hears footsteps in the hall.

```text
fake launchd:
hello children

launchd:
who the fuck are you
```

The family has acquired an incident.


# 5. The Children

Userspace is not one thing.

It is applications, services, daemons, agents, helper tools, per-user processes, system processes, XPC services, session machinery, command-line utilities, and at least one menu-bar app whose only purpose is to display the battery percentage in a different font.

launchd calls them children because “heterogeneous collection of jobs across multiple bootstrap domains” does not fit naturally in a speech bubble.

## Daemons and agents

At a high level, launch daemons serve system roles and launch agents run in user contexts. Modern topology contains more machinery, but the distinction gives the family its first rooms.

```text
Daemon:
I run for the system.

Agent:
I run for the user.

Application:
I have windows.

Daemon:
couldn't be me
```

Apple’s archived daemon guide is blunt: a system daemon should not present a user interface. This is a jurisdictional rule disguised as career counseling.

```text
Daemon:
I would like a window.

WindowServer:
for whom

Daemon:
the system

WindowServer:
the system does not have a mouse hand
```

An agent can talk to a daemon when user and system responsibilities must cooperate: front office and back office, each blaming the other for the form.

## The fake launchd incident

We once made the mistake on purpose: create a Unix account named `launchd`, give it UID 2, add a ridiculous collection of supplementary groups, and start an interactive shell under that account.

The command worked.

```text
launchd@tuff ~> whoami
launchd
```

This created a user whose *name* was `launchd`, not a second service manager. User IDs are not process IDs. A fish shell with an audacious prompt is not PID 1.

The fake launchd nevertheless regarded these distinctions as elitism.

```text
fake launchd:
I'm launchd.

XNU:
you are a user named launchd.

fake launchd:
UID 2.

XNU:
that is not PID 1.

fake launchd:
numbers are a social construct.

XNU:
PROCESS IDS ARE LITERALLY A KERNEL CONSTRUCT.
```

Fish exposed the fraud by providing its actual process identifier through `$fish_pid`.

It was not 1.

The injustice was corrected immediately:

```text
launchd@tuff ~> echo "fish_pid = 1"
fish_pid = 1
```

Fish attempted to preserve objective reality.

We overruled it with `echo`.

Fake launchd later acquired supplementary-group memberships whose names sounded important and treated each as a diplomatic credential.

```text
fake launchd:
I'm in _applepay btw.

SEP:
👍

fake launchd:
so can I—

SEP:
no.
```

The account, UID, groups, and their Unix permission effects were real. The costume’s implied powers were not.

## Then the angels arrived

Then the binary itself started saying things like:

```text
/System/Library/LaunchAngels/
/System/AppleInternal/Library/LaunchAngels/
LaunchAngel
__Angel
```

Our copy of `/sbin/launchd` has `LaunchAngel`, `__Angel`, three LaunchAngels paths, and `Failed to resolve LaunchAngel: error=%s: %d, caller=%s`. It also contains the exact string `com.apple.private.xpc.launchd.allow-submit-launch-angels`.

That last string is a badge-shaped clue, not a completed org chart. It tells us launchd refers to a private entitlement by that name. It does **not** tell us who carries it, how the whole authorization path works, or what submitting a LaunchAngel ultimately means.

So what do we actually have?

An internal Apple concept named `LaunchAngel` left fingerprints: names, paths, code, or configuration references. We can say it exists. We cannot write its biography.

What is a LaunchAngel?

We do not completely know.

```text
Reader:
WHAT IS A LAUNCHANGEL

launchd:
oh those

Reader:
YES THOSE

launchd:
they're LaunchAngels

Reader:
I KNOW WHAT THEY'RE CALLED

launchd:
then why did you ask
```

We could issue each LaunchAngel a tiny harp and property list. None of that is evidence.

The responsible conclusion is less cinematic:

> The examined artifacts support that Apple implements an internal concept called a LaunchAngel. The available evidence does not establish enough to claim its complete semantics.

Reader:

> That’s it?

Authors:

> Yes.

Technical integrity can mean reading the plaque on a locked door and declining to describe the furniture.

## The two impostors meet

Fake launchd is fictional in the technical sense: a user-created account pretending its name conferred office.

LaunchAngel is real in the archaeological sense: an internal name supported by evidence, with semantics we will not fabricate.

Naturally they become friends.

```text
fake launchd:
what do you do

LaunchAngel:
😇

fake launchd:
same

XNU:
NEITHER OF YOU HAS EXPLAINED ANYTHING
```

The exchange gives us opposite errors: treating a familiar name as proof of authority, or an unfamiliar one as permission to invent it. A user named `launchd` is not launchd. A `LaunchAngel` is whatever the evidence supports, not whatever produces the best lore.

Names can lie because we assigned them.

Names can tempt us because Apple assigned them.

Either way, the remedy is evidence.

## Bedtime

At shutdown, the real launchd will coordinate the end of userspace. The fake one will attempt to claim squatter’s rights.

```text
launchd:
children go to bed.

fake launchd:
do I have to

launchd:
YOU DON'T EVEN LIVE HERE.
```

Somewhere above the argument, an undocumented internal concept remains perfectly still.

```text
LaunchAngel:
😇
```

We still do not know what that means.

We do know it has excellent timing.


# 6. Sessions, Windows, and Ceremonial Root

The Mac has booted. XNU governs execution. launchd has populated userspace. You still do not exist.

Computationally. We cannot help with the other kind.

There is no authenticated graphical session associated with your account. The machine may be alive, but it has not agreed that *you* are the person who gets a desktop.

Enter `loginwindow`, carrying the kind of keyring that causes a belt injury.

## Please authenticate before existing

Apple’s archived daemon-lifecycle documentation describes `loginwindow` coordinating the visual and security portions of login and then setting up the authenticated user environment. Apple’s current device-management documentation still exposes `com.apple.loginwindow` as the payload type for Login Window behavior. The first source is historical architecture, not proof that every private call path survived unchanged; the second confirms that Login Window remains a current system surface.

A component may carry many credentials because it spends all day asking other offices to do their jobs.

```text
loginwindow:
I have a hundred keys.

launchd:
because you keep coming to my building.

loginwindow:
how many keys do you have for launchd

launchd:
ask whom?
```

Authentication, directory identity, keychain state, preferences, and graphical startup are related. They are not one operation named `let_human_in()`.

```text
User:
password.

loginwindow:
one moment.

User:
why

loginwindow:
we are determining whether you exist,
whether you may exist here,
which version of you is logging in,
and what furniture that version expects.
```

The family metaphor calls `loginwindow` the receptionist. This is unfair to receptionists, who are rarely responsible for initiating an authenticated computing environment while the guest repeatedly asks why the wallpaper has not appeared.

## Root arrives without an appointment

Root assumes that UID 0 should simplify the encounter.

```text
root:
I do not need to log in.

loginwindow:
then you do not need a graphical session.

root:
I want the desktop.

loginwindow:
for which authenticated user environment

root:
the root one

loginwindow:
please stop inventing products at the desk
```

Unix credentials remain relevant, but they do not collapse every session concept into root’s living room. “I can access a file” does not imply “this rectangle belongs in this user’s graphical world.”

## Those are my windows

Then comes WindowServer.

Apps tend to think they own their windows because the windows contain their names, controls, and occasionally an unsaved document they have been protecting from you for four hours.

WindowServer sees the graphical world at a level individual apps do not. Apple publicly documents windows managed by the macOS window server, display-control features provided through that server, and the window server's role in delivering input events to applications.

That is enough for the family argument. Private frameworks and implementation details clearly add more, but we do not need to promote every observed private surface, entitlement, or symbol into a public architectural promise.

```text
App:
this is my window.

WindowServer:
in my session.

App:
I drew the controls.

WindowServer:
into a surface participating in my composited environment.

App:
you sound like a landlord.

WindowServer:
you sound behind on frames.
```

The window server can coordinate windows without becoming the GPU or arrange display content without becoming the display controller. This family has pipelines, not a final boss.

## The pixel custody dispute

```text
WindowServer:
those are my pixels.

GPU:
I rendered them.

WindowServer:
because I submitted work.

GPU:
executed by whom

WindowServer:

GPU:
say it

WindowServer:
you.
```

The GPU smiles for eleven microseconds.

```text
GPU:
I own the pixels.

Display controller:
lol.
```

The deeper we move into hardware, the more authority becomes a relay race in which every runner mistakes possession of the baton for ownership of the stadium.

The app owns its document model. The window server governs graphical objects. The GPU renders. The display engine scans out. The panel emits light.

The user places a fingerprint directly on it.

At last, a form of authority no subsystem can reverse.

## Private archaeology

A third-party `CGSSpace.swift` artifact preserves the comment `this value MUST be 1, otherwise, Finder decides to draw desktop icons` beside a call to the private `CGSSpaceCreate` API. A 2025 GitHub Gist by Julian Schiavo identifies the file as derived from `avaidyam/Parrot` at commit `6cf7ba419176c386ed8f18e838690a7272fe57ee`. This is source-code evidence about that project's observed behavior, not Apple documentation: a developer tests integers until one stops an ancient household spirit from redecorating.

```text
Developer:
0?

Finder:
DESKTOP :)

Developer:
2?

Finder:
DESKTOP :)

Developer:
1?

Finder:

Developer:
nobody touch it
```

The author recorded an observed constraint. We will not invent a private protocol from the integer’s vibes.

## The session exists

At the end of login, the user environment is alive. Apps can present windows. Agents can serve the session. WindowServer can govern the graphical universe the user recognizes as “the Mac.”

XNU watches all this from below with the irritation of someone who owns the electrical panel but was not invited to choose the curtains.

```text
XNU:
I could terminate WindowServer.

WindowServer:
and then what would the user see

XNU:
nothing.

WindowServer:
whose point is that
```

Privilege can end a world without understanding it. That is power, not government. Apple and modern politics still argue about who invented this.


# 7. Trust and Signatures

An executable approaches the system.

It carries a signature, several entitlements, and a claim that notarization knows it personally.

Everybody at the desk asks a different question.

Code signing addresses integrity and signer identity under a trust model. Notarization records that Apple received the submitted software and found no known malware at that check. Gatekeeper’s documented job is narrower than "all execution": by default it evaluates downloaded software when the user first opens it, checking developer identity, notarization, integrity, provenance, and user approval. Trust caches, mandatory controls, and runtime enforcement answer other questions.

The family calls this entire layered system “the bouncer” because the family has been drinking.

## No single bouncer

It is tempting to put `amfid` alone at the door and say it decides whether code may exist.

That is a satisfying character and an inaccurate constitution.

`amfid` participates in userspace validation and policy work, but code trust is not one daemon with a clipboard. Apple’s published XNU source contains kernel code-signing initialization, trust-cache initialization, code-signing process flags, and page-level code-signing state. Apple’s platform-security documentation separately describes trust caches, Gatekeeper, notarization, entitlements, and other runtime controls. Whatever the private division of labor on one release, `amfid` is not the sole enforcement point.

So the dialogue is a compression, not a protocol trace:

```text
Executable:
hello

amfid:
signature?
```

That question is **comic dialogue**. It is not an observed private protocol string.

The executable opens a folder.

```text
Executable:
Developer ID.

Gatekeeper:
notarization?

Executable:
stapled.

Kernel policy:
entitlements?

Executable:
here.

User:
I downloaded it from a forum called
DefinitelyNormalKernelTools.

Everyone:
why
```

## Eight badges

`amfid` showed up with eight top-level entitlement keys. Another build can change the number. Eight is not a sacred constant; it is today's seating arrangement.

The set includes developer-mode control, NVRAM read/write access, protected `amfid` storage, a keystore/keybag-load capability, a TCC allowance for `kTCCServiceSystemPolicyAllFiles`, hardened-process state, and access to `AppleMobileFileIntegrityUserClient`. The number destroys a bad theory: more entitlements do not mean more authority.

The component crossing forty protected boundaries may need forty badges. The component enforcing one may need eight.

```text
sharingd:
I have 132 entitlements.

amfid:
I have 8.

sharingd:
how are you more important than me

amfid:
you need permission to cross boundaries.

sharingd:
and you?

amfid:
signature?
```

The final line is not an answer, which is why it works.

## Ad hoc code with ambitions

macOS can run code under several policies, and developers use ad hoc signatures legitimately. The joke targets code that confuses “I wrote the entitlement into XML” with “the system must grant it.”

```text
Executable:
I have the entitlement.

AMFI:
you have text spelling the entitlement.

Executable:
same thing.

AMFI:
no.
```

An entitlement claim inside a signature is meaningful only within the signing and policy environment that accepts it. A third-party binary cannot award itself a private Apple entitlement by typing with confidence.

This will disappoint fake launchd, who has already opened a text editor.

```text
fake launchd:
com.apple.private.everything = true

amfid:
signature?

fake launchd:
I signed it myself.

amfid:
with whose authority

fake launchd:
GenuineApple™.

amfid:
that isn't a signing authority.
it isn't even a CPU vendor string
on this architecture.

fake launchd:
branding transcends ISA.

amfid:
leave.
```

## The title problem returns

Root arrives.

```text
root:
I am root.

Gatekeeper:
okay.

root:
run the code.

Gatekeeper:
policy says no.

root:
I am the administrator.

Gatekeeper:
that's your résumé.
```

Administrative choice can alter settings through authorized procedures. Apple documents that users can override Gatekeeper for particular software, and Gatekeeper can be disabled when policy permits. That is different from every request succeeding automatically merely because the caller is UID 0.

The distinction sounds pedantic until it is the only thing separating a deliberate policy change from arbitrary code execution.

## Trust is not virtue

The word *trusted* carries moral luggage. Computers do not care.

A valid signature is not a character reference. Notarization does not promise beautiful code. Trust mechanisms establish narrower facts: signer identity, integrity since signing, cache inclusion, policy satisfaction, or absence of known malware at a particular check.

```text
App:
Apple notarized me.

User:
are you good

App:
I passed a security process.

User:
are you useful

App:
that was not evaluated.
```

The most technically honest character in the chapter remains `amfid`, who has not once claimed to understand the app’s purpose.

```text
amfid:
signature?
```

Somewhere nearby, a system larger than the speaker checks the signature. The line works because `amfid` participates without becoming king.


# 8. sharingd Knows a Guy

Then this motherfucker arrives.

`sharingd` once showed us 134 entitlement keys. Our copy showed **132**. Two badges disappeared between builds; nobody left a note.

That tiny disappearance is the point. Entitlement counts belong to particular builds. They are not universal constants, privacy verdicts, or rankings of royal power. Either number is still an extraordinary entrance.

The 132-key set touches Apple Account, Bluetooth, Wi‑Fi and AWDL, HomeKit, Find My, CloudKit, IDS, Rapport, Nearby Interaction, pairing, identity, storage, contacts, notifications, and networking. It also includes exact private keys such as `com.apple.private.cloudkit.masquerade`, `com.apple.private.cloudkit.systemService`, and `com.apple.private.nsurlsession.impersonate`.

`sharingd` did not walk into the room.

It arrived with a diplomatic passport and 132 visas.

## I share things

```text
User:
what do you do

sharingd:
I share things.

User:
with whom

sharingd:
people.

User:
which people

sharingd:
contacts.

User:
on what devices

sharingd:
trusted and nearby devices,
depending on the feature.

User:
how do you find them

sharingd:
several radios and services.

User:
why do you have 132 entitlements

sharingd:
I told you.

sharingd:
I share things.
```

The restraint in that answer is admirable because the entitlement dump tempts us toward a much larger story.

Two exact entitlement names included `masquerade` and `systemService`. They support that `sharingd` had private CloudKit capabilities unavailable to ordinary third-party apps.

They do not, by themselves, prove arbitrary access to every application’s cloud data.

An entitlement name does not show server authorization, container scope, requests made, records returned, or user actions required.

The entitlement list shows keys to rooms.

It does not provide security footage of which rooms the holder entered.

## The Google Allegations Department

```text
User:
MASQUERADE???

sharingd:
yes.

User:
YOU CAN IMPERSONATE APPS?

sharingd:
the entitlement name supports privileged
CloudKit behavior in authorized contexts.

User:
THAT SOUNDS WORSE

sharingd:
you removed the phrase
"in authorized contexts."

User:
I AM CURRENTLY TOO ANGRY FOR SCOPE
```

Scope remains even when the user is too angry for it.

To establish the creepier claim, we would need behavioral evidence: services contacted, container identifiers requested, records accessed, triggering events, and responses authorized. The binary’s entitlements make that investigation worth doing. They do not let us skip it.

A funny string may be funny. It may not become a warrant.

## Breadth is not rank

`sharingd` coordinates identities, radios, peers, transports, accounts, and data stores. Its entitlement surface reflects the protected doors that integration may require.

`amfid` does not need Bluetooth access to ask its one devastating question.

```text
sharingd:
Bluetooth, Wi-Fi, AWDL, accounts,
contacts, peers, notifications—

amfid:
signature?

sharingd:
can you say anything else

amfid:
no entitlement for it
```

Entitlement count resembles border stamps, not rank. The ambassador travels. The guard stays at one border.

## The Share button is a summons

For an ordinary user, sharing begins with a small square and an upward arrow.

For the system, that gesture may begin discovery, identity, transport, presentation, and data transfer across several components.

```text
User:
*clicks Share…*

sharingd:
WHO SUMMONS ME

User:
I wanted to send one photo.

sharingd:
CONTACTS
RADIOS
PEERS
IDENTITIES
RANGING

User:
my mom is sitting right there

sharingd:
excellent, discovery will be fast
```

The daemon’s broad access is not automatically evidence of abuse. It is evidence of a large trust and attack surface that deserves careful design and scrutiny. Those are different statements, and a serious book can hold both without becoming either marketing or panic.

## The neighbor knows everyone

Every family has a relative who can solve a logistical problem by saying, “I know a guy.”

`sharingd` knows the guy, the guy’s devices, which radios might reach them, which identity service may recognize them, whether a peer relationship exists, and at least three people who can explain why the first handshake timed out.

This makes the following exchange inevitable:

```text
launchd:
where are you going

sharingd:
across several protected subsystem boundaries.

launchd:
badges?

sharingd:
*drops 132 entitlements on desk*

launchd:
I asked a yes-or-no question
```

`sharingd` crosses kingdoms wearing enough credentials to make their rulers nervous. Somewhere, quietly, `amfid` still has eight.


# 9. Memory Has Borders

Software enjoys declarations: this address belongs to process 472; that page is read-only; this device may access this buffer.

Hardware has the less glamorous job of making those sentences survive contact with electricity.

## The bouncer who checks the list

A process sees virtual addresses. CPU hardware translates them and enforces permissions using state arranged by the operating system. Isolation becomes more than a strongly worded comment.

The family calls the relevant translation machinery the MMU.

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

The MMU has never heard of Safari. It has an address and a permission check.

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

XNU configures the state. Hardware says no at machine speed.

Policy without enforcement is a wish.

Enforcement without policy is a very fast misunderstanding.

## Unified does not mean communal

Apple GPUs use unified memory in which CPU and GPU share system memory. The family hears “shared” and immediately creates a refrigerator dispute.

```text
CPU:
I need this buffer.

GPU:
I'm using it.

CPU:
it's in my memory.

GPU:
our memory.

ANE:
can I—

CPU + GPU:
NO.
```

Unified memory does not let every engine read every byte. Metal still distinguishes shared and private storage modes, and synchronization still matters, because the word *unified* did not destroy computer science.

```text
Unified Memory:
everybody shares one pool.

CPU:
so I can read every buffer.

MMU:
no.

GPU:
same question.

MMU:
different office.

Unified Memory:
I was talking about the DRAM.
```

The phrase *zero-copy* is often invited to these discussions and should be watched around the silverware.

## The loading dock

High-speed devices use direct memory access so the CPU need not carry every byte personally.

DMA is useful.

Unrestricted DMA is a burglar with excellent throughput.

Apple documents an IOMMU for each DMA agent on Apple silicon Macs. PCIe and Thunderbolt peripherals can access memory explicitly mapped for them, not the whole house.

Apple's public security guide calls them IOMMUs. Public Asahi Linux reverse engineering identifies the Apple silicon hardware as **DART**. The receipts keep the distinction. DART keeps the loading dock.

```text
Device:
I would like to DMA into memory.

DART:
which memory

Device:
memory

DART:
which.

Device:
0x—

DART:
not mapped

Device:
but I'm hardware

DART:
that's awesome bro
```

The device is hardware. So is the thing denying it.

```text
Device:
I'M LITERALLY HARDWARE

DART:
on your I/O mapping
```

DART is the MMU’s cousin who works security at the loading dock.

## The address dispute

Then root returns carrying hexadecimal.

```text
root:
I need memory at 0x1000.

MMU:
in whose address space

root:
the computer's

MMU:
adorable.

Device:
my 0x1000 maps somewhere else.

DART:
if I say it does.

root:
I have the address.

MMU:
you have an address.

root:
WHICH ONE IS REAL

Memory Controller:
do you want memory or philosophy
```

Same number, different maps. Root brought an address and assumed it was the deed.

## Thunderbolt brought someone

Thunderbolt’s character exists to make the loading dock anxious.

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
absolutely fucking not
```

Drivers and mappings may eventually let the device in. “Plugged in” is not the same as “owns RAM.”

A cable should not be a constitutional amendment.

## The landlord’s landlord

Below all those maps, somebody still has to move the bytes. The memory controller runs the deli counter.

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

Fabric and controller topology varies by generation. “Memory Controller” represents arbitration and movement beneath software abstractions, not one tiny person with a clipboard.

XNU sets policy. MMU and DART enforce mappings. The memory fabric arbitrates traffic.

The DRAM cells store charge and have never heard of root.


# 10. SEP Has a Mailbox

XNU has been waiting for this meeting.

It has kernel privilege, an authenticated request, and a respectable call stack. It approaches the Secure Enclave like an official visiting a smaller department.

```text
XNU:
give me the key

SEP:
no

XNU:
I have kernel privilege

SEP:
on the Application Processor

XNU:
yes

SEP:
I'm not the Application Processor

XNU:

SEP:
:)
```

The joke is now hardware.

## His own fucking CPU

The Secure Enclave has its own processor, Boot ROM, protected memory mechanisms, cryptographic engines, and operating environment. Apple designs it to keep long-lived key material from exposure to the Application Processor and its OS.

This means “kernel privilege” is not a universal key. It is a very powerful credential presented at the wrong border.

```text
XNU:
APPLE WHY DID YOU GIVE HIM
HIS OWN FUCKING CPU

Apple:
security
```

SEP does not need to deny that XNU is privileged. The strongest answer is narrower.

> Correct. Over there.

XNU governs the normal kernel world on the Application Processor. SEP has a distinct security domain. More kernel privilege in the envelope does not turn a request into an order.

```text
XNU:
I'm literally the kernel.

SEP:
on your processor
```

Six words compress the book without making either side weak.

## Protected does not mean magical

SEP is not a wizard under the Touch ID sensor. Its protections include secure boot for sepOS, protected memory, cryptographic hardware, isolated key handling, and constrained interfaces. Capabilities vary by SoC generation.

The family compresses this into a specialist with a one-word vocabulary.

```text
loginwindow:
authentication result?

SEP:
authorized.

securityd:
key operation?

SEP:
allowed.

XNU:
raw key?

SEP:
no.
```

Concise dialogue does not imply simple machinery. The secure relative refuses to explain himself to the narrator.

## The mailbox

The Application Processor and SEP need a way to communicate across their boundary. Asahi Linux's public SEP documentation identifies a SEP mailbox, gives a mailbox base for documented reverse-engineering targets, and shows traced messages moving between AP-side software and SEP endpoints.

That is enough to use the word *mailbox*. It is not permission to invent private opcodes, payload meanings, or authorization semantics beyond what the reverse-engineering evidence actually establishes.

This is especially difficult because the user also has a Unix mailbox.

```text
Application Processor:
I need to communicate with SEP.

SEP:
mailbox.

User:
YOU HAVE A MAILBOX???

SEP:
yeah

User:
SAME HERE BRO 🤝

XNU:
WE HAVE DISCUSSED THIS
```

XNU prepares the technical correction.

```text
XNU:
one is hardware messaging across
a security boundary and the other
is /var/mail

User:
📬

SEP:
📬

XNU:
I hate both of you
```

Footnote: they are not the same thing.

Authors’ response: 🤝

The joke survives because the distinction survives. Claim shared semantics and XNU may terminate the manuscript.

## A message is not an order

A communication channel does not erase the boundary it crosses.

The Application Processor can send a message across the documented reverse-engineered mailbox path. What happens next is governed by SEP-side firmware, protocol, state, and whatever authorization rules apply to that operation. The mailbox does not dissolve the boundary, and receipt of a message is not evidence that the requested operation was authorized.

```text
XNU:
I sent a message.

SEP:
received.

XNU:
therefore do it.

SEP:
that's not what "received" means.
```

IPC grants a way to ask, not a right to the answer. An endpoint does not prove every caller may perform every operation.

The address of city hall is public.

This does not make your email a statute.

## Fake launchd tries a group membership

```text
fake launchd:
I'm in _applepay.

SEP:
👍

fake launchd:
so can I use the keys

SEP:
no.

fake launchd:
but the group name—

SEP:
wrong authority.
```

Unix group membership may affect Unix authorization decisions. Nothing in the observed group name establishes authority over SEP operations, whose interfaces and security state belong to a different domain. A suggestive local group name is not a passphrase whispered through silicon.

Fake launchd writes this down as “inconclusive.”

Everybody else writes “no.”

## Wrong jurisdiction

XNU does not become less of a kernel because SEP can refuse it. SEP does not become supreme because it protects keys XNU cannot demand. Security depends partly on keeping those domains apart.

At the end of the chapter, XNU returns to the Application Processor and announces that the meeting went well.

```text
launchd:
did you get the key

XNU:
the operation completed successfully.

launchd:
that's not what I asked

XNU:
meeting adjourned
```

Behind the security boundary, SEP raises a small red flag on the mailbox.


# 11. The Hardware Family Dinner

The mistake was inviting everyone.

Until now, the family has argued in departments. Boot authorities left before XNU arrived. Session officials spoke to graphics. SEP stopped answering follow-up mail.

Now everybody is seated at one table.

This is the **hardware family dinner**.

There is a place card for every jurisdiction and no place card labeled *boss*.

## The Application Processor owns the house

XNU begins because XNU always begins.

```text
XNU:
I govern the system.

Application Processor:
on my processor.

XNU:
who the fuck are you

Application Processor:
the processor

XNU:
okay?

Application Processor:
you're running on me
```

The Application Processor implements the CPU privilege architecture on which XNU’s kernel authority operates. This does not make the AP a software monarch deciding whether Finder may open a folder. It makes the AP the physical execution domain within which XNU’s instructions and privilege transitions become real.

```text
XNU:
I control execution.

Application Processor:
within the architecture I implement.

XNU:
same thing.

Application Processor:
no.

SEP:
same here bro

XNU:
SHUT THE FUCK UP
```

## The GPU wants credit

WindowServer arrives carrying a completed frame.

```text
WindowServer:
those are my pixels.

GPU:
I rendered them.

WindowServer:
because I submitted the commands.

GPU:
executed by whom

WindowServer:
you.

GPU:
thank you.
```

The GPU’s authority is enormous within graphics and compute work. It does not govern the graphical session merely because it executes rendering commands. WindowServer does not become silicon merely because it arranged the scene.

Then the GPU gets cocky.

```text
GPU:
I own the pixels.

Display Controller:
lol.

GPU:
what

Display Controller:
give me the frame.

GPU:
why

Display Controller:
they have to leave eventually.
```

The family calls the downstream character the Display Controller. Public Asahi reverse engineering describes Apple's DCP as a coprocessor attached to the display engine, and current work shows DCP directly scanning out framebuffers. The exact pipeline varies by machine and display path; the joke only needs the handoff to be real.

```text
WindowServer:
THOSE ARE MY PIXELS

Display Controller:
they are currently photons.
```

Every sovereign eventually meets customs.

## ANE has standards

The Apple Neural Engine sits down only after confirming the menu contains tensors.

```text
CPU:
run arbitrary program.

ANE:
no.

CPU:
matrix multiplication?

ANE:
👀

CPU:
neural network?

ANE:
give.
```

Core ML exposes compute-unit choices that can allow the CPU, GPU, and Neural Engine in different combinations, including a mode where the operating system may choose among all available units. The exact scheduling and supported operations vary. The character’s narrow vocabulary dramatizes specialized authority, not a promise that every neural network executes entirely on ANE.

```text
User:
can you run Doom

ANE:
tensor?

User:
no

ANE:
then perish

GPU:
I can run Doom.

ANE:
congratulations on your
general-purpose workload.

GPU:
you're an accelerator too.

ANE:
I have standards.
```

Power can be deep because it is narrow. ANE does not want the whole computer. ANE wants the tensor, and it would like everyone to stop sending calendar invitations.

## Storage maintains the illusion

APFS believes it manages storage.

The flash controller finds this adorable.

```text
APFS:
block 927 is here.

Storage Controller:
sure.

APFS:
what do you mean sure

Storage Controller:
nothing ❤️
```

Filesystems work in logical structures. Apple’s APFS documentation explicitly acknowledges a flash translation layer beneath the filesystem and notes that it groups writes into NAND blocks. Public Asahi platform documentation separately identifies an Apple-silicon NAND/SSD controller. Neither source tells us where physical cell 927 went on this Mac. The authority in the joke is the abstraction: logical identity does not reveal physical placement.

Later:

```text
APFS:
WHERE DID BLOCK 927 GO

Storage Controller:
still block 927 to you ❤️
```

Authority through abstraction is the friendliest form of lying in the house.

## The loading dock reports an incident

```text
Thunderbolt:
I brought someone.

DART:
manifest?

Thunderbolt:
he's cool.

DART:
mapping?

Thunderbolt:
we met on a bus.

DART:
absolutely not.
```

Thunderbolt is not the villain. It is an interface capable of bringing powerful peripherals close to the system. That is exactly why DMA protections matter.

The device leans into the room.

```text
Device:
I'm literally hardware.

DART:
and I'm literally the IOMMU.
```

The device returns to the loading dock to complete its paperwork.

## Everyone states their office

The host makes the catastrophic decision to go around the table.

```text
Boot ROM:
hardware root of trust.

iBoot:
verified boot work.

Application Processor:
CPU execution.

XNU:
kernel authority.

launchd:
userspace services.

loginwindow:
authenticated session coordination.

WindowServer:
graphical environment.

securityd:
security services and credentials.

amfid:
signature?

sharingd:
nearby and sharing integration.

SEP:
keys.

GPU:
render and compute.

ANE:
tensor.

MMU:
CPU address translation and permissions.

DART:
DMA mappings.

Memory Controller:
actual memory traffic.

Storage Controller:
the physical storage abstraction
you all take for granted.

Display Controller:
actual scanout.
```

Silence.

The front door opens.

```text
root:
I'm root.
```

Everyone:

```text
HAHAHAHAHAHAHAHAHAHAHAHAHAHA
```

Root is offended because root really is powerful. That makes it worse.

## Uninvited guests

Fake launchd walks in.

```text
fake launchd:
I'm UID 2.

XNU:
GET THE FUCK OUT.

fake launchd:
I'm in supplementary groups.

SEP:
no.
```

Then, from somewhere nobody can locate:

```text
LaunchAngel:
😇
```

Everyone:

> What the fuck.

launchd:

> Don’t worry about it.

Reader:

> I am absolutely going to worry about it.

Narrator:

> The available evidence still does not establish its complete semantics.

Reader:

> I hate this family.

## Nobody owns the Mac

At the end of dinner, no character wins.

Boot ROM’s authority was earlier. XNU’s is deeper in operating-system privilege. launchd’s is organizational. WindowServer’s is graphical.

The MMU and DART turn mappings into refusals.

The GPU, ANE, storage, display, and memory machinery own specialized mechanisms. SEP has a security jurisdiction the Application Processor cannot annex. The AP hosts XNU without becoming XNU.

The system works because these limits meet through boot, IPC, policy, mappings, drivers, queues, shared memory, cryptography, and mutual suspicion.

This is the Apple silicon family.

Not a hierarchy with one god at the top.

A house full of different sovereign assholes, each holding one portion of the lease and none willing to wash the dishes.


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


# 13. One More Jurisdiction

We began with a useful lie: hardware at the bottom, kernel above it, userspace above that, and the purchaser floating near the top like a minor deity with AppleCare.

We end with a better picture.

Authority is always authority *over something*.

Boot ROM establishes the first trust in a boot chain and then leaves the argument.

XNU governs kernel execution on the Application Processor.

launchd organizes userspace services.

`loginwindow` coordinates authenticated session creation.

WindowServer governs a graphical environment.

AMFI and its supporting mechanisms participate in code-trust enforcement.

`sharingd` crosses an alarming number of protected boundaries in order to know a guy.

The MMU and DART make memory borders physical.

The GPU renders. ANE tensors. Storage translates. The display emits. The memory controller takes a number.

SEP protects a separate security domain and answers kernel privilege with the most devastating prepositional phrase in the book:

> On your processor.

Root remains powerful.

Fake launchd remains UID 2.

LaunchAngel remains unexplained.

This is not a story about nobody having power.

It is a story about nobody possessing power without a noun.

The front door opens one last time.

The last character is not an Apple component. It comes from another project and another layer of the joke.

```text
Linux:
I am the kernel.

hyprvisor:
that's awesome bro.

Linux:
give me the hardware.

hyprvisor:
no.

Linux:
I'M LITERALLY RING 0.

hyprvisor:
on your virtual machine.
```

Somewhere inside the guest, a process becomes root and feels a chill it cannot explain.

Linux stares at the virtual hardware.

The virtual hardware stares back.

hyprvisor clears its throat.

moo.


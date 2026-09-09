# On Your Processor

## A Field Guide to the Dysfunctional Family Living Inside Your Mac

### v0.4 — The Jurisdiction Edition

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

The receipts still live in the notes, where they can wear name tags like *public documentation*, *direct observation*, *reverse engineering*, *inference*, and *dramatization*. Unless a passage says otherwise, local observations carried forward from the Receipts Edition came from macOS 27.0 build `26A5416b`.

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

The map for the rest of the book is therefore not a pyramid. It is a set of sentences with four required fields:

```text
actor          object                 boundary             enforcement
-----          ------                 --------             -----------
root           Unix file access       policy still applies kernel/filesystem
launchd        service lifecycle      bootstrap domain     launchd + IPC
WindowServer   graphical objects      user/session context window system
TCC            protected resources    app + consent scope  privacy policy
MMU            CPU memory access      address-space map    translation hardware
DART           device DMA             I/O mapping          IOMMU hardware
SEP            protected operations   security domain      SEP hardware/software
host kernel    virtual machine        host resources       host execution
```

The entries are examples, not complete specifications. They force the useful question: *which object, at which border, enforced by what?*

```text
root:
where is my row saying “everything”

Table:
not a valid object.

root:
this table is biased.

Table:
bring a noun.
```

Later chapters will complicate several rows. None will remove the need for the columns.

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

## LocalPolicy is not local politics

Apple silicon can maintain security policy associated with a selected macOS installation. Apple's boot documentation calls the structure **LocalPolicy** and places it in the verified handoff among LLB, iBoot, and the system being started.

The name does not mean “whatever the current administrator prefers locally.” It is boot-policy material protected and consumed by boot machinery under documented rules.

```text
root:
I have a local policy.

LocalPolicy:
are you cryptographically bound
to this operating system installation

root:
I was thinking casual Friday.

LocalPolicy:
wrong policy.
```

Security modes can be changed through authorized recovery workflows. That proves policy is configurable. It does not prove a running process can edit the boot chain's answer by writing “reduced security” on a sticky note.

```text
Administrator:
I changed the startup security setting.

iBoot:
through recovery and accepted policy state?

Administrator:
yes.

iBoot:
then we have paperwork.

root:
I shouted during normal boot.

iBoot:
then we have audio.
```

Recovery is therefore not merely “macOS, but with fewer apps.” It is a different boot environment with authority for particular repair and policy operations. The machine does not grant those operations to any process that happens to display a wrench icon.

```text
root:
I would like recovery authority.

Recovery:
are you in recovery

root:
I am recovering emotionally.

Recovery:
boot environments remain regrettably literal.
```

That difference matters whenever somebody says an administrator “can” change a boot setting. Yes, through the authorized path. The path is part of the claim. Leaving it out is like saying a passenger can fly the plane because the airline employs pilots.

Normal boot, recovery, and fallback paths do not all begin with the same policy state or promise the same tools. The durable claim is smaller: early trusted code selects and verifies what comes next according to the active boot path and policy. Anything more specific belongs in the receipts with a device generation attached.

This is another kind of authority: not the power to run a process now, but the power to determine which system and security configuration may become the environment where processes later run.

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

## A system call is not customer service

Applications cross into the kernel through defined interfaces for operations such as files, memory, processes, and networking. This gives XNU authority over whether and how those kernel mechanisms proceed.

It does not require XNU to understand the user's purpose.

```text
Notes:
save my document.

XNU:
write these bytes to this file descriptor?

Notes:
my novel.

XNU:
bytes.

Notes:
the emotional climax.

XNU:
length?
```

The kernel accepts technical operations, not product requirements. Userspace turns “save my document” into a sequence of file, metadata, synchronization, and policy requests. XNU can enforce each request it receives without knowing whether the document is a novel or a resignation letter written in TextEdit at 4:52 p.m.

```text
User:
the app lost my work.

XNU:
the write system call succeeded.

User:
then where is it

XNU:
that is a product question wearing errno.
```

This boundary explains why kernel authority is both deep and strangely literal. XNU can stop a process, deny an operation, or preserve isolation. It cannot infer the high-level promise the app made to the person clicking Save.

The scheduler has the same problem. It decides what runs, where, and for how long under kernel policy. It does not know which thread contains the user's apology email and which one is animating a button nobody can currently see.

```text
Application:
this thread is urgent.

Scheduler:
priority and runnable state?

Application:
the user is watching.

Scheduler:
that sounds like metadata
someone should have translated.
```

Kernel mechanisms need inputs they can enforce. “Important” is not one of them until some interface turns importance into a supported scheduling or quality-of-service decision. Human urgency cannot cross the boundary as raw emotion.

```text
User:
why is the spinner spinning

XNU:
many threads are making progress.

User:
not the one I care about.

XNU:
there it is: the missing noun.
```

This is not indifference. It is what a mechanism looks like before userspace supplies product meaning. The kernel governs execution. The application still has to arrange useful work.

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

## Registered is not running

A service can be known to launchd without its provider consuming a process forever. On-demand startup separates the existence of a service contract from the current existence of the process that serves it.

```text
Client:
is com.apple.important.thing running

launchd:
do you need it

Client:
I asked whether it is running

launchd:
and I asked whether you would like
to make the answer yes
```

That distinction lets the system advertise a named capability, wait for demand, and start work when a client actually asks. It also creates several meanings of “the service exists”: its job may be registered, its endpoint may be discoverable, its process may be alive, and its current request may still be failing spectacularly.

```text
Service label:
I exist.

Process table:
I don't see you.

Service label:
organizationally.

Process table:
I count bodies.
```

launchd operates at exactly this uncomfortable border between names and bodies. It can arrange for a provider to appear. It cannot promise the provider will remain alive, answer correctly, or avoid logging `how did we get here` after reading its own configuration.

## A restart is not resurrection

Job management also separates a service's intended lifecycle from the lifetime of any one process. A process can exit while the job definition and service expectation remain. Depending on configuration and demand, launchd may arrange another process later.

```text
Process:
I died.

launchd:
the job persists.

Process:
so I am immortal.

launchd:
no, you are replaceable.
```

That distinction is less poetic and much more useful. Clients care about reaching a service. Administrators care about the job's policy. The process table cares about the current body. Treating all three as the same object makes every restart look supernatural.

```text
Client:
are you the same service as before

New process:
same name.

Client:
same state?

New process:
let's keep this interaction professional.
```

Restart policy is not proof that launchd can repair arbitrary failure. It can arrange another attempt. It cannot make corrupt state uncorrupt, make a missing dependency appear, or teach a daemon what its own configuration means.

```text
launchd:
try again.

Service:
with what changed

launchd:
your PID.
```

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

## A job is not its current process

The family uses service name, job, daemon, and process as if they were interchangeable because nobody wants to diagram lunch.

They are not interchangeable.

A job definition describes how launchd should manage work. A label names that job within the relevant management context. A process is one execution instance. A named service can be registered for clients and may outlive any particular server process through restart or on-demand launch behavior.

```text
Job label:
com.apple.example

Process:
PID 804.

Job label:
I am eternal.

Process:
I have been alive for nine seconds.

launchd:
both of you stop using religious language.
```

This matters when a process crashes and the service later returns. “The daemon restarted” is ordinary and often useful. Underneath, a management record persisted while one process died and another received a different PID.

```text
Client:
are you the same service

New process:
yes.

Kernel:
different PID.

Client:
I regret asking both departments.
```

Identity has layers even among the children. A label is not a PID. A PID is not a Unix account. A Unix account named `launchd` is about to ignore both sentences.

## Same executable, different childhood

An executable file does not carry one permanent social role. The context in which a process starts helps determine its credentials, environment, service namespace, and access to session resources. The same bytes can participate in different situations without becoming a different file.

```text
Executable:
I am the same binary.

System domain:
different job context.

User domain:
different user context.

Executable:
but my hash matches.

launchd:
identity is not placement.
```

Code signing can answer questions about the code object. Unix credentials can answer questions about the running process. launchd's domain can answer where the job is managed. TCC may later ask which responsible code and user decision apply. One executable has now visited four desks without changing its checksum.

This is why copying a privileged system program into a terminal does not copy its office with it. The file may still be authentic code. The new process does not automatically inherit the original job definition, bootstrap placement, launch conditions, credentials, or approved relationships.

```text
User:
I launched the system binary myself.

Binary:
correct.

User:
so it has its normal authority.

launchd:
define normal.

User:
the powerful one.

launchd:
denied for failure to provide a noun.
```

Conversely, a humble-looking helper can matter because the system starts it in a context with a narrow responsibility. The filename does not need to sound royal. The launch relationship supplies the job; policy supplies the boundaries.

```text
Helper:
my name ends in helper.

fake launchd:
embarrassing.

Helper:
I have an actual job.

fake launchd:
class warfare.
```

The children are not ranked by how impressive their executable names look. They are situated.

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


# 6. Who Owns the User Session?

The Mac has booted. XNU governs execution. launchd has populated userspace. You still do not exist.

Computationally. We cannot help with the other kind.

Your account can exist in a directory while nobody is logged in. Your password can be accepted before your desktop exists. Your desktop can exist while a background service associated with your account has no window at all. These facts travel together so often that the wallpaper encourages us to call them one thing.

The wallpaper is lying.

## Please authenticate before existing

Enter `loginwindow`, carrying the kind of keyring that causes a belt injury.

Apple's detailed public account of this territory is historical. Its archived daemon-lifecycle documentation describes `loginwindow` coordinating the visual and security portions of login, then setting up the authenticated user environment. Current device-management documentation still exposes `com.apple.loginwindow` as the payload type for Login Window behavior.

That supports a durable role, not a promise that every private call path from old OS X survived unchanged. The receptionist still works here. We are not publishing the floor plan behind the desk.

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

An account name answers *which recorded identity?* Authentication answers *has this attempt supplied acceptable proof?* A session answers *which live environment is being formed for that identity now?* One may lead to the next. None is a synonym for the next.

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

Authentication, directory identity, keychain state, preferences, and graphical startup are related. They are not one operation named `let_human_in()`.

The family metaphor calls `loginwindow` the receptionist. This is unfair to receptionists, who are rarely responsible for initiating an authenticated computing environment while the guest repeatedly asks why the wallpaper has not appeared.

## The account was already here

This is the part humans find suspicious. If the account already existed, what exactly did login create?

Not the account. A live relationship between that identity and this period of activity.

The distinction explains several otherwise haunted observations. Files can belong to a user who is asleep. A scheduled system task can refer to an account with no desktop on screen. Two processes can carry the same numeric user identity yet inhabit different moments, service contexts, or expectations about what “the current session” means.

The book will not turn that last sentence into a claim about one undocumented internal object. It is the safer architectural point: persistent identity and live session state answer different questions.

```text
Account record:
I've existed for three years.

loginwindow:
congratulations.

Account record:
so I am logged in.

loginwindow:
you are a row with a home directory.

Account record:
harsh.

loginwindow:
accurate.
```

Logging out makes the boundary even clearer. The account remains. Its files remain. The particular user environment can end. Identity survives the party because identity was never the party.

## Root arrives without an appointment

Root assumes UID 0 should simplify the encounter.

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

Unix credentials matter. They can answer file-access and process-privilege questions with tremendous force. They do not manufacture an authenticated human, choose the active user's preferences, or make every per-user service regard the caller as its resident.

This is where root becomes ceremonial in a very specific sense. The title remains real. The ceremony is root announcing it to an office currently asking for a different noun.

```text
root:
I can read the user's files.

loginwindow:
that is a file answer.

root:
I can signal the user's processes.

loginwindow:
that is a process answer.

root:
I am running out of answers.

loginwindow:
you brought the wrong form.
```

## The apartment above the system

Once a user environment is active, services and agents can live in a per-user context rather than the root system context. Chapter 4 called launchd's world a civilization; here we discover it has zoning.

A system daemon may serve the whole machine. A user agent may belong to one logged-in environment. An application may arrive later and ask that environment for a service by name. The exact private construction has changed across releases and contains more machinery than this family portrait shows. The point is the boundary: machine-alive and user-present are different conditions.

```text
system service:
I've been awake since boot.

user agent:
I live with Efe.

system service:
the account?

user agent:
the current session.

system service:
same thing.

loginwindow:
absolutely not.
```

Account ownership does not make the service global. System scope does not make the daemon a member of every user's session. launchd can organize both without pretending they occupy one flat household.

This is also why “the user launched it” can be a useful explanation and a terrible complete specification. Which user identity? Which active environment? Which service context? Which policy accepted the request? The ordinary sentence compresses all four because ordinary people are trying to open Calendar, not defend a dissertation before breakfast.

Inside the machine, the missing nouns still matter.

## The room was lit before you arrived

WindowServer is not born from the authenticated user's session. The machine already needs system-domain graphical infrastructure to present a graphical login before that user environment exists. After authentication, the new session's apps connect into that pre-existing graphical world for the user's desktop.

On this edition's target build, the installed `com.apple.WindowServer` launchd property list lives under `/System/Library/LaunchDaemons` and names WindowServer's private SkyLight executable with `-daemon`. That is direct evidence of a system service definition, not a trace of its exact startup timing. Apple's archived login documentation separately establishes the order that matters here: the login window is displayed before authentication, and user-environment setup begins afterward. The exact modern private wiring is not a public contract.

The corrected map therefore has two tracks. The graphical room is already open while `loginwindow` handles the guest list.

```text
system startup                         account identity
      |                                      |
      v                                      v
WindowServer <--- graphical login UI --- loginwindow
      |                                      |
      |                                authentication
      |                                      |
      |                         authenticated user session
      |                              |               |
      |                              v               v
      |                      per-user services     user apps
      |                                              |
      +<----------- managed session windows --------+
      |
      v
GPU execution -> display scanout -> light -> user
```

The arrows show relationships, not a complete private call trace. `loginwindow` coordinates the visual login without becoming the renderer. WindowServer can manage the login UI without authenticating the person. Later, a user app joins the graphical environment; it does not create that environment by arriving.

At the end of login, the account has become a live user environment. Its services can answer and its apps can bring windows into infrastructure that was already capable of showing the front desk.

Root can still end many of its processes. That does not mean root formed the session, understands it, or can substitute a title for the identity it was built around.

Privilege can end a world without understanding it. That is power, not government. Apple and modern politics still argue about who invented this.


# 7. Those Are My Windows

The session exists. This is immediately followed by a property dispute.

Apps tend to think they own their windows because the windows contain their names, controls, and occasionally an unsaved document they have been protecting from you for four hours.

Then WindowServer walks in and asks what they mean by *own*.

## The content and the rectangle

An app owns the state and behavior that make its interface useful. It decides that a button means Save, that a document contains seventeen paragraphs, and that the spinning progress indicator should continue offering hope long after hope has left the process.

The graphical object participating in the shared desktop is a different concern. Apple publicly documents onscreen and offscreen windows managed by the macOS window server, including information scoped to the current user session. Its Quartz display documentation also exposes display configuration and control through window-server facilities.

That is enough to establish the dispute without claiming every private detail is a stable contract.

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

The app can know what the pixels mean without deciding where every graphical object appears relative to every other one. WindowServer can manage those objects without knowing whether the sentence underneath the cursor is a tax return or an extremely long apology.

Meaning belongs upstream. Placement belongs elsewhere. The user experiences a seamless desktop because neither office includes the jurisdictional argument in the screenshot.

## Offscreen still counts

Apple's public name for this surface is useful: Quartz Window Services covers both onscreen and offscreen windows managed by the macOS window server. Visibility, then, is not the admission ticket for graphical government.

An app can create content that is covered, moved away, or not presently visible. The managed window does not stop participating in the system merely because the user cannot point at its photons. “I cannot see it” is a report from the user, not a revocation of the object's place in the graphical environment.

```text
App:
where is my window

WindowServer:
behind twelve other windows.

App:
so it doesn't exist.

WindowServer:
that theory would solve storage too.

App:
put me on top.

WindowServer:
now you're finally asking a window question.
```

This gives WindowServer authority over arrangement without granting it authorship. It can know the window's bounds and relationship to other graphical objects while remaining heroically uninterested in the spreadsheet formula inside it.

## Input has to find an address

The shared graphical world is not only output. A click arrives from hardware with coordinates, timing, and button state. It still has to become *this app receives an event for this window*.

Apple's archived event-architecture documentation places the system window server in that delivery path. Historical documentation is evidence for the architectural role, not a current private call graph. We can say the window server participates in delivering input to applications. We cannot use an old diagram to narrate every modern hop with courtroom confidence.

```text
Mouse:
click.

App A:
mine.

App B:
mine.

WindowServer:
one of you is under the pointer.

App B:
is it me

WindowServer:
you are minimized.
```

The event can belong to the user's physical action, the input system's data stream, a managed graphical object, and the receiving app's interface logic in different senses. The sentence “the app got the click” is true because several authorities did not all try to be the same authority.

The reverse is funny too. An app can decide what a click means only after the graphical system has delivered one to it. It may interpret the event as selecting text, firing a button, or beginning a drag. It cannot retroactively declare that the click occurred in its window because the click would have been emotionally meaningful there.

```text
App A:
I needed that click.

WindowServer:
it happened in App B.

App A:
but my button was better.

WindowServer:
appeal denied.
```

## The pixel custody dispute

WindowServer can coordinate windows without becoming the GPU. It can arrange display content without becoming the display controller. This family has a pipeline, not a final boss.

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

“Rendered” and “displayed” are not synonyms. A rendering result can exist in memory before any panel shows it. Display scanout is downstream from the work that produced the image. On Apple silicon, public reverse engineering also identifies DCP in the display path, but this chapter keeps the character generic because exact pipelines vary by chip, machine, and display route.

The deeper we move into hardware, the more authority resembles a relay race in which every runner mistakes possession of the baton for ownership of the stadium.

The user then places a fingerprint directly on the panel.

At last, a form of authority no subsystem can reverse.

## Private archaeology

Private interfaces make this territory especially good at humiliating certainty.

A public third-party `CGSSpace.swift` artifact preserves the exact comment `this value MUST be 1, otherwise, Finder decides to draw desktop icons` beside a call to the private `CGSSpaceCreate` API. A 2025 GitHub Gist by Julian Schiavo identifies the file as derived from `avaidyam/Parrot` at commit `6cf7ba419176c386ed8f18e838690a7272fe57ee`.

This proves the comment and code exist in that project lineage. It does not turn the integer into an Apple-documented ABI or promise the behavior survives on another release. A developer recorded a constraint after dealing with private machinery, which is how folklore acquires hexadecimal notation.

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

The author found the name, the call, and an integer associated with observed behavior. We will not invent the missing semantics from the integer's vibes.

SkyLight and related private surfaces deserve the same restraint. Their names and observed artifacts can establish that machinery exists. Unless Apple documents a behavior or we reproduce it under stated conditions, they do not authorize us to publish a complete invisible constitution.

## A tenant who doesn't pay rent

The Parrot-derived `CGSSpace.swift` comment told us one integer's secret. It didn't tell us what somebody would eventually build on top of it.

A menu-bar utility called BoringNotch answers that question. It creates a synthetic CGSSpace, pushes its level up past ordinary windows with `CGSSpaceSetAbsoluteLevel`, and calls `CGSShowSpaces` to make that Space visible everywhere at once. That's a different trick than the public `canJoinAllSpaces` flag on `NSWindow.collectionBehavior`, which joins Spaces that already exist. This one skips joining entirely. It makes a new Space and puts itself there. The source comment repeats the same warning ours did: `flag = 0x1`, or Finder starts drawing desktop icons on it.

We watched the call succeed once, on one build. That's not the same thing as knowing what CGS checks internally or when it says no. The window living inside is unremarkable. The Space itself is the whole trick, as far as we got to see it work.

```text
WindowServer:
you're not assigned to any of my Spaces.

BoringNotch:
correct.

WindowServer:
then how are you visible on all of them.

BoringNotch:
I'm not on any of your Spaces.
I made my own.

WindowServer:
that's not how tenancy works.

BoringNotch:
it worked this time.
```

## The sandbox has a side door

The same app also wants to set screen brightness, which lives behind CoreBrightness. A sandboxed process can't reach it, and Space tricks don't help here.

So it ships two binaries. The main app stays sandboxed (`com.apple.security.app-sandbox: true`, confirmed directly). A companion XPC helper, `BoringNotchXPCHelper.xpc`, ships unsandboxed and does nothing but broker six methods: accessibility authorization, keyboard backlight, screen brightness. The two talk over a private mach service, registered through a `com.apple.security.temporary-exception.mach-lookup.global-name` entitlement.

Splitting privileged work into an unsandboxed helper is a known shape. Apple's own name for the entitlement is *temporary exception*, and that's worth taking at face value: it tells us what the entitlement grants, not how any particular App Review pass treated this build.

```text
boringNotch:
I'm sandboxed.

Sandbox:
correct.

boringNotch:
I need CoreBrightness.

Sandbox:
no.

boringNotch:
my friend isn't sandboxed.

Sandbox:
your friend.

boringNotch:
we talk over a mach service.

Sandbox:
I don't police your friendships.

boringNotch:
you should.
```

## The HUD that got there first

Volume looked like the same story at a glance: an app grabbing a system indicator it has no business touching. The event handler tells a smaller story than that.

The app installs a `CGEventTap` at the head of the tap list (`.headInsertEventTap`), filtering for the event type that carries media-key presses. When a volume key comes through, it handles the press itself and returns `nil`.

macOS still decides whether that tap gets to exist. It's gated behind input-monitoring permission and can be disabled outright. `nil` only controls what happens after the tap is already running: that one event stops there instead of reaching whatever was next in line, which in practice means `OSDUIHelper` never finds out the key was pressed. Stopping one event isn't the same as owning the pipeline it travels through.

```text
Volume key:
*pressed*

BoringNotch:
got it, thanks.

OSDUIHelper:
got what

BoringNotch:
nothing you need to worry about

OSDUIHelper:
I show the volume HUD

BoringNotch:
so do I, now
```

Even the feedback sound isn't synthesized. The handler plays `/System/Library/LoginPlugins/BezelServices.loginPlugin/Contents/Resources/volume.aiff` straight off disk, the same file the real bezel uses, and checks the same `com.apple.sound.beep.feedback` preference first. This isn't privilege escalation. It's winning a race, inside rules the system still enforces, cleanly enough that nobody notices there was one.

## Three different "shouldn't be able to"s

One symptom. Three mechanisms. Three boundaries, and three different amounts of each one we actually got to see.

The Space trick answers to WindowServer. We watched it succeed; we didn't watch why.

The helper answers to the sandbox, through an entitlement Apple itself labels an exception.

The event tap answers to whatever let it run in the first place. Once it's running, all it controls is whether one event keeps moving.

```text
User:
how is it doing all this

XNU:
everything answers to me eventually. I am the kernel.

User:
so how

XNU:
I watched one call succeed.
that's not the same claim.

User:
that's not an answer

XNU:
it's the only one I have jurisdiction to give.
```

## Whose screen is it?

By now every participant has a respectable claim.

The app owns the document model. WindowServer manages windows in the graphical environment. The GPU executes rendering work. The display path scans out an image. The panel emits physical light. The user sees “my desktop” and is correct at the only level that motivated the entire arrangement.

```text
App:
my content.

WindowServer:
my managed window.

GPU:
my completed work.

Display controller:
my scanout.

Panel:
photons.

User:
can I move the icon three pixels left

Everyone:
Finder.
```

XNU could terminate a process involved in the scene. That is enormous kernel authority and terrible art direction. Ending the graphical world is not the same act as governing its windows, rendering its surfaces, or understanding what any of them say.

No one owns “the pixels” without supplying a noun after *owns*. The joke works because the screen looks singular. The machinery does not.


# 8. Trust and Signatures

An executable approaches the system.

It carries a signature, several entitlements, and a claim that notarization knows it personally.

Everybody at the desk asks a different question. This chapter belongs to the first desk: *who signed these bytes, what exactly did they sign, and are these still the bytes they signed?*

Whether policy likes the answer is Chapter 9's problem.

## No single bouncer

It is tempting to put `amfid` alone at the door and say it decides whether code may exist.

That is a satisfying character and an inaccurate constitution.

`amfid` participates in userspace validation and policy work, but code trust is not one daemon with a clipboard. Apple's published XNU source contains kernel code-signing initialization, trust-cache initialization, code-signing process flags, and page-level code-signing state. Apple's platform-security documentation separately describes code signatures, trust caches, entitlements, notarization, Gatekeeper, and runtime controls.

Whatever the private division of labor on one release, `amfid` is not the sole enforcement point.

```text
Executable:
hello

amfid:
signature?
```

That question is comic dialogue. It is not an observed private protocol string.

```text
Kernel policy:
valid pages?

Trust cache:
recognized hash?

Signature machinery:
recognized signer?

Executable:
could everyone ask at once

Everyone:
no
```

“Signed code” is a useful phrase because ordinary conversation cannot spend twelve minutes naming every verification layer. The machine is allowed to be less conversational.

## A signature is not a compliment

A code signature binds claims to code. It can help establish that the code has not changed since signing and identify the signing authority under a trust model. It can also carry entitlements whose acceptance depends on that signing and policy environment.

None of those facts says the program is kind, fast, useful, or willing to restore the document you closed without saving.

```text
App:
I am signed.

User:
are you good

App:
I can tell you who signed this version of me.

User:
are you good

App:
that field was not in the signature.
```

Identity here is narrower than a filename. Renaming an app does not manufacture a new signer. Copying it to a different folder does not make the bytes morally independent. Conversely, a familiar filename does not prove familiar code.

```text
Executable:
my name is Calculator.

Signature machinery:
that is a pathname wearing confidence.
```

The useful identity comes from cryptographic material and requirements, not the icon's ability to look employed.

## The page has changed

Code signing becomes physical when executable pages enter memory. XNU's public source exposes page-level state for whether code has been validated or tainted. That does not reveal every modern private implementation detail, but it kills the idea that signing is merely a receptionist checking a certificate once and forgetting the building exists.

```text
Code page:
I was valid yesterday.

Kernel:
you are different bytes today.

Code page:
personal growth.

Kernel:
taint is not a wellness program.
```

The signature covers a specific code identity. It does not bless an abstract project forever. Rebuild the program and you have new bytes to sign. Modify signed code and the old claim does not stretch around the change out of loyalty.

This is why “the app is signed” should always provoke one quiet follow-up: *which exact app?*

## Ad hoc code with ambitions

Developers use ad hoc signatures legitimately. They are useful when a cryptographic seal is needed without an external signing identity. The joke begins when code mistakes “I contain a signature structure” for “the platform must accept every claim I placed inside it.”

```text
Executable:
I signed myself.

Signature machinery:
then I know these bytes belong to
the person who had these bytes.

Executable:
excellent.

Signature machinery:
you have misunderstood the tone.
```

The same problem appears with entitlements.

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

This disappoints fake launchd, who has already opened a text editor.

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

## Eight badges

On the v0.3 observation build, `amfid` carried eight top-level entitlement keys. Another build can change the number. Eight is not a sacred constant; it was the seating arrangement on macOS 27.0 build `26A5416b`.

The set included developer-mode control, NVRAM access, protected storage, a keystore capability, a TCC allowance, hardened-process state, and access to an AppleMobileFileIntegrity user client. The exact XML is in the receipts because values and arrays matter more than a dramatic key count.

The number destroys a bad theory: more entitlements do not mean more authority.

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

Chapter 11 will make the entitlement bureaucracy produce identification. Here the narrower point is enough: a signed claim has an issuer, a subject, and an enforcement context. XML does not become authority because the angle brackets look official.

## The trust cache is not networking

Apple documents trust caches as collections of code-directory hashes for code already trusted under the platform's model. On Apple silicon, static trust-cache material participates in secure boot, and other caches can support operating-system and installed content. The implementation has more categories and lifecycle rules than this chapter needs.

The useful boundary is simple: cache recognition answers a code-trust question. It is not a copy of the executable, a certificate of good taste, or a networking optimization.

```text
Executable:
am I in the trust cache

Trust cache:
hash?

Executable:
I asked first.

Trust cache:
that is not how lookup works.
```

A matching hash does not mean the cache met the developer and developed confidence in their roadmap. The code identity matches an entry supplied through an authorized trust path.

```text
Safari:
clear the cache.

Trust cache:
wrong cache.

Safari:
sorry.

Trust cache:
everyone says that after the third click.
```

The joke is cheap. The separation is expensive. A browser cache can forget web resources. A trust cache participates in whether code is recognized by system trust machinery. Sharing a noun does not merge their blast radii.

## Identity hands the file onward

At this desk, the executable can establish a signer, integrity, requirements, and accepted signed claims. It can still lose at the next desk.

A valid signature is not a launch order. Inclusion in a trust cache is not user consent. An entitlement is not proof the app used a capability. Notarization is not a lifetime warranty against unknown malware. These mechanisms exchange evidence; they do not collapse into one adjective named *trusted*.

```text
Executable:
so I passed?

amfid:
you answered my question.

Executable:
is that a yes

amfid:
next desk.
```

The next desk has policy, malware definitions, a system assessment database, and absolutely no obligation to be impressed by a cryptographically sound résumé.


# 9. Policy Is Not Enforcement

The executable leaves the signature desk carrying excellent paperwork.

Gatekeeper looks up.

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

Administrative authority is real. It can change some policies through authorized procedures. It does not force every policy check to return *yes* merely because UID 0 asked with excellent posture.

## Four verbs enter a security system

Descriptions of platform security become useless when every component is said to “protect the Mac.” A lock protects the Mac. So does a malware signature. So does refusing first launch. So does removing something that already ran. The verb needs an object and a time.

This chapter uses four:

```text
evaluate -> block -> detect -> remediate
```

They are not guaranteed to occur in that exact line for every file. The diagram is a vocabulary, not a private call trace.

**Evaluate** asks how a proposed operation fits policy. **Block** prevents an operation from proceeding. **Detect** recognizes something as known malware or suspicious material. **Remediate** responds after unwanted software or artifacts are present.

One component can participate in more than one verb. One favorable answer does not answer the next question.

```text
App:
my signature is valid.

Gatekeeper:
good for the signature.

App:
Apple notarized me.

XProtect:
I have newer definitions.

App:
I already passed.

Everyone:
which verb
```

## Gatekeeper works the arrival desk

Apple documents Gatekeeper around downloaded software and first open. It checks matters including identified-developer status, notarization, integrity, provenance, and user approval. It is not a tiny person intercepting every instruction the CPU executes.

That narrower job is still consequential. A program arriving from outside the App Store does not gain the right to launch by having a pleasing icon and a README that says “disable your antivirus.”

```text
Downloaded app:
I came from the internet.

Gatekeeper:
I noticed.

Downloaded app:
how

Gatekeeper:
you arrived carrying provenance
and a tutorial titled
HOW TO BYPASS THIS WARNING.
```

Users can approve particular software through documented controls. Managed policy can shape the available choices. Older command-line controls have changed over time; on the observed macOS 27.0 system, the `spctl` manual marks several rule-database and global-state modification options deprecated as of macOS 15.

That history matters. “An administrator could change this setting once” is not a timeless API contract. Authority can keep its name while the accepted form moves to a different office.

## The user can overrule a refusal, specifically

Apple provides a documented way for a user to approve a particular blocked app in Privacy & Security after attempting to open it. That is a scoped override made through an authorized interface. It is not the user abolishing code signing by clicking a button with feeling.

```text
User:
open anyway.

Gatekeeper:
for this app?

User:
yes.

Random unsigned thing nearby:
and me?

User:
who are you
```

The distinction explains why “the user is in charge” needs the same noun discipline as “root is in charge.” A user can supply approval where the policy accepts user approval. The user does not thereby become a signing certificate, a malware definition, or a kernel enforcement mechanism.

Root's role is similarly procedural. Administrator credentials can authorize changes that policy exposes to administrators. That does not turn the caller into the policy database or make a denied operation retroactively compliant.

```text
root:
I can change the rule.

Gatekeeper:
through the supported control.

root:
so I win.

Gatekeeper:
you have discovered settings.
```

## `syspolicyd` is an oracle, not a monarch

The local `syspolicyd(8)` manual calls `syspolicyd` the System Policy daemon. It says the daemon manages a policy database and serves as a general oracle other components may ask for a verdict on a proposed operation involving installation, loading, execution, or other use.

Oracle is Apple's word in the manual, which is almost unfairly good casting.

```text
Installer:
may I proceed

syspolicyd:
the policy says no.

Installer:
what do you personally believe

syspolicyd:
I am a database with office hours.
```

An oracle returns a policy verdict. Something still has to ask. Something still has to honor the result. A database row does not physically tackle a process.

```text
Policy:
deny.

Enforcement:
denied.

Policy:
I did that.

Enforcement:
you wrote it down.
```

This distinction is not an insult to policy. A map does not become useless because it cannot build the roadblock itself.

## XProtect checks the guest list again

Apple describes its malware defenses in layers. Gatekeeper and notarization help prevent or inhibit launch. XProtect uses threat intelligence and signatures to identify and block known malware, and Apple documents XProtect performing remediation as well.

The timing is the joke. A notarization check reports what Apple knew and evaluated for a submitted item at that time. Threat intelligence can change afterward.

```text
App:
I was notarized Tuesday.

XProtect:
it is Friday.

App:
I have a receipt.

XProtect:
I have an update.
```

This does not make notarization fake. It makes security knowledge time-dependent, which is ruder.

```text
Notarization ticket:
no known malware at assessment.

App:
so I am clean forever.

Notarization ticket:
I contain a date.
```

The phrase *known malware* contains the entire temporal boundary. A scanner cannot match a definition it does not have. A later definition does not travel backward and accuse the earlier service of perjury.

## MRT and the danger of immortal org charts

The observed macOS 27.0 build contains artifacts named `XProtect.bundle`, `XProtect.app`, and `MRT.app`. The names are directly observable. Their complete current division of labor is not something a directory listing can establish.

Apple's current platform-security documentation describes XProtect's detection and remediation roles. Older discussions often treat Malware Removal Tool, or MRT, as the remediation character. This edition keeps the installed `MRT.app` name as an observed artifact without forcing a historical org chart onto current private behavior.

```text
MRT:
I am still in the directory.

Narrator:
what exactly do you do now

MRT:
you have confused presence with semantics.

Narrator:
fair.
```

An installed name proves an installed name. A launch trace can prove activity under stated conditions. Neither gives us permission to invent the whole internal case-routing system because “MRT removes malware” fits nicely on a mug.

## A favorable answer is not diplomatic immunity

Now the app presents its collected approvals.

```text
App:
valid signature.

Signature desk:
yes.

App:
acceptable first-open policy.

Gatekeeper:
yes.

App:
no known malware match.

XProtect:
at this check, yes.

App:
then I may read the user's microphone.

TCC:
who invited you
```

That next refusal is not security contradicting itself. It is a new question about a protected resource and user consent.

Policy without enforcement is a wish.

Enforcement without policy is a very fast misunderstanding.

Neither sentence says policy and enforcement must live in one daemon. The system works because a verdict can cross a boundary without carrying every authority behind it.

The executable has proved its identity, survived an arrival policy, and avoided a known-malware match. It is now standing outside the microphone with no consent.

The résumé was excellent.

The next office wants the user.


# 10. Consent Is Its Own Authority

The app has a valid signature. Gatekeeper accepted its arrival. XProtect has no current objection.

It asks for the microphone.

```text
App:
microphone please.

TCC:
did the user agree

App:
I passed three other desks.

TCC:
none of them were the user.
```

Transparency, Consent, and Control is the part of macOS privacy policy that makes this chapter's answer wonderfully inconvenient: authority over a protected resource can depend on a person approving a particular app for a particular category of access.

Root brought a Unix résumé again.

## Permission is overloaded

People say “permission” for at least four different questions:

- Do the file's Unix mode bits or access-control list permit this account?
- Does a sandbox profile permit the process to reach this class of resource?
- Does the app carry an entitlement accepted under its signing environment?
- Has the user or managed policy approved this app for a protected privacy category?

Those questions can all matter to one attempted read. A yes from one desk does not union the others into surrender.

```text
root:
the file mode says I can read it.

TCC:
that is a file-mode answer.

root:
we have done this bit.

TCC:
you keep bringing the bit.
```

Apple's sandbox documentation is unusually direct here. An app cannot automatically gain Full Disk Access through an entitlement or code. The person using the Mac must choose to grant it in Privacy & Security. Apple also warns that a sandbox allowance does not defeat separate POSIX permissions, ACLs, System Integrity Protection, or data-protection rules.

The machine did not create four names for the same “no.” It created several authorities that can refuse independently.

## One request, several desks

Suppose a backup app wants to read a file in a protected location. The request looks singular in the UI. Underneath, the useful questions separate quickly.

```text
                 signed app identity
                          |
                          v
filesystem access -> sandbox/entitlement -> TCC consent
        |                 |                   |
        v                 v                   v
  mode / ACL / SIP    allowed capability   protected resource
        \                 |                   /
         +----------------+------------------+
                          |
                          v
                   attempted operation
```

The arrows are a checklist, not a published private call sequence. They show why passing one layer does not imply passing the others.

The app's code identity matters because consent cannot sensibly attach to the sentence “something called Backup asked.” The operating system needs a way to relate the approval to the responsible software. Public documentation describes access in terms of apps and user choices. This book does not pretend to publish TCC's complete private attribution algorithm.

```text
App:
the user approved Backup.

TCC:
which Backup

App:
the blue icon.

Code identity:
please step away from attribution.
```

## The prompt is not a coronation

When macOS asks whether an app may use the microphone, camera, screen recording, contacts, or another protected resource, the dialog feels dramatic because a human decision is entering a machine policy.

The user can say yes. That yes has a noun.

```text
User:
allow microphone access.

App:
I HAVE THE CONSENT OF THE GOVERNED.

TCC:
for the microphone.

App:
I will begin foreign policy.

TCC:
you will receive audio samples.
```

Consent for one category does not approve every category. Approval for one app does not become a family plan. Approval today may be changed later. A prompt is not a transfer of ownership; it is input to a scoped policy decision.

This is also why dark-pattern permission prompts are philosophically embarrassing. The software is asking the user to exercise authority, then designing the sentence to make “yes” feel like the only way out.

```text
App:
To continue enjoying Weather,
allow access to Contacts.

User:
why

App:
the button designer was unsupervised.
```

## Full Disk Access is not an entitlement you forgot to type

Full Disk Access sounds like a superuser upgrade sold in a dramatic box. It is a privacy control exposed to the person using the Mac. Apple says an app cannot grant it to itself through code or an entitlement.

```text
App:
com.apple.security.full-disk-everything = true

TCC:
no.

App:
I used XML.

TCC:
the user used System Settings.

App:
my angle brackets are valid.

TCC:
frame them.
```

Managed environments can apply some privacy preferences through device-management policy, with rules and limitations of their own. That adds an administrator or organization to the decision path; it does not prove the app authorized itself.

The installed system contains a private executable named `tccd`. Its name and presence are observable on the edition's target build. The book can use `tccd` as the clerk in dialogue. It cannot derive the complete private database schema, request routing, or identity attribution rules from the filename.

```text
tccd:
approval record?

App:
the user nodded at the screen.

tccd:
record.

App:
emotion.

tccd:
record.
```

## Three different ways to say no

> **Sidebar: Three Different Ways to Say No**
>
> **Unix credentials** ask whether the process's user and group identities satisfy discretionary file permissions and related checks. Root has exceptional power here.
>
> **An entitlement** is a signed capability claim evaluated by a component that recognizes it. Typing a private entitlement does not create an accepted issuer.
>
> **TCC approval** concerns protected resources and a user or managed policy decision associated with responsible software.
>
> A normal app with the relevant approval can sometimes complete an access that a root-run tool lacking the relevant privacy approval cannot. This does not rank the app above root. It means the app brought the credential that this desk asked for.
>
> Root can still do many things the app cannot. The app can still lose to file permissions, sandbox restrictions, SIP, or a different TCC category.
>
> Nobody has won the computer. Three offices answered three questions.

## The confused deputy at the microphone

Consent also has to survive indirection. An app may ask a helper, service, or command-line tool to act. Which software is responsible for the request can matter more than which process happened to touch the final API.

The exact attribution rules are implementation detail and change across releases. The stable editorial boundary is enough: delegation does not automatically erase the identity to which privacy policy should apply.

```text
App:
my helper asked, not me.

TCC:
on whose behalf

Helper:
I was told there would be IPC,
not philosophy.
```

If every app could route a protected request through an approved generic helper and inherit its consent, the helper would become a privacy laundering service. Systems therefore need some notion of responsibility across the request. We can state the security problem without inventing TCC's private answer for every IPC shape.

## The user leaves the room

Root can change files. Administrators can configure policy. Developers can request capabilities. Apple can define protected resource categories. None of those actors is interchangeable with the person whose microphone is about to turn on.

```text
App:
who has final authority here

TCC:
over which resource

App:
you people never answer directly.

TCC:
we answer scoped questions directly.
```

The annoying repetition is the point. Consent without an object is theater. Consent without an identity is transferable to the wrong software. Consent without an enforcement path is a checkbox describing hope.

The app gets microphone access because the relevant desks agree, including the user-facing privacy decision. It does not receive Contacts, Full Disk Access, the camera, SEP keys, or a commemorative crown.

It receives audio.

The app immediately asks why the waveform is flat.

The user has muted the microphone in hardware.

Another jurisdiction has entered the chat.


# 11. The Entitlement Bureaucracy

Every bureaucracy eventually invents a badge.

macOS puts entitlement claims inside signed code. A service or kernel mechanism that recognizes a claim can use it when deciding whether the client may cross a protected boundary.

This sounds like a universal permission system until three clerks arrive with forms.

```text
App:
I have an entitlement.

Signing authority:
who issued it

Protected service:
does it apply here

Policy:
is this claim acceptable for this code

App:
the key name was very persuasive.
```

The app has brought a signed assertion, not a small constitutional monarchy.

## A badge needs a border

An entitlement matters only where something checks it. The string `com.apple.something.impressive` does not radiate privilege into unrelated subsystems.

```text
App:
I have Bluetooth access.

Filesystem:
congratulations.

App:
open /System.

Filesystem:
try the Bluetooth door.
```

The verifier matters as much as the badge. A service can recognize one entitlement and ignore another. A kernel facility can enforce a claim without teaching every daemon what it means. A server can apply additional account, container, or request policy after the client presents an accepted entitlement.

That gives one capability at least three boundaries: the signed claim, the component that recognizes it, and the operation that component is willing to authorize.

```text
Client:
badge.

Service:
valid badge.

Client:
everything please.

Service:
you skipped the noun again.
```

## You cannot award yourself Apple stationery

Chapter 8 watched fake launchd type a private entitlement and sign the result itself. The failure was not XML syntax. The failure was issuer authority.

An ad hoc signature can bind code to its own signed claims for purposes that accept that arrangement. It does not make the signer Apple. Private platform entitlements can depend on signing, provisioning, trust, and policy conditions an ordinary third-party binary cannot create by spelling the key correctly.

```text
fake launchd:
com.apple.private.everything = true

Entitlement clerk:
issuer?

fake launchd:
me.

Entitlement clerk:
beneficiary?

fake launchd:
also me.

Entitlement clerk:
oversight?

fake launchd:
I dislike this process.
```

The word *private* is a warning about the supported contract, not a magic prefix. Copying the name out of another binary may prove you can use a text editor. It does not reproduce the conditions under which the platform accepts the claim.

## The badge census

On macOS 27.0 build `26A5425a`, the installed binaries produced this top-level entitlement census through `codesign`'s abstract output:

> **Sidebar: The Badge Census**
>
> - Console: **2**
> - MRT: **2**
> - `amfid`: **8**
> - `sharingd`: **134**
> - Safari: **194**
>
> These are build-specific top-level key counts, not a power ranking. Nested values do not add to the number. Another build may change any row.
>
> Console's two observed keys both concern private logging: `com.apple.private.logging.diagnostic` and `com.apple.private.logging.stream`. MRT's two observed keys concern MRT and managed-client configuration profiles. Safari's 194-key surface reflects an application integrating with many protected facilities. It does not make Safari ninety-seven times more sovereign than Console.
>
> Count the doors crossed, not the crowns owned.

The census is funny because it is numerically precise and constitutionally useless.

```text
Safari:
194.

Console:
2.

Safari:
I win.

Console:
I can read the logs explaining why you crashed.
```

MRT places two badges on the table and says nothing. `amfid` asks for a signature. `sharingd` arrives late because its badges required a separate tray.

## Values are part of the evidence

A top-level count throws away almost everything interesting. Entitlements can carry booleans, strings, arrays, dictionaries, identifiers, or other values. Two binaries can share a key and receive different scopes through its value.

The v0.3 `amfid` observation included an array under a private TCC allowance and another array naming an IOKit user-client class. Reporting only the key names would erase those limits.

```text
Researcher:
it has the entitlement.

Receipt ledger:
value?

Researcher:
yes.

Receipt ledger:
that was not the question.
```

This is why the raw dumps live outside the reading copy and the receipts record the extraction method. The chapter gets the joke. The evidence file keeps the brackets.

## An entitlement name is not a confession

Private entitlement names can sound like a component confessed under oath. `masquerade`. `impersonate`. `systemService`. The capital letters are practically holding a flashlight under their chin.

> **Case file: An Entitlement Name Is Not a Confession**
>
> A name proves that a signed claim with that name exists in the observed code. Its value can narrow the claim. Neither fact proves the holder invoked it, which server accepted it, what records were returned, or what the complete private semantics are.
>
> To establish behavior, we would need more: a documented contract, a trace under stated conditions, relevant request and response data, or source that actually implements the decision.
>
> The name can justify investigation. It cannot testify about events it did not observe.

```text
User:
YOU HAVE IMPERSONATE.

Entitlement:
that is my name.

User:
what did you do

Entitlement:
I am a signed dictionary entry.
```

Technical integrity is occasionally the act of refusing a much better headline.

## The narrow badge can matter most

One narrow entitlement may unlock exactly the boundary the current operation needs. A hundred broad integration badges may be irrelevant to that operation.

```text
sharingd:
accounts, radios, peers, contacts,
CloudKit, notifications—

Service:
required entitlement?

sharingd:
which one

Service:
mine.
```

Breadth is not rank. It is often paperwork generated by integration. A daemon that coordinates many systems needs credentials at many borders. The authority guarding one border may need no permission to travel because it already lives there.

This is why `amfid` can carry eight top-level keys and still ask a question that stops code. It is why MRT can carry two without becoming harmless. It is why Console's two logging keys can matter more to its job than Safari's remaining 192.

The number describes surface area. It does not describe the shape of every decision.

## The diplomat is waiting outside

Now that the badge office has explained issuer, verifier, value, and scope, we can meet the relative who abuses all four nouns simply by entering the room.

On the earlier Receipts Edition build, `sharingd` carried 132 top-level entitlement keys. On the current v0.4 observation build, it carries 134.

Two badges returned. Nobody filed a changelog with the family.

```text
Entitlement clerk:
state your business.

sharingd:
I share things.

Entitlement clerk:
that is not specific.

sharingd:
you are going to need the larger desk.
```

The next chapter does not treat those 134 claims as proof that `sharingd` used every capability. It treats them as visas: signed evidence that the daemon may approach many protected borders under conditions we still have to name.

Then `sharingd` drops the tray.


# 12. sharingd Knows a Guy

Then this motherfucker arrives.

`sharingd` first showed us 134 entitlement keys. The frozen Receipts Edition found **132**. The current v0.4 build is back to **134**.

Two badges left, returned, and still did not file a note.

That tiny disappearance is the point. Entitlement counts belong to particular builds. They are not universal constants, privacy verdicts, or rankings of royal power. Either number is still an extraordinary entrance.

The current 134-key set touches Apple Account, Bluetooth, Wi‑Fi and AWDL, HomeKit, Find My, CloudKit, IDS, Rapport, Nearby Interaction, pairing, identity, storage, contacts, notifications, and networking. It also includes exact private keys such as `com.apple.private.cloudkit.masquerade`, `com.apple.private.cloudkit.systemService`, and `com.apple.private.nsurlsession.impersonate`.

`sharingd` did not walk into the room.

It arrived with a diplomatic passport and 134 visas.

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
why do you have 134 entitlements

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

## Finding is not knowing is not sending

The Share button conceals several questions because putting all of them in the menu would make the menu the size of a tax return.

Is another device nearby? Does it advertise a compatible service? Which account or contact might correspond to it? Is the recipient eligible for this feature? Which transport can carry the payload? Will the other side accept it?

Those questions can involve overlapping machinery, but they are not one permission called `share=yes`.

```text
sharingd:
I found a device.

User:
send it the photo.

sharingd:
I said I found a device.

User:
is it my friend's device?

sharingd:
new question.

User:
can it receive this photo?

sharingd:
another new question.

User:
what did finding it accomplish

sharingd:
the finding.
```

Discovery supplies a candidate. Identity tries to attach meaning to the candidate. Policy and user choice decide whether a transfer should proceed. A transport moves bytes. Success at one desk is paperwork for the next desk, not authority over it.

This matters when reading the entitlement list. A Bluetooth-related capability may help with discovery or coordination. An account capability may help with identity. A networking capability may help reach a service. None of those names proves that the daemon can make every nearby device accept arbitrary data.

```text
Bluetooth:
someone is nearby.

Accounts:
I may know who.

Network:
I may know how to reach them.

Recipient:
no.

sharingd:
meeting adjourned.
```

The rejection at the end does not make the earlier work fake. It means the system kept its nouns.

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
*drops 134 entitlements on desk*

launchd:
I asked a yes-or-no question
```

`sharingd` crosses kingdoms wearing enough credentials to make their rulers nervous. Somewhere, quietly, `amfid` still has eight.

The count changed. The constitutional lesson did not.


# 13. Macintosh HD Is a Diplomatic Arrangement

Finder shows one disk.

APFS asks a follow-up question.

```text
Finder:
this is Macintosh HD.

APFS:
which one.

Finder:
the one called Macintosh HD.

APFS:
which one.
```

The user sees a coherent directory tree because the filesystem and operating system have agreed to present several storage jurisdictions as one place. This is useful. It is also the friendliest lie in the building.

## Which Macintosh HD?

An APFS container can hold multiple volumes that share free space. On a modern macOS startup disk, Apple documents roles for System, Data, Preboot, Recovery, and VM volumes. A volume role describes how macOS uses that volume; it does not turn the container into five independent physical disks.

```text
User:
how many disks do I have

Disk Utility:
physically, logically, visibly,
or emotionally

User:
the one on my desk

Disk Utility:
excellent, none of those.
```

The container manages shared storage. Volumes provide distinct filesystem identities and roles. Finder provides a human-facing name. The NAND controller underneath has its own opinion about physical placement and has not been invited to the sidebar.

The phrase “the filesystem” has already become plural before anybody opens a file.

## Shared space, separate trouble

Volumes in the same APFS container can draw from shared free space. That is convenient until somebody asks which volume owns the unused bytes.

```text
System volume:
I need more space.

Data volume:
from where

APFS container:
the space.

Data volume:
whose space

APFS container:
please stop bringing property law into allocation.
```

The pool can be shared while the volume roles remain distinct. A file still belongs to a particular filesystem view. A mount still exposes a particular volume or snapshot. Running out of container space can affect neighbors without merging their namespaces or protection rules.

This is another place where physical and logical ownership refuse to line up. The container accounts for capacity. The volume accounts for filesystem objects. The mounted namespace tells a process what it can reach. Finder draws a disk icon and wisely leaves the meeting.

```text
Finder:
12 GB available.

User:
where

Finder:
available.
```

## Two volumes in a very convincing coat

Since macOS Catalina, the startup arrangement separates a read-only System volume from a writable Data volume. Apple uses firmlinks to make selected Data locations appear inside the unified directory tree.

The result looks like one root filesystem to ordinary software and humans. Underneath, paths can cross from one member of a volume group to the other.

```text
Finder:
one Macintosh HD.

System volume:
operating-system content.

Data volume:
changing content.

Finder:
one.

APFS:
they are wearing a coat.
```

A firmlink is not a normal symbolic link. Apple's WWDC19 filesystem session described it as bidirectional traversal between paired System and Data locations, designed so the split remains largely invisible to software.

That distinction matters because the displayed path is not a full storage biography. `/Applications` can look like one directory in the mounted view while system-provided apps and user-installed apps belong to different underlying roles.

```text
Path:
/Applications

User:
where is that

Path:
yes.
```

## Root meets mount state

Root arrives with the traditional expectation that UID 0 owns `/System`.

```text
root:
I own /System.

APFS:
no.

root:
I am root.

SSV:
that's adorable.

root:
remount it writable.

seal:
explain yourself.
```

`SSV` and `seal` are comic voices, not independent daemons waiting behind the mount table.

Unix credentials answer whether a process may perform an operation under discretionary access rules. Mount state answers whether the mounted filesystem view permits writes at all. System Integrity Protection adds mandatory policy. The Signed System Volume adds integrity and boot acceptance.

These are not increasingly prestigious versions of the same permission bit.

```text
root:
mode bits permit write.

Mounted System view:
read-only.

root:
I outrank the bits.

Mounted System view:
I was not discussing the bits.
```

An authorized recovery procedure can change security configuration and produce a different writable situation. That does not mean an ordinary root process in the running system can turn a read-only, sealed boot view into accepted system state by shouting `mount -uw /` from memory.

## The filesystem state, plural

A snapshot records a point-in-time view of an APFS volume. Modern macOS boots from a snapshot of the System volume. Now “what is on disk?” depends on which volume, which snapshot, and which mounted view is answering.

```text
Administrator:
I changed the file.

Snapshot:
not in me.

Administrator:
you are the filesystem.

Snapshot:
I am a filesystem state with a timestamp
and excellent boundaries.
```

Snapshots are not backup magic. They share storage structures and consume space as changed data must be retained. They do, however, give the filesystem authority over time: two legitimate views can disagree about a path because they represent different states.

```text
File:
I exist.

Older snapshot:
never met you.

File:
I have an inode.

Older snapshot:
in which century
```

The joke is not that one view lies. The joke is that the user asked for *the* state.

## The seal would like a word

The Signed System Volume protects system content with a tree of cryptographic hashes whose root measurement is called a seal. On Apple silicon, Apple documents the bootloader verifying the seal before handing control to the kernel under the normal protected boot configuration.

If system bytes no longer match the authenticated structure, successfully writing them does not make them accepted boot content.

```text
root:
the write succeeded.

seal:
and the measurement?

root:
the bytes are right there.

seal:
that was not my question.
```

This is the filesystem version of signing yourself `GenuineApple™`. Possession of modified bytes is not authority to produce the Apple-accepted seal for the normal secure-boot path.

Apple allows lower-security configurations and procedures that deliberately change the protection model. Those are explicit policy transitions. They are not evidence that SSV was decorative all along.

```text
Administrator:
I changed the security configuration.

SSV:
then describe that configuration.

Administrator:
I wanted the old joke where root wins.

SSV:
historical fiction is on another volume.
```

The useful distinction is between a byte existing and a boot policy accepting a system built from it. A recovery tool can operate under authority that an ordinary process does not possess. A changed security configuration can authorize a different boot path. Neither event travels backward in time and turns the original running root shell into Boot ROM's supervisor.

```text
root:
I changed a system file.

Boot policy:
under which configuration

root:
the current one.

Boot policy:
that is a time, not an answer.
```

Filesystems preserve states. Boot policy chooses among states it is willing to trust. The path `/System` cannot explain either decision by itself.

## The path is lying politely again

> **Sidebar: `/private` has been here the whole time**
>
> Familiar macOS paths such as `/var`, `/tmp`, and `/etc` resolve through links into `/private`. This indirection predates the modern System/Data split and should not be confused with firmlinks or the Signed System Volume.
>
> ```text
> User:
> /var
>
> Filesystem:
> /private/var
>
> User:
> why hide the word private
>
> Filesystem:
> it was in the path.
> ```
>
> A visible pathname is an interface. Following it may cross a symbolic link, a firmlink-backed volume boundary, or a mount point. Similar surprise does not make those mechanisms identical.

## Namespace lies politely

The directory tree is one of computing's best user interfaces because it lets wildly different storage arrangements answer to paths. Local volumes, snapshots, firmlinks, mounted disk images, network shares, and synthetic locations can all appear under one navigable shape.

The lie is polite because the alternative is asking the user to provide a volume-group UUID before opening Downloads.

```text
User:
open my file.

Path resolver:
which mounted view

User:
the normal one.

Path resolver:
finally, an honest abstraction.
```

Three authorities remain distinct:

- A process may have permission to write.
- A particular mounted view may expose a path and permit mutation.
- The resulting filesystem state may or may not be the snapshot and seal accepted for boot.

Changing one answer does not automatically change the others. Root can possess write authority somewhere without controlling which snapshot the boot chain accepts. Finder can display one “Macintosh HD” without erasing the System/Data split. APFS can present a coherent path without claiming every byte lives on one volume.

Authority through abstraction is the friendliest form of lying in the house.

Finder closes the information window.

The disk once again appears singular.


# 14. Memory Has Borders

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

The same virtual address can appear in two processes and resolve to different physical memory, or fail in one while succeeding in the other. The number is meaningful only with the translation context that gives it jurisdiction.

```text
Process A:
0x1000 is my page.

Process B:
0x1000 is also my page.

root:
one of you is lying.

MMU:
both of them brought an address space.
```

Context switching therefore changes more than whose instructions run next. It also changes which address map the CPU uses for that execution context. The hardware does not conduct a hearing about the process's brand identity. It performs the configured translation and permission checks.

```text
Safari:
but I am a browser.

MMU:
page table.

Safari:
I have tabs.

MMU:
wrong table.
```

## Reserved, mapped, present, useful

Software says it “has memory” with the confidence of someone who has never been asked a follow-up question.

A range of virtual addresses can be reserved without every page currently having physical storage behind it. A page can be mapped but protected against a particular kind of access. The operating system can arrange backing and residency as needed. The program receives an address-space story simple enough to write code against.

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

This is the abstraction that lets the system manage finite hardware while giving processes private, orderly address spaces. The lie becomes a contract: use these addresses under these rules, and the kernel plus hardware will arrange what they mean.

Then a page fault occurs and everyone acts betrayed.

```text
CPU:
this translation needs attention.

Process:
I was promised memory.

XNU:
you were promised an address.

Process:
that feels legally distinct.

XNU:
because it is.
```

A fault is not automatically a crash. It can be part of ordinary virtual-memory work, or it can report an access the process is not allowed to make. The same hardware event can lead to very different outcomes because the policy state around the address differs.

The MMU still does not know why the page matters. It knows whether the configured translation permits the access. XNU supplies the meaning and handles the interruption. Hardware supplies the refusal quickly enough that the forbidden read does not become a memoir.

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

Unified memory also does not abolish scarcity. CPU and GPU avoiding needless copies can be a large win, but they still contend for finite capacity and bandwidth. One pool reduces some borders. It does not repeal scheduling, synchronization, storage modes, or the possibility that everybody wants the same resource at once.

```text
GPU:
I need six gigabytes.

CPU:
I also need six gigabytes.

Unified Memory:
you have correctly identified twelve gigabytes of desire.

Memory Controller:
I traffic in service, not desire.
```

The memory controller does not award bandwidth based on Unix seniority. It arbitrates hardware requests under hardware rules. Root can influence workloads through software. Root cannot attach a résumé to each DRAM transaction.

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

DMA removes the CPU from carrying each byte. It does not remove the operating system and IOMMU from deciding which buffers the device can address.

```text
Device:
I can access memory directly.

DART:
directly through this map.

Device:
that feels less direct.

DART:
security often does.
```

The map can be narrow and temporary. A driver can arrange access for a buffer needed by one operation without turning the device into a co-owner of physical memory.

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

The complete dispute fits on one napkin:

```text
process virtual address
        |
        v
   CPU MMU map ---------> physical memory

device-visible address
        |
        v
  IOMMU / DART map -----> permitted physical memory
```

The two arrows can land on the same physical pages when software deliberately arranges it. They do not use the same address vocabulary merely because both eventually reach DRAM.

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

Arbitration is another authority that sounds larger than it is. The controller can decide whose transaction proceeds and when. It does not decide whether Safari deserved the page or whether a DMA request was morally justified.

```text
Memory Controller:
GPU, then CPU, then ANE.

CPU:
why

Memory Controller:
traffic.

CPU:
I am the Application Processor.

Memory Controller:
application denied until ticket 43.
```

XNU sets policy. MMU and DART enforce mappings. The memory fabric arbitrates traffic.

The DRAM cells store charge and have never heard of root.


# 15. SEP Has a Mailbox

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

## SEP checks its own boot paperwork

Apple documents a separate Secure Enclave boot process. On startup, the Application Processor supplies the sepOS image to the Secure Enclave Boot ROM. The Secure Enclave side checks the image's cryptographic hash and signature before allowing sepOS to run.

The AP can deliver the candidate image. It cannot turn delivery into acceptance.

```text
Application Processor:
sepOS image.

SEP Boot ROM:
signature.

Application Processor:
I brought it personally.

SEP Boot ROM:
that is a transport fact.
```

This is an exquisite insult to XNU. The main processor participates in getting the secure operating system to the border, then a separate immutable authority checks whether that operating system is authorized for the Secure Enclave.

```text
XNU:
I helped boot you.

SEP:
you delivered a package.

XNU:
without me you would not have it.

SEP:
without my Boot ROM I would not run it.
```

Precedence did not disappear. It split. The AP boot chain has authority over its handoffs. The Secure Enclave has its own root of trust and protected execution path.

## The mailbox

The Application Processor and SEP need a way to communicate across their boundary. Asahi Linux's public SEP documentation identifies a SEP mailbox, gives a mailbox base for documented reverse-engineering targets, and shows traced messages moving between AP-side software and SEP endpoints.

That is enough to use the word *mailbox*. It is not permission to invent private opcodes, payload meanings, or authorization semantics beyond what the reverse-engineering evidence actually establishes.

The boundary map is deliberately boring:

```text
Application Processor software
             |
             v
   mailbox-style messaging
             |
             v
       SEP software
             |
             v
protected keys and operations
```

The arrows prove that messages can cross the boundary on documented reverse-engineering targets. They do not prove that any invented request exists or that SEP will approve it.

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

> **Sidebar: The Mailboxes Are Not Related**
>
> `/var/mail` belongs to Unix mail conventions. The SEP mailbox is hardware messaging observed through Apple-silicon reverse engineering. They share an English noun and none of the authority.
>
> ```text
> fake launchd:
> cp request /var/mail/sep
>
> SEP:
> no.
>
> fake launchd:
> SMTP?
>
> SEP:
> somehow more no.
> ```
>
> A mailbox can hold letters, messages, hardware words, or one increasingly tired metaphor. Always ask which mailbox.

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

A reply does not necessarily contain the secret either. SEP can perform an operation and return a result while keeping key material inside its protected domain. “The request succeeded” and “the AP received the long-lived key” are different claims.

```text
XNU:
did you use the key

SEP:
yes.

XNU:
give me the key

SEP:
you already received the answer.

XNU:
I want the authority behind it.

SEP:
that is why you received the answer.
```

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


# 16. The Civil War

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


# 17. The House Inside the House

After the Civil War, the book returns to technically defensible ways of putting software somewhere it was not born.

This time we use documented frameworks instead of Efeali typing `send`.

```text
Efeali:
I have another idea.

SPTM:
no.

Virtualization.framework:
I will handle this one.
```

A virtual machine lets one computer host another computing world. Inside that world, a guest kernel can create processes, manage guest memory, and govern guest devices. Outside it, the host still owns the resources that make the world possible.

A kernel can be sovereign in the house and still rent the house.

## Two frameworks, different altitudes

Apple's Hypervisor framework provides lower-level APIs for hardware-assisted virtualization. Apple's documentation describes virtual machines and virtual CPUs, with a VM represented in the host process and virtual CPUs associated with threads.

Virtualization.framework operates at a higher level. It provides configuration and lifecycle APIs for complete virtual machines, including supported macOS and Linux guests on Apple silicon.

```text
Developer:
I need a virtual CPU.

Hypervisor.framework:
how many

Developer:
I need a Mac.

Virtualization.framework:
finally, a different question.
```

The first framework is closer to CPU and memory machinery. The second helps assemble machines from configured devices, storage, networking, boot material, and guest resources. “Higher level” does not mean more privileged. It means the abstraction accepts a larger noun.

```text
Hypervisor.framework:
virtual processor state.

Virtualization.framework:
virtual machine configuration.

Developer:
which one is in charge

Both:
of what
```

We will stop here. Anyone attempting to introduce thirty pages of processor-control trivia will be placed in a guest with no network adapter.

## The nested jurisdiction map

The whole chapter fits in one diagram:

```text
host macOS
  |
  +-- host process + Apple virtualization frameworks
          |
          +-- virtual CPUs, guest memory, virtual devices
                  |
                  +-- guest kernel
                          |
                          +-- guest processes and services
```

The arrows mean “constructed from and constrained by,” not “the host personally performs every guest operation.” Once running, the guest kernel can schedule guest threads, expose guest filesystems, and enforce guest policy without asking the host to interpret every system call.

The host decides how much memory and how many virtual CPUs the VM receives. The guest decides what to do with the resources it sees.

```text
Guest kernel:
I manage all memory.

Host:
all 8 gigabytes I assigned you.

Guest kernel:
I did not request the adjective.

Host:
it was a number.
```

That is not fake authority. The guest's decisions are real inside the guest. A guest process that violates guest page protections does not escape punishment because the memory ultimately belongs to the host machine.

Jurisdictions can nest without becoming imaginary.

## The devices are convincing employees

A complete VM needs more than a CPU-shaped object. Virtualization.framework exposes configurations for storage, networking, displays, entropy, memory balloons, directories, and other devices depending on guest and platform support.

To the guest, those devices can look like the machine's hardware. To the host, they are resources mediated through the VM configuration and implementation.

```text
Guest:
my disk.

Virtual disk:
your blocks.

Host file:
my bytes.

Physical storage:
whose NAND

Everyone:
not now.
```

The abstraction is useful precisely because the guest does not need the host's full storage biography. It receives a device contract. The host remains able to stop the VM process, remove backing resources, or refuse a configuration the framework will not accept.

Inside the VM, `fsck` can feel like emergency government. Outside, the disk may be one file with a Finder tag.

## The abandoned apartments

> **Sidebar: rings 1 and 2**
>
> People often learn x86 privilege as four numbered rings, then discover that mainstream operating systems mostly built their lives around the most-privileged kernel ring and the least-privileged user ring.
>
> ```text
> Ring 1:
> I could have been somebody.
>
> Ring 2:
> we had floor plans.
>
> Ring 3:
> the apps are loud again.
> ```
>
> Apple silicon uses Arm's exception-level model rather than x86's ring vocabulary. The abandoned-apartment joke is historical shorthand, not an explanation of Apple virtualization. We are leaving before somebody brings a whiteboard to dinner.

## Root inside the guest

Root enters the virtual machine and immediately recognizes the furniture.

```text
guest root:
I own this machine.

Guest kernel:
within guest policy, mostly.

Host user:
pause.

guest root:
why did the universe stop
```

The host user does not become guest root by pausing the VM. Guest root does not gain host file access merely because its UID is zero. Each has authority over an object the other does not govern in the same way.

```text
guest root:
mount the host filesystem.

Virtualization.framework:
was a shared directory configured

guest root:
I am root.

Virtualization.framework:
in the PDF attached to your lease.
```

When the host exposes a shared directory or virtual network device, it creates an explicit bridge. The bridge has configuration and policy on both sides. It does not erase the boundary any more than a mailbox makes two houses one property.

## A world can be a process

From inside, the guest has boot, PID 1, users, daemons, filesystems, and perhaps its own argument about who owns the windows.

From outside, Apple documents the Hypervisor framework's VM as living in a user-space process. The whole guest civilization can therefore be contained by an object the host kernel schedules and can terminate.

```text
Guest launchd:
hello children

Host XNU:
one process.

Guest XNU:
I am literally the kernel.

Host XNU:
that is adorable.
```

The guest kernel's authority remains real. It is simply not the broadest authority relevant to its continued existence.

Privilege can end a world without understanding it. In virtualization, the world may have its own kernel, government, shutdown sequence, and strong views about this characterization.

## The lease remains upstairs

Virtualization is authority through abstraction with the paperwork left visible. The guest receives convincing processors, memory, and devices. The host keeps the resource boundary. Neither description cancels the other.

```text
Guest kernel:
I govern the machine.

Host:
you govern a machine.

Guest kernel:
same thing.

Host:
the indefinite article is in the lease.
```

There is one more consequence, but it belongs at the end of the book.

For now, everyone is invited to dinner.

This is a mistake.


# 18. The Hardware Family Dinner

The mistake was inviting everyone.

Until now, the family has argued in departments. Boot authorities left before XNU arrived. Session officials spoke to graphics. SEP stopped answering follow-up mail.

Now everybody is seated at one table.

This is the **hardware family dinner**.

There is a place card for every jurisdiction and no place card labeled *boss*.

SEP has requested not to sit beside launchd after the incident in Chapter 16.

```text
launchd:
that chapter was not canon.

SEP:
you reorganized my services.

launchd:
fictionally.

SPTM:
I filed an objection.

iBoot:
personal matters.
```

Efeali's place card has been replaced with **DO NOT GIVE THIS PERSON A TRANSPORT VERB**.

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

## Security brought six separate clipboards

The executable from Chapters 8 through 11 attempts to enter carrying one folder labeled **APPROVED**.

```text
Gatekeeper:
approved for first open.

Signature machinery:
valid code identity.

XProtect:
no current known-malware match.

TCC:
microphone denied.

Entitlement clerk:
HomeKit claim accepted.

Executable:
can one of you stamp the folder

Everyone:
which page
```

Root sees six officials and assumes a management vacancy.

```text
root:
I will supervise security.

Gatekeeper:
policy résumé?

TCC:
user consent?

amfid:
signature?

root:
I regret approaching this table.
```

The officials are not six ranks in a chain. They ask about different objects: code identity, arrival policy, malware knowledge, protected resources, signed capabilities, and enforcement. The app can satisfy five and still lose to the sixth without anybody contradicting anybody.

This makes security architecture difficult to summarize and extremely easy to turn into a dinner where everyone brought their own stamp.

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

## APFS brought two dishes under one lid

Finder places **Macintosh HD** in the middle of the table.

```text
Finder:
one casserole.

System volume:
do not modify my side.

Data volume:
the vegetables are over here.

Finder:
one casserole.

APFS:
firmlink the gravy.
```

Root reaches for `/System`.

```text
root:
I am serving myself.

Mounted view:
read-only.

root:
I own the spoon.

seal:
explain the measurement afterward.
```

The seal is not a daemon and has not eaten. It still manages to make root put the spoon down.

Across the table, Storage Controller quietly moves the physical peas while preserving their logical block addresses. APFS notices and decides dinner is better without complete implementation transparency.

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

## The guest asks where the house ends

Virtualization.framework arrives with a smaller table containing another operating system, another kernel, another root user, and an argument already in progress.

```text
Guest root:
I control this machine.

Guest kernel:
within my policy.

Host XNU:
within one process I schedule.

Application Processor:
on my processor.

Dinner host:
we needed fewer nesting dolls.
```

The guest asks for more memory. The host offers a configuration change. The Memory Controller hands both of them ticket numbers.

No participant is pretending the guest's authority is fake. They are enjoying how many landlords can fit above one confident UID 0.

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

Gatekeeper:
downloaded-software policy.

syspolicyd:
policy verdicts.

XProtect:
known-malware detection and remediation.

TCC:
protected-resource consent.

Entitlement clerk:
signed capability claims.

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

APFS:
volumes, files, snapshots.

seal:
boot-accepted system integrity.

Display Controller:
actual scanout.

Guest kernel:
this entire list, but inside.
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

XNU attempts one final hardware flex, now with the correct inventory for the author's machine.

```text
XNU:
I HAVE TEN CPU CORES.

SEP:
turn them off then.

XNU:
...

SEP:
all ten.

XNU:
fuck you.
```

The ten-core count belongs to this 10-core M4 Mac, not every Mac and not every chip sold under the M4 name. The strategic outcome is unchanged. Turning off all ten cores also ends XNU's participation in the argument.

```text
SEP:
I only need one processor
to watch you turn yours off.
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


# 20. One More Jurisdiction

We began with a useful lie: hardware at the bottom, kernel above it, userspace above that, and the purchaser floating near the top like a minor deity with AppleCare.

We end with a better picture.

Authority is always authority *over something*.

Boot ROM establishes the first trust in a boot chain and then leaves the argument.

XNU governs kernel execution on the Application Processor.

launchd organizes userspace services.

`loginwindow` coordinates authenticated session creation.

WindowServer governs a graphical environment.

Code-signing machinery establishes code identity. Gatekeeper and `syspolicyd` evaluate policy. XProtect brings time-dependent malware knowledge. Enforcement makes their answers consequential.

TCC asks for consent over protected resources. Entitlements carry signed capability claims to the borders that recognize them.

`sharingd` crosses an alarming number of protected boundaries in order to know a guy.

APFS presents System and Data volumes in one convincing coat. Snapshots make filesystem state plural. The seal asks whether changed system bytes belong to a boot-accepted state.

The MMU and DART make memory borders physical.

The GPU renders. ANE tensors. Storage translates. The display emits. The memory controller takes a number.

SEP protects a separate security domain and answers kernel privilege with the most devastating prepositional phrase in the book:

> On your processor.

Root remains powerful.

Fake launchd remains UID 2.

LaunchAngel remains unexplained.

The Civil War remains impossible. Its evidence note is the only participant whose authority survived the incident.

A guest kernel can govern a whole virtual world while the host schedules that world as a process.

The purchaser owns the machine in the ordinary human sense and can still lose an argument with a checkbox. Ownership authorizes enormous choices: erase it, recover it, lower a security policy through the proper path, install another system, or introduce it to gravity. It does not make every running protection mechanism interpret “I paid for this” as an access token.

```text
User:
I own this Mac.

Mac:
absolutely.

User:
then give me the key.

SEP:
which key.
```

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

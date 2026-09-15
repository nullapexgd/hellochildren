# On Your Processor

## A Field Guide to the Dysfunctional Family Living Inside Your Mac

### v0.7 — Expanded Jurisdiction Edition

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


# Part I — Who Let You Run? {#part-i .part-title}

Before anyone can rule the machine, somebody has to let them exist.


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

## OIK owns one noun

Apple calls access to the **Owner Identity Key (OIK)** “Ownership.” That ownership is required to let users re-sign LocalPolicy after policy or software changes. The OIK is normally protected by user passwords and measurements of the operating system and policy.

This is ownership authorization for a particular boot-policy job, not universal machine ownership. It is not a daemon, the oracle of every code signature, or AMFI’s manager wearing a key-shaped crown.

```text
OIK:
I speak for the owner here.

root:
finally.

OIK:
about this LocalPolicy.

root:
there's always a noun.
```

That is as far as documented ownership goes. Chapter 5 will now misuse the family metaphor with professional confidence.

## The other processors have childhoods too

Apple also documents peripheral processors whose firmware may be verified after loading from the primary CPU or by a separate secure-boot chain. The main boot story therefore opens more than one execution world. Chapter 21 will meet the relatives who were never ordinary launchd jobs.

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

```text
XNU:
I can destroy the entire userspace.

launchd:
congratulations on having a demolition permit
```

Destructive authority is not service organization.

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

## The boot family files a claim

`iBootd` is fictional. Apple does not ship a component by that name. We invented it after fake launchd had already demonstrated that a name does not confer office.

SEP introduced the newcomer to real iBoot as if the family resemblance settled anything.

```text
SEP:
iBoot, meet iBootd.

iBoot:
what is that

SEP:
you but persistent.

iBoot:
I take that personally.

iBootd:
I kept the d.

XNU:
appending d to a boot component
does not create a daemon.
```

The objection was technically correct and therefore useless at family court.

```text
iBootd:
iBoot is my parent.

iBoot:
I handed off a boot stage.
I did not have a child.

SEP:
you have the same face.

XNU:
none of those statements define process parentage.
```

Boot-stage handoff, Unix process parentage, and the invented family relationship are three different relations.

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


# Part II — The Offices Upstairs {#part-ii .part-title}

Userspace looks orderly until every office presents a different badge.


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

### CoreAuthentication left its verbs in the lobby

The installed `coreauthd` binary is less shy about nouns than it is about architecture. On this edition's macOS 27.0 build, its embedded Objective-C selector strings include `evaluatePolicy:options:uiDelegate:reply:`, `checkCredentialSatisfied:policy:reply:`, `findMechanismForEvent:mustBeRunning:plugin:`, and `authenticationSuccessfulForEvent:reply:`.

Those are real names. They are also not a sequence diagram. A selector can show that code has vocabulary for policies, credentials, mechanisms, events, UI delegation, and replies. It cannot tell us which caller used it, which branch ran, or which private protocol joined the pieces during this login.

```text
coreauthd:
policy.
credential.
mechanism.
event.

root:
which one makes me authenticated

coreauthd:
you have mistaken my vocabulary
for your outcome.
```

This is the evidence rule in miniature: quote the names, keep their punctuation, and decline to write fan fiction in the colons. CoreAuthentication can help evaluate an authentication request without becoming the owner of the account, the creator of the session, the keeper of every credential, or the artist responsible for the wallpaper.

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

### The export table has entered the chat

The installed binaries on this edition's target build are willing to provide name tags. SkyLight exports `_SLSMainConnectionID`, `_SLSGetWindowOwner`, `_SLSOrderWindow`, `_SLSCopyManagedDisplaySpaces`, `_SLSSetWindowAlpha`, and `_SLSSetWindowLevel`. CoreGraphics exports `_CGWindowListCopyWindowInfo`, `_CGDisplayBounds`, `_CGMainDisplayID`, `_CGEventCreate`, and `_CGDisplayRegisterReconfigurationCallback`.

That is an excellent list of verbs and a terrible constitution.

```text
Researcher:
I found SLSGetWindowOwner.

SkyLight:
good.

Researcher:
so I understand window ownership.

SkyLight:
you understand one exported name.
```

The names support the chapter's geography: connections, windows, ordering, Spaces, display bounds, events, and display reconfiguration are separate objects and operations. They do not reveal every accepted argument, authorization check, daemon boundary, side effect, or promise across releases. `_SLSGetWindowOwner` is evidence that somebody can ask an ownership-shaped question. It is not a deed to the window.

Brightness provides an even cleaner jurisdiction fight. CoreBrightness exports names including `_CBALCGetDisplayAutoBrightnessEnabled`, `_CBALCSetDisplayAutoBrightnessEnabled`, and `_CBALCALSCopyALSServiceClient`. DisplayServices separately exports `_DisplayServicesCanChangeBrightness`, `_DisplayServicesGetAuthorized`, `_DisplayServicesGetBrightness`, `_DisplayServicesSetBrightness`, `_DisplayServicesEnableAmbientLightCompensation`, and `_DisplayServicesCommitSettings`.

```text
App:
set brightness.

DisplayServices:
can change?

CoreBrightness:
auto brightness enabled?

Ambient light sensor:
I have context.

App:
I had a slider.
```

Even the symbol names refuse to collapse capability, authorization, current value, automatic policy, ambient-light input, and committed settings into one knob. We quote them because they are real. We stop there because names are evidence of vocabulary, not complete semantics.

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

## Different objects, same argument

The Owner Identity Key arrives from the boot-policy side of the building. Apple calls access to it Ownership: the authority an owner uses to re-sign LocalPolicy after policy or software changes.

AMFI is occupied with code-signing enforcement and trust. This gives both offices excellent material for an argument and no common answer to the question of rank.

```text
OIK:
Ownership permits a user to re-sign LocalPolicy.

AMFI:
I am asking whether code satisfies
its signing and trust requirements.

OIK:
so I outrank you.

AMFI:
for which of those two questions

OIK:
the important one.

AMFI:
that is still not an object.
```

They cannot rank each other because they are discussing different objects. One statement concerns owner-authorized LocalPolicy. The other concerns code identity, trust, and enforcement.

Both offices are real. Their personal beef, this meeting, and any suggestion that one reports to the other are dramatization.

## The extra `d`

`amfidd` is fictional. `/usr/libexec/amfid` is real and already documented in this book; the extra `d`, the genealogy, and the personality belong to *On Your Processor*.

The family explanation is that launchd plus Gatekeeper produced bureaucracy, but raised it in a loving home.

```text
launchd:
I know him.

amfidd:
noted.

Gatekeeper:
developer cannot be verified.

amfidd:
also noted.

SEP:
I know him too.

amfidd:
okay that's actually pretty compelling.

Gatekeeper:
THAT IS NOT HOW CODE SIGNING WORKS.

launchd:
that's my boy 🥹
```

`amfidd` is cryptographically rigorous and socially vulnerable. Acquaintance is not a trust primitive. That is the architectural punchline.

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

Chapter 8's fictional `amfidd` tries one more source of evidence.

```text
amfidd:
launchd knows him.

Gatekeeper:
and which first-open policy did that evaluate

amfidd:
the familiarity policy?

Gatekeeper:
there is no familiarity policy.
```

The correction names the missing question. Familiarity is not a policy verdict; Gatekeeper still has to evaluate the arrival under the policy that applies to it.

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

On the earlier Receipts Edition build, `sharingd` carried 132 top-level entitlement keys. On the later observed build, it carries 134.

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

`sharingd` first showed us 134 entitlement keys. The frozen Receipts Edition found **132**. A later observed build is back to **134**.

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

This chapter owns discovery, identity, policy, and the decision to send. Chapter 22 takes the resulting bytes from a socket through protocol and interface boundaries toward a network that has never heard of `sharingd`'s reputation.

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


# Part III — Names, Bytes, and Addresses {#part-iii .part-title}

The same object acquires a new identity at every desk it crosses.


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

Here, “the write succeeded” concerns altered system content and boot acceptance. Whether those bytes survive a power failure is a separate question. A recovery tool can operate under authority that an ordinary process does not possess. Neither event travels backward in time and turns the original running root shell into Boot ROM's supervisor.

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

## Namespace lies politely

The directory tree lets the System and Data volumes appear as one navigable place. That saves the user from providing a volume-group UUID before opening Downloads. The visible path still leaves mount state and boot acceptance to their respective offices.

Authority through abstraction is the friendliest form of lying in the house.

Finder closes the information window.

The disk once again appears singular.


# 14. Your File Does Not Exist

The title is something a filesystem might say during a difficult breakup. It needs a qualification: the name you supplied might no longer identify anything, while the file you already opened remains perfectly usable.

Computing has found a way to make “it's over” depend on reference counting.

## The name at the door

`/Users/efeali/book.txt` looks reassuringly specific. It has slashes. It has a surname. It ends in a format modest enough to survive several generations of software ambition.

It is a pathname: instructions for finding something through a directory tree. A directory entry associates a name with a filesystem object. The object supplies the contents and attributes; the name is how a lookup gets there. Several names can refer to the same regular file through hard links, so the name cannot also be its one true soul.

```text
File:
my name is book.txt.

Directory:
that's what I call you.

Other directory:
I call him final-final.txt.

File:
please don't introduce me like that.
```

Lookup has a starting place. An absolute pathname begins at the process's root; an ordinary relative pathname starts at its current directory. `openat` can instead start a relative lookup from a directory descriptor. The short name `book.txt` leaves quite a lot of the address on the envelope blank.

The route can also contain indirection. Familiar macOS paths `/etc`, `/tmp`, and `/var` lead through symbolic links into `/private`. The user can spend years navigating these paths without noticing the extra component.

```text
User:
/var

Filesystem:
/private/var

User:
why hide the word private

Filesystem:
it was in the path.
```

A symbolic link supplies another path to follow. A firmlink joins the paired locations from the previous chapter. A mount point exposes another filesystem. The tree makes them convenient to traverse without making them the same mechanism.

macOS even supports a limited set of synthetic links and empty directories at the root, described by `synthetic.conf` and constructed during boot. A synthetic empty directory can provide a mount point; it is not an ordinary writable folder waiting to receive children. Being visible in a listing is a remarkably small job description.

## Open after disappearance

Suppose a program successfully opens our ordinary local text file for reading. It receives a file descriptor, a small integer in that process's table of open references. We'll call it `7`.

The integer refers to an *open file description*, the open instance with such state as its access mode and current offset. That description refers to the file. The distinction becomes less bureaucratic when the directory starts deleting things.

Another process successfully calls `unlink` on the file's last name. The directory entry disappears. A fresh attempt to open that pathname, without asking to create it, now fails because the name is absent.

Our first program can keep reading through descriptor `7`.

```text
Directory:
he no longer works here.

Reader:
I'm talking to him.

Directory:
then please stop using reception.
```

Removing the last link postpones removal of the file's contents while open references remain. This is ordinary Unix file lifetime, assuming the unlink succeeds. It is not a special undelete privilege and doesn't need the Trash to intervene. A graphical application's Delete command may have a different workflow; `unlink` is the specific operation at this meeting.

Now create a new file under the old name. New lookups can reach the replacement. The first reader still holds the earlier object, which has not been promoted into the replacement merely because the two share a former address.

That gives us a perfectly respectable state of affairs in which one reader sees the old draft and a newly opened reader sees the new draft. Both can truthfully say they opened `book.txt`. Their opening times matter.

Nor is `7` permanent identification. Closing it releases that descriptor slot for reuse. A later open may return `7` for something else. Writing the number on a sticky note does not preserve the relationship.

There can also be several descriptors for one open description: duplicating a descriptor shares its current offset, whereas opening the file separately creates a separate open instance. Two bookmarks can therefore turn out to be the same bookmark. Unix has been doing collaborative editing to people's file positions for decades.

## Which version exists

An open reference preserves access to an object through a name change. It does not freeze the object's contents. If someone modifies that same live file, keeping it open is not a request to retain yesterday's paragraphs.

A snapshot supplies a different kind of continuity. It records a read-only volume view at a particular time. Imagine a Friday snapshot containing the old draft. On Saturday the live volume's draft changes. Reading the snapshot and reading the live volume can give different contents under corresponding paths without either read being wrong.

```text
Live file:
I've grown.

Friday snapshot:
you still think this needs a blockchain.

Live file:
THAT WAS A WORKING DRAFT.
```

The same distinction covers absence. A file created after Friday's snapshot can exist in the live view and have no entry in Friday's view. A file removed from the live view can still appear in a retained earlier snapshot. Closing the last live open reference doesn't order every snapshot to forget its own state, and logical removal isn't a physical-erasure certificate.

Mounts add a question about where the reader is standing. Mounting a filesystem at a directory normally exposes the mounted filesystem's contents there and hides the directory's previous contents until unmount. The covered files have not been deleted. Their usual route is occupied.

```text
User:
this directory used to have my notes.

Mount point:
this entrance now serves another building.

User:
did you demolish the first one

Mount point:
we put up a sign.
```

A mounted disk image or network share can inhabit the same tree as local storage. The slash does not announce that the next operation will have a different failure mode. It certainly doesn't promise that a remote server obeys the local filesystem's every lifetime detail.

This is why “I can see it” and “my program can't open it” need an actual path and context before becoming an argument. There may be a permission failure, a changed name, or a different mounted view. An error return is evidence about that attempted operation, not a census of all the world's copies.

## The storage department objects

XNU would like to get on with the read.

```text
XNU:
read /Users/efeali/book.txt.

SSD:
what's a Users

XNU:
...

SSD:
what's a file
```

This is dialogue about the filesystem/block-storage boundary, not a trace of a command XNU sends. By the time an ordinary file read needs storage I/O, software has work to do turning its request into something that the storage interface can service.

Darwin's virtual filesystem machinery, or VFS, gives different filesystems a common set of ways to participate in the kernel's file operations. A vnode is the kernel's representation of an active file or directory. Filesystem-specific code supplies the operations and the knowledge of that filesystem's structures.

The vnode isn't another spelling of the pathname, the application's descriptor, or a physical spot in flash. It is useful to the kernel because it represents an object the kernel can work with. It doesn't need a tiny folder icon to accomplish this.

```text
Application:
my document.

VFS:
file operation.

Filesystem:
I can work with that.

SSD:
finally, somebody will send something usable.
```

Flash introduces its own translation. Apple's APFS documentation describes a flash translation layer that can group writes into NAND blocks; separate logical locations do not let the caller dictate exact physical placement. The bytes don't retain a little `/Users` badge that the controller consults while deciding where to put them.

None of this makes the file imaginary. It makes the file a software object whose storage depends on other representations. The SSD character's offense is that the introductions have arrived several abstractions too early.

## Existence needs a noun

Our draft can now have a missing name, a surviving open reference, and an earlier version in a snapshot. A replacement can take its old pathname while an existing reader finishes the original. The storage beneath those views is still doing storage, without becoming the arbitrator of which draft the author meant.

For the author, “the file” is the manuscript. For a particular read, it is the object reached by that reference in that view. The disagreement usually stays invisible because the layers cooperate. It becomes visible exactly when someone insists that renaming, deleting, replacing, opening, and retaining a version must all mean the same thing.

```text
Author:
fine. this object, through this reference,
in this view.

XNU:
beautiful.

Author:
please save these bytes.

XNU:
we've reached a different problem.
```


# 15. Please Wait, I’m Writing

## The Save button has made an announcement

The author presses Save. A dot disappears from the window title. This is the most reassuring punctuation event in computing.

Somewhere beneath it, a much less reassuring discussion concerns the word *done*.

```text
Application:
saved.

User:
so I can relax.

Application:
I have updated the interface.

User:
that wasn't the part I was worried about.
```

An application's Save command has whatever contract that application gives it. It might wait for a completed storage operation, delegate to a document framework, or announce progress while work continues. The button's appearance alone tells us none of that. Our example will follow ordinary buffered output to a local regular file; other routes exist, and nobody is required to visit every desk here.

The application first has bytes it wants to store. It may also have an output buffer in its own process. A library can accept output into that buffer without having sent all of it through a system call yet. For a C output stream, `fflush` pushes buffered data through the stream's underlying write function.

That is useful progress. It is also a reason to ask where a buffer lives before declaring that it has been flushed. Emptying an application buffer and emptying a storage device's volatile cache are different work, even though both get the same gratifying verb.

```text
Application buffer:
empty.

User:
the data is safe?

Application buffer:
the data has left me.

User:
you sound like my shipping notification.
```

A crash before the program submits buffered output can lose work that never reached the filesystem. That is an earlier failure than losing submitted data during a power cut. The distinction matters because asking the filesystem to finish cannot recover bytes the application has not handed it.

## Accepted is not completed

At the system-call boundary, `write()` attempts to write a specified number of bytes through a descriptor. Its successful result is a byte count. That number deserves to be read.

Under the interface's permitted conditions, a write can transfer fewer bytes than requested. The program must handle the actual result and any error rather than translating “returned something nonnegative” into “the whole chapter is safe.” We'll give our example the easier case: the requested count came back in full.

```text
Application:
4096 bytes, please.

write():
4096.

Application:
forever?

write():
you passed a size, not a prophecy.
```

The success has real meaning. In the ordinary regular-file model, a subsequent successful read of those positions sees the new data until it is modified again. The current file state has changed. Calling that merely an illusion would erase the very contract that lets programs exchange data through files.

But a read can obtain the current bytes while storage work remains. Seeing the new contents in another window, or reading them back immediately, does not simulate losing power. The machine is still powered, with its useful temporary state intact.

Filesystem work includes more than carrying the paragraph's bytes downward. It must maintain the information that makes those bytes reachable as part of a file: contents, size, allocation, and whatever bookkeeping the operation requires. The exact work depends on the filesystem and operation. There is no single procession in which every Mac writes the same structures in the same order.

Apple describes APFS crash protection using copy-on-write. A filesystem can protect its structural consistency and still recover a state older than the application's latest intention. A perfectly readable previous draft is a consistent filesystem's way of ruining your afternoon.

In our example, a successful ordinary write establishes the updated file state. A durability request asks for more: finish the relevant work under a contract that reaches the required storage boundary. The pause between those promises can be productive batching, until the author starts leaning toward the power button.

## Close is not a sworn affidavit

`close()` releases a descriptor. On the last relevant reference it also permits cleanup of the open instance. The file doesn't need a reader to stay named in its directory; the name and open lifetime were separate in the previous chapter, and they remain separate when a writer leaves.

```text
Application:
I closed it.

Filesystem:
thank you for returning the key.

Application:
so the building is earthquake-proof.

Filesystem:
what
```

Close can report an error from previously uncommitted output. That is one reason its result matters. Successful close, however, is not a documented demand that the device flush all its buffered writes into permanent storage.

When a process exits, its descriptors are freed. Even a clean exit therefore tells us about the process finishing; by itself it cannot certify durable storage. Keep that distinction handy for the evening when XNU decides to dismiss the entire staff.

`fsync` is a more pointed request. On macOS, its manual describes moving modified data and attributes from the host to the drive. The same manual warns that a drive may still buffer or reorder writes, leaving some or all of the data unwritten after power failure. It uses platter-era language, but the host/device distinction isn't abolished by replacing a spinning disk with flash.

For the stronger operation, macOS provides `fcntl` with `F_FULLFSYNC`. The installed manual describes an fsync followed by a device flush request. Its stated guarantee concerns data previously fsynced on that same device: “data that had been fsync'd on the same device before is guaranteed to be persisted when this call returns.”

That sentence has a subject, a scope, and a completion point. APFS is among the documented supported filesystems. The call can take time, and an error result cannot be treated as success.

```text
Application:
why are we waiting

F_FULLFSYNC:
because you asked a stronger question.
```

## The controller has its own inbox

“The device completed it” sounds final until we ask what *it* was. A normal write completion and completion of a flush request need to be interpreted under their respective contracts. The word *completion* doesn't silently append “through any future loss of power” to every operation.

Device buffering helps explain why software asks for a stronger boundary. A device can have accepted data that still depends on power. To demand persistence, the request has to cover that remaining work, and the device has to honor the request.

Apple's full-sync manual even retains a warning about certain FireWire drives ignoring flush requests. That is a warning about those devices, not a discovery that the Mac's internal SSD is lying. It does explain why a documented request and compliant hardware both belong in the sentence about guarantees.

```text
Controller:
completed.

Application:
the write or the flush

Controller:
look at your request.

Application:
I named it saveFinalReallyFinal.

Controller:
that did not reach this department.
```

Below the filesystem, flash translation also prevents an application from assigning every byte a permanent seat in NAND. Persistence is about being able to recover the required data under the storage contract. It does not require that the application know which physical cells currently hold it. A controller's internal placement work is not a file manager with smaller icons.

The exact hardware can change while the host's buffers and the device's pending work remain separate concerns. The application's receipt has to cover the work it is relying on.

## Please survive the lights going out

There is another problem even after the individual writes acquire respectable receipts. Suppose an application stores a balance in one record and a corresponding history entry in another. It wants both changes to represent one completed transaction. Persisting only one can leave durable bytes describing an incomplete application operation.

The filesystem can be healthy while the application's accounts disagree. The application needs a protocol that makes its own group of changes recoverable. Naming every operation “Save” does not supply that protocol.

```text
Filesystem:
the records are readable.

Application:
they disagree about where the money went.

Filesystem:
I preserve your writing.
I don't do your books.
```

For a document, replacing the old file with a newly written file creates a related boundary. A name replacement can give readers an orderly transition between objects. That namespace behavior alone doesn't establish that the replacement's payload has reached permanent storage. The writer still needs the appropriate persistence operations and error handling for its chosen save method. There isn't a universal two-line recipe hiding in the word *atomic*.

So the question at the power button is specific: which state has the application promised to recover, after which successful operations, under which failure? An application crash and loss of device power stop different pieces of the work. Neither is reproduced by politely closing a window and opening it again.

The author does not need a NAND map. The author needs the software's “saved” to match the promise they depend on, with the relevant work completed before the celebration.

```text
User:
please survive the lights going out.

Storage stack:
that's the request.

User:
can you make the wait less annoying

Progress indicator:
I have been training for this my whole life.
```


# 16. Everybody Has an Address

Computers use the word *address* the way a family uses “home”: confidently, emotionally, and with several incompatible maps in the glove compartment.

An address is not a thing. It is a coordinate interpreted by some system. The number can be perfectly valid and still belong to the wrong map.

## Same number, different city

A process normally works with virtual addresses. Two processes can both use the same numeric address without referring to the same physical memory. Each brings an address-space context that gives the number meaning.

```text
Process A:
0x1000 is mine.

Process B:
0x1000 is mine.

root:
one of you is lying.

MMU:
both of them included a city.
```

The operating system arranges mappings; the CPU's memory-management hardware uses the active translation regime to translate and check an access. A number copied out of one process is not a universal pointer that another process can dereference by confidence.

This is why a crash report can display an address without providing the bytes, object, or source line a human hoped it would identify. The number needs its execution context, mapping state, and time. Address-space layouts change. Mappings appear and disappear. A coordinate without its map is a souvenir.

```text
Developer:
the bug is at 0x1042c0000.

Debugger:
in which process, image, run, and mapping?

Developer:
the hexadecimal one.

Debugger:
excellent font choice.
```

## The map currently in force

When the CPU executes a load or store, hardware does not ask which application logo is bouncing in the Dock. It consults the translation and permission state in force for that execution context.

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

The same virtual address can translate differently, lack a valid mapping, or permit different kinds of access under another context. A context switch therefore changes more than whose instructions receive CPU time. It also lets execution proceed under the map assigned to that context.

The word *physical* does not rescue us from qualification. A physical address is a coordinate in a physical address space used beneath translation. It is not necessarily a DRAM-cell serial number, a promise about one package location, or a deed granting the speaker access. Hardware ranges can lead to memory or to device interfaces. Platform details determine what a given physical range means.

```text
root:
I have the physical address.

MMU:
how did you get here

root:
administrator.

MMU:
that is still not a map.
```

Mappings also have lifetimes. XNU can replace or remove a mapping; translation hardware must then stop relying on obsolete translation state. Architectures provide mechanisms for maintaining translation caches and ordering the change. The details matter enormously to kernel code and very little to a process holding yesterday's pointer.

```text
Process:
but this address worked earlier.

XNU:
the lease ended.

Process:
the number is unchanged.

XNU:
so is the street number after an eviction.
```

A pointer value therefore does not carry a permanent guarantee that the same mapping still exists. Programs need object-lifetime and synchronization rules; hexadecimal cannot provide either. “Valid address” always has an implied time as well as an address space.

## The device brought its own map

Devices capable of direct memory access need addresses they can use for their transactions. On Apple silicon Macs, Apple documents per-agent IOMMUs that restrict DMA agents to explicitly mapped memory. Public Asahi Linux work identifies Apple's relevant IOMMU hardware as DART; Apple’s public security guide uses the generic term IOMMU.

A device-visible or I/O virtual address is interpreted through that device's I/O mapping. It can be numerically identical to a CPU virtual address and mean something else. It can eventually reach physical pages also mapped for a process, but that agreement exists because software arranged both maps—not because the numbers recognized each other at a conference.

```text
Device:
I have 0x1000.

Process:
me too.

Device:
twins?

DART:
complete strangers with matching luggage.
```

The benefit is controlled delegation. A driver can arrange a mapping for the buffers needed by an operation without granting the device every byte in the machine. DMA avoids making the CPU personally carry each byte. It does not abolish boundaries; it gives the loading dock a faster conveyor belt and a stricter guest list.

An I/O address is therefore not “more real” than a process address. It answers a different question: what coordinate may this DMA agent present under this I/O translation context?

The map may also distinguish devices or streams. A coordinate accepted for one agent does not become a transferable invitation for every peripheral. The number is part of a sentence whose subject is the device and whose verb is the configured translation.

## The register lives at an address too

Memory-mapped I/O gives another use for address-shaped numbers. A range in a processor-visible address space can select registers or windows belonging to a device rather than ordinary RAM. Loads and stores to that range can communicate with hardware.

The syntax is dangerously familiar.

```text
CPU:
store this value at the address.

DRAM:
not mine.

Device register:
I received it.

CPU:
you all dress exactly alike.
```

That resemblance does not mean a device register behaves like normal memory. Ordering, access width, side effects, and valid operations depend on the hardware contract. Reading may acknowledge an event. Writing may start an operation. Treating an MMIO register as an ordinary variable is how a convenient abstraction files a noise complaint.

The exact Apple-silicon register maps and routes vary by component and generation. This chapter does not invent one universal path. It needs only the architectural distinction: an address can select device I/O rather than storage backed like ordinary program memory.

The kernel and drivers must also access such ranges through mappings appropriate to the platform. Saying “the register is at address X” skips who can issue the access, through which mapping, with which attributes, and under which ordering requirements. A datasheet coordinate is not an entitlement.

```text
Driver:
I know where the register lives.

MMIO:
do you know how to knock

Driver:
store 1?

MMIO:
please read the part after the address.
```

This is why register documentation contains more than columns of numbers. The address locates an interface. The interface defines what accesses mean.

## Everybody stop saying address

By now the table contains CPU virtual addresses, physical addresses, I/O virtual addresses, and MMIO ranges. Someone brings up a network address. Someone else pastes a URL. A geographer opens the door, sees the hexadecimal, and leaves.

```text
Network stack:
I have an address.

MMU:
not mine.

Browser:
I have an address bar.

MMU:
not a bar.

Coordinates:
latitude, longitude.

MMU:
finally, somebody labeled the axes.
```

These uses share an idea—locating something within a scheme—but not a lookup mechanism or authority. A URL is not translated by a page table. A socket address is not a physical-memory coordinate. A CPU virtual address does not tell DART what a device may DMA.

Even the phrase *memory address* can conceal which observer is speaking. A debugger reports process virtual addresses because those are useful for understanding a task. A DMA descriptor uses the device-facing coordinate established for that transfer. Hardware documentation may describe physical or MMIO ranges. Converting between them is privileged machinery, not a formatting operation.

The address dispute from the family can now be settled without choosing one winner:

```text
root:
WHICH ONE IS REAL

MMU:
which map

DART:
which agent

Device register:
which interface

root:
I hate nouns.
```

They are all real within their jurisdictions. None is self-authenticating. The number points only after somebody supplies the map currently authorized to interpret it.

And even after an address translates successfully, we still have not answered whether anything is resident there, who may share it, or what happens on the first touch.


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


# 18. Memory Has Borders

The previous chapters gave everyone an address, a mapping, and several opportunities to misunderstand the word *shared*.

Now the hardware checks the paperwork.

Software can declare that a page is read-only or that a device may touch one buffer. The declaration matters because machinery exists to enforce it while the access is happening.

Policy without enforcement is a wish. Enforcement without policy is a very fast misunderstanding.

## The bouncer does not know Safari

For CPU memory accesses, the MMU translates addresses and checks permissions encoded in the active translation state. XNU arranges policy and mappings. Hardware applies the resulting rules without rereading the application's biography.

```text
Safari:
I need this page.

MMU:
not mapped.

Safari:
I'm Safari.

MMU:
is that an address space or a podcast
```

The joke is not that the MMU outranks the kernel. The kernel is responsible for constructing and changing the relevant state. The MMU's authority is narrower and more immediate: given this access and this active translation context, translate it or refuse it.

That refusal can generate a fault for the kernel to handle. The kernel may repair an ordinary missing mapping or treat the access as invalid. Enforcement reports the event; policy decides what the event means next.

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

Root's credentials can influence what XNU authorizes. They are not fields in every hardware translation request. By the time the load reaches the MMU, nobody is attaching a résumé.

The division of labor is why “the hardware allowed it” can be misleading. Hardware enforced the state it was given. That does not prove the state represented good policy, only that the access matched it. A kernel bug or mistaken mapping can make a mechanically valid access catastrophically inappropriate.

```text
MMU:
permitted.

Security review:
should it have been?

MMU:
I do enforcement, not regret.
```

## The loading dock

Devices capable of direct memory access can move data without making a CPU core carry each byte. That is valuable. A device with unrestricted DMA would also be a burglar with excellent throughput.

Apple documents an IOMMU for each DMA agent in Apple SoCs. For PCIe and Thunderbolt peripherals on Apple silicon Macs, the public security model restricts access to memory explicitly mapped for the device. Public Asahi Linux reverse engineering calls the relevant Apple hardware DART. The evidence ledger keeps those names and sources separate.

```text
Device:
I would like to DMA into memory.

DART:
which memory

Device:
memory

DART:
which.
```

DART does not need to understand the user's document, the driver's product name, or why the transfer would improve quarterly revenue. It receives an I/O address under a mapping context and either translates it into permitted memory or refuses it.

```text
Device:
but I'm hardware

DART:
that's awesome bro

Device:
I'M LITERALLY HARDWARE

DART:
on your I/O mapping
```

The device is hardware. So is the border.

A driver can arrange access to a buffer needed for an operation without making the device co-owner of physical memory. The map can be scoped and later withdrawn. DMA is direct with respect to CPU copying, not direct with respect to constitutional government.

Completion matters to the mapping lifetime. Software cannot safely recycle a buffer merely because it has become bored with the operation; the device and driver contract must establish when the transfer no longer depends on that mapping. Accessibility, ownership, and lifetime remain different nouns even at the loading dock.

## Thunderbolt brought someone

Thunderbolt's role in the family is to arrive with a peripheral and treat the cable insertion as sufficient character evidence.

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
absolutely fucking not.
```

The refusal is the opening position, not the whole device lifecycle. Drivers, policy, and mappings may establish the access an operation needs. “Connected” still does not mean “may inspect arbitrary RAM.”

A cable should not be a constitutional amendment.

Nor is isolation the same as uselessness. The goal is not to prevent peripherals from moving data; it is to let them move the particular data required for an authorized operation. A border that can never open is a wall. An IOMMU is useful because software can create doors with addresses and close them again.

This boundary is especially useful because it reveals that hardware is not one united political party. The peripheral is hardware. DART is hardware. The memory controller and fabric are hardware. They have different jobs and do not acquire collective ownership merely because a teardown labels them all silicon.

## The landlord's landlord

After CPU and device requests survive their respective maps, traffic still has to move through the memory system. The memory controller and fabric arbitrate service among agents. Their exact topology and policy vary by Apple-silicon generation, so “Memory Controller” is the book's character for this layer, not a claim about one tiny universal block with a deli ticket printer.

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

Arbitration is power over timing and service, not policy over the meanings of the bytes. The controller does not decide whether Safari deserved a page. It does not inspect a Unix UID before every transaction. It does not resolve a data race because one participant sounded sincere.

```text
XNU:
I authorized the mapping.

MMU:
I enforced the CPU access.

DART:
I constrained the device.

Memory Controller:
I moved the traffic.

DRAM:
I held charge.

root:
so which one of you works for me

Hardware:
define works
```

The DRAM cells store charge and have never heard of root.

## Borders are a joint production

No one mechanism supplies the entire security story. Software chooses mappings and responds to faults. Translation hardware checks accesses. Device IOMMUs constrain DMA. Controllers arbitrate transactions. Each layer depends on another without becoming the other's supervisor.

An incorrectly configured map can authorize the wrong access at machine speed. A correct policy that is never encoded into enforceable state remains prose. Hardware enforcement is not wise; software policy is not physical. The useful result comes from their agreement.

```text
Policy:
this device may use these pages.

DART:
map?

Policy:
I wrote a memo.

DART:
then the memo may DMA.
```

Memory has borders because policy is translated into mechanisms that understand narrower nouns: this context, this mapping, this access type, this transaction. None of them needs to understand the whole machine to stop one forbidden byte.

This is the recurring family trick in its most literal form. XNU has broad authority to create the rules. MMU and DART have brutally narrow authority to apply configured rules to individual accesses. The memory controller has authority over service. DRAM has the final authority to be finite. None can substitute for the others, and none needs a complete theory of macOS.

That is also why a successful access does not settle who has the newest copy. Once several cores begin keeping fast private memories of shared reality, the family needs another office.


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


# Part IV — Nobody Touched the Hardware {#part-iv .part-title}

Everybody takes credit while the request travels toward electricity.


# 20. You Never Talked to the Hardware

The user clicks a button. The application says it sent the request. The kernel says it handled the operation. The driver says it programmed the device. The device says it did the work.

Everybody is telling the truth at the level where they invoice.

## The application takes credit

Consider a client application communicating with a DriverKit extension. Apple documents DriverKit as a framework for drivers that run in user space. Its sample client uses an `IOUserClient` connection and method calls to exchange validated data with a driver, including asynchronous callbacks.

This is one documented route for one class of interaction. It is not the secret universal pipeline behind every click on macOS. Some devices use Apple-provided drivers, some paths stay in kernel code, some frameworks expose higher-level services, and memory-mapped or other direct mechanisms exist under controlled conditions.

Our application will nevertheless announce victory immediately.

```text
Application:
I told the device.

Driver:
you called my client interface.

Application:
through the system.

Driver:
you filled in a structure.
```

That structure matters. A user-client boundary does not accept human intention; it receives arguments. Apple's DriverKit sample contrasts checked and insecure dispatch paths and validates properties such as counts and structure sizes before calling the driver's method.

The application may be perfectly authorized to request an operation and still submit malformed input. Authority to knock is not authority to redesign the doorbell packet.

```text
Application:
but the user clicked Print.

Driver method:
scalar input count?

Application:
the icon was blue.

Driver method:
structure size?
```

## The kernel forwards the complaint

DriverKit drivers run in user space, but that does not mean an application simply finds the driver process and begins shouting across ordinary memory. The system manages the service and connection. DriverKit's `IOUserClient` represents a connection to another service managed by the system; framework calls carry requests across the boundary.

The kernel's role varies with the family and operation. It may provide transport, enforce access, manage objects, map memory, and coordinate with the hardware-facing service. Saying “the kernel did the I/O” can be useful shorthand. It can also hide the driver that understands the device-specific contract.

```text
Application:
kernel, make the hardware do it.

XNU:
which service

Application:
the hardware one.

XNU:
I see the problem has arrived pre-debugged.
```

Delegation is not abdication. The system still controls which driver may run and which clients may connect. DriverKit uses entitlements for driver and user-client access. The driver receives authority over a defined interface, not a transferable deed to the platform.

Nor is “user-space driver” a demotion into ordinary applicationhood. It has a specialized framework, lifecycle, entitlements, device relationship, and system-managed communication path. PID alone cannot explain the job.

The kernel also remains the office that can revoke the relationship when a process exits, a service stops, or policy changes. The client cannot preserve access by photocopying a connection handle into a text file. Handles name live kernel-managed relationships; they are not bearer bonds redeemable after the objects behind them disappear.

```text
Application:
I saved the connection number.

XNU:
the connection is gone.

Application:
but the number is right here.

XNU:
frame it.
```

This resembles file descriptors without making every I/O connection a regular file. The reusable lesson is object lifetime: a small integer or language object represents authority only while the system relationship behind it remains valid.

## The driver owns a translation problem

Hardware does not usually want the application's pointer. Chapter 16 already prosecuted that address for impersonating a universal coordinate.

DriverKit provides memory-descriptor objects for describing buffers and sharing them across relevant boundaries. An `IOBufferMemoryDescriptor`, for example, can hold data moving into or out of a driver and can be passed to APIs that map it for another process. A hardware operation may additionally require device-accessible mappings under the platform's DMA protections.

The driver therefore receives several questions disguised as one buffer:

```text
Application:
here are my bytes.

Driver:
whose address

Application:
mine.

Driver:
the device is not you.

DART:
and neither of you is automatically mapped.
```

The exact mapping and hardware APIs depend on the driver family and device. We do not invent them here. The durable lesson is that software must turn a client-visible object into a buffer and address contract the relevant device can use, for long enough to complete the operation and no longer.

That lifetime is authority with a clock. Releasing or reusing a buffer before completion can make yesterday's legitimate mapping point at today's unrelated data. The device cannot infer that the application has moved on emotionally.

## The queue has never heard of your button

Drivers handle concurrency and asynchronous events. DriverKit's `IODispatchQueue` serially executes submitted blocks, and DriverKit provides dispatch sources for events such as timers and hardware-related interrupts. A request can be accepted while waiting its turn; an asynchronous completion can arrive later.

```text
Application:
the button click happened first.

Driver queue:
in the interface.

Application:
so the operation happened first.

Driver queue:
you have confused arrival with completion.
```

Queues provide order within their stated scope. A serial driver queue can order its blocks without proving the physical device finished the corresponding operations in that same moment. The device can have its own command queues, firmware, and completion mechanism. “Queued,” “submitted,” “accepted,” and “completed” are separate receipts again.

Cancellation adds another noun. Stopping future queue work is not necessarily undoing an operation already submitted to hardware. DriverKit documents queue cancellation in terms of stopping dequeue and waiting for in-flight tasks. Whether a particular device command can be canceled is a device contract, not a motivational speech from the application.

Completion travels upward too. A device event can lead to a hardware-related interrupt source, driver work, and an asynchronous callback, depending on the interface. The callback is not the hardware itself visiting the application. It is the system delivering a result through the relationship established earlier.

```text
Application:
the device called me.

Driver:
I invoked your completion.

XNU:
after an event.

Device:
I changed one electrical condition.

Application:
team effort.
```

Polling is another possible path: software can check state rather than wait for an interrupt. That difference matters to performance and timing, but not to the chapter's point. Either way, the application's high-level action becomes device-specific work and returns through defined boundaries.

## The device did the work

Eventually the device changes a register, moves bytes, emits a packet, produces samples, or performs whatever operation its interface defines. The driver interprets completion and reports upward. The framework delivers a callback. The application redraws its icon and claims it personally moved electrons.

```text
Device:
done.

Driver:
operation completed.

XNU:
client may resume.

Application:
I did it.

Device:
what is your voltage
```

This is not a universal five-stage pipeline. A display update, storage request, USB transfer, neural-network operation, and network packet use different frameworks and hardware paths. Some operations avoid a client-driver round trip. Some hardware is controlled by kernel components or firmware. Direct access can exist behind mappings and policy. The example proves delegation, not one mandatory staircase.

Even “device” may name a logical service rather than one physical component. Drivers can compose, and one request can cross several services before reaching a controller. Counting boxes in a diagram does not establish constitutional rank; it establishes how many places can return an error.

It also explains why every layer can report an error the others could not predict. The client can fail validation. The service can be unavailable. Mapping can fail. The queue can stop. The device can reject a command. Completion can report a hardware-specific result. Nobody needs total authority to ruin the afternoon.

Success is equally scoped. A client method can return successfully because the request was accepted. A driver can report submission success because the command reached the device queue. A later completion can report the device result. If the operation involves persistent media or a network peer, additional boundaries remain. One green checkmark cannot inherit promises from offices it has not visited.

The application has authority over its requested feature. The system has authority over the connection. The driver has authority over a device interface. DART has authority over DMA translation. The device has authority over whether its physical operation succeeds.

You talked to an abstraction that talked to an abstraction that arranged a very specific audience with hardware.

The cable remains innocent. A cable should still not be a constitutional amendment.


# 21. The Firmware Nobody Invited

Userspace holds a census. Every respectable program receives a PID. launchd knows which services it started. Activity Monitor brings columns.

Then a controller executes code nobody can find in the process list.

## Nobody launched it

Firmware is software associated closely with hardware operation and startup. Some firmware executes on a peripheral processor. Some configures hardware before ordinary processes exist. It can be loaded and verified by an earlier boot stage or verified by a processor's own secure-boot chain.

None of that makes firmware supernatural. It means the Unix process model is not the only model of executing code in the machine.

```text
launchd:
show me your job label.

firmware:
no.

launchd:
bootstrap domain?

firmware:
also no.

launchd:
who raised you

Boot chain:
complicated question.
```

launchd's authority is enormous in the userspace civilization XNU creates. A peripheral processor is not an undocumented corner of that civilization merely because it lives in the same computer. It can have its own instruction stream, memory, firmware image, reset state, and startup rules.

The chapter title is a joke: the platform absolutely invited the firmware. launchd simply was not on the committee.

## Firmware is not one department

The word *firmware* covers too much to support one family biography.

Boot firmware participates in establishing the machine's early state and chain of trust. Device or controller firmware implements behavior close to a hardware block. Software on a peripheral processor may be downloaded at startup from the primary CPU or boot through a separate verification chain. Persistent firmware can have an update policy distinct from a runtime image loaded on every boot.

```text
User:
update the firmware.

Boot firmware:
whose

SSD controller:
whose

Display coprocessor:
whose

User:
the computer's

Firmware:
we have been over nouns.
```

Apple's public security documentation describes modern systems as containing peripheral processors for networking, graphics, power management, and other tasks. Where separate processors require firmware, Apple describes two broad protections: download verified firmware from the primary CPU at startup, or have the peripheral processor implement its own secure boot.

Those are categories, not a claim that every controller follows one sequence. Product and generation matter. The book refuses to turn “firmware verified” into a universal boot command shouted simultaneously across the SoC.

Verification answers a bounded question too. A signature and policy can establish that an image is acceptable to load under a particular trust scheme. They do not prove the firmware is bug-free, that its configuration is correct, or that every command it receives is wise. Authentic mistakes remain authentic.

```text
Verifier:
approved image.

Security review:
approved behavior?

Verifier:
different meeting.
```

Updates add time to the boundary. An update package can be authenticated before installation, and a processor can verify what it boots later. Rollback policy, activation, and recovery are component-specific. The chapter will not compress all of them into “Apple signed it, therefore Tuesday happened.”

## The controller has opinions

A controller can accept requests through registers, queues, shared memory, or another device-specific interface and execute firmware that interprets them. By the time an application request arrives, its original nouns may be gone.

The storage controller does not receive a Finder path. A display coprocessor does not receive “make the window feel more premium.” A network controller does not receive a process's moral case for low latency.

```text
Application:
please perform the feature.

Driver:
command prepared.

Controller:
queue entry accepted.

Application:
did you preserve my intent

Controller:
I preserved bits 7 through 12.
```

Firmware's authority is narrow but concrete. It can govern the controller's local operation, scheduling, or protocol within its design. It does not become the kernel because it executes code, and XNU does not become the firmware's line manager because it submitted a request.

The controller also sees a different world. It may know ring positions, command identifiers, buffer addresses, link state, temperature, or error codes that have no direct representation in the calling application's model. Conversely, it may know nothing about windows, users, paths, or why the request exists.

```text
Controller:
queue 3 stalled.

Application:
the user is getting impatient.

Controller:
is that a register

Application:
emotionally.
```

Abstraction works because the driver translates between those worlds. Translation does not make either description fake. It lets the application avoid learning a device protocol and lets the controller avoid learning product management.

An error may originate there and travel upward through layers that cannot repair it. The driver can translate the result. The kernel can wake a waiter. The application can display “Something went wrong,” the traditional GUI representation of five jurisdictions refusing to name the guilty party.

## Other processors have childhoods

Chapter 2 introduced the hardware relatives briefly because boot must prepare more than the Application Processor. Now the gray rectangle labeled HARDWARE can testify.

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

Some specialists receive firmware from the primary processor. Some establish trust within their own boot environment. The Secure Enclave, explored later, is a particularly strong example of a distinct processor and security domain. Other coprocessors have different protections and responsibilities; sharing the category *peripheral processor* does not make them miniature SEPs.

Public Asahi Linux reverse engineering supplies useful names and implementation detail for particular Apple-silicon generations, such as DCP for display work and S5E for NAND/SSD control on documented targets. Those receipts are explicitly reverse engineering, not Apple documentation and not a license to generalize one chip's topology across the family.

```text
XNU:
I loaded your firmware.

Peripheral processor:
thank you.

XNU:
so I am your kernel.

Peripheral processor:
you delivered lunch too.
```

Loading an image is authority over a startup input. It is not proof that the loader schedules every instruction afterward, owns the processor's local policy, or understands its private runtime state.

## What's your PID

The inevitable census begins.

```text
launchd:
I manage userspace.

firmware:
cool.

launchd:
what's your PID

firmware:
my what
```

The exchange is dramatization. “firmware” is a composite character, not an Apple process hiding its PID, and no real component said this. Its architectural claim is modest: firmware executing outside the ordinary macOS process model does not acquire a Unix PID merely to make Activity Monitor comfortable.

This does not mean no firmware-related helper ever appears in userspace. Update tools, loaders, diagnostics, and services can be ordinary processes. Their PIDs identify those processes, not every processor or firmware image they help manage.

Likewise, a firmware blob stored in a filesystem is not executing merely because it exists. It becomes operational only through the component's loading or boot process. The file can have a path and signature; the running firmware can inhabit another processor with neither a pathname nor a Unix task. One artifact participates in two jurisdictions at different times.

```text
launchd:
then how do I restart you

firmware:
which reset domain

launchd:
kickstart service

firmware:
that's adorable.
```

Reset, reload, update, and restart are different operations. Their availability and authority depend on the component. A user-space service can be restarted without resetting its device. A controller can reset without rebooting the whole Mac. A firmware update can require verification and a later activation step. The verbs need objects again.

```text
User:
turn it off and on again.

launchd:
the service?

Driver:
the interface?

Controller:
the engine?

Power Management:
the domain?

User:
I regret asking experts.
```

A reboot may incidentally restart several of these relationships, which is why it often helps and rarely explains anything. The successful ritual does not identify which layer was stale.

Firmware can therefore be alive, authenticated, outdated, waiting, wedged, or perfectly healthy while the service above it is broken. “The firmware” is not a diagnosis. It is a neighborhood.

And every house in that neighborhood has a different reset switch.

The hardware relatives are not above launchd. They are outside the jurisdiction that makes launchd's usual questions meaningful.

That distinction protects the book from a tempting hierarchy. Boot ROM is not CEO of the display controller. A storage controller is not subordinate to a GUI process in the organizational sense. The components participate in dependency and control relationships that name specific images, resets, commands, buffers, and results. “Runs earlier” and “runs underneath” are not ranks.

The firmware nobody invited was invited by boot policy, hardware design, or a driver. It simply arrived before the seating chart and refuses to wear a PID sticker.


# 22. The Network Does Not Care About Your Process

The application opens a socket. The network receives a packet. Between those sentences, the process loses most of its biography.

Packets do not cross a link carrying a Unix PID because the sender was proud of it.

## The socket knows locally

A socket is a local operating-system object exposed through a descriptor. It connects a process to a networking endpoint and protocol state. Local policy can know which process opened it, which credentials applied, which sandbox rules matter, and which interface choices are allowed.

```text
Process:
socket 12 is mine.

Network:
what's a 12

XNU:
local descriptor.

Network:
keep it local.
```

Calls such as `connect`, `send`, and `recv` operate through that local object. Their return values describe work at the socket interface. A successful send does not mean a remote application accepted the message, just as writing to a file did not automatically prove durable storage.

Buffers make that distinction practical. The stack can accept bytes from the process while transmission and acknowledgment remain pending. Backpressure can later make another write block or fail. The socket's local success is meaningful—it accepted the specified work—but it cannot sign a receipt on behalf of an unseen peer.

```text
send():
accepted.

Application:
delivered?

send():
I work at departures.
```

Socket type and protocol matter. A stream supplies different semantics from a datagram. A local Unix-domain socket does not traverse an Ethernet PHY merely because the API contains the word socket. This chapter follows an ordinary Internet packet far enough to show boundaries, not to invent one universal path.

## The packet leaves without your PID

The networking stack turns application data into protocol data under the rules in use. Transport and network headers carry protocol-defined fields: ports, addresses, sequence state, checksums, and other information appropriate to that protocol. The sender's macOS PID is not an Internet routing field.

```text
Application:
tell them process 472 sent it.

TCP:
port.

IP:
address.

Application:
UID?

IP:
not a routing field.
```

Local tools and policy engines may attribute traffic to processes because the operating system can relate sockets to tasks. That attribution is real and useful. It is not evidence that every router or receiver sees the local process table.

Addresses can also be rewritten or hidden by tunnels, relays, and network address translation beyond the process's view. The source identity visible to a remote server can differ from the local interface state. This chapter makes no claim about which such mechanisms a particular connection uses; it merely refuses to treat a local endpoint as a globally preserved biography.

Checksums provide integrity checks for defined fields and failure patterns. They do not authenticate the human sender. Sequence numbers organize a transport stream. They do not establish moral seniority among packets. Protocol fields possess the authority their protocol assigns and no more.

Likewise, network-layer addresses identify interfaces or endpoints under a network protocol; they are not CPU virtual addresses from Chapter 16. Port numbers help transport demultiplexing; they are not Mach ports. Computing reused *port* because the original ambiguity was insufficient.

## The interface chooses a door

Routing and interface selection decide where traffic should go next. A Mac can have Wi-Fi, Ethernet, loopback, tunnels, and other interfaces. Policy, route state, destination, and availability influence the choice.

```text
Packet:
I need to leave.

Routing table:
destination?

Packet:
the internet.

Routing table:
that is not a row.
```

The selected interface has its own framing and link behavior. An IP packet carried over Wi-Fi is not transmitted as raw source-code intent. It is packaged for the link, handed toward the relevant driver and controller, and eventually represented as signals by a radio or physical interface.

Virtual interfaces complicate the picture usefully. A tunnel can accept a packet and produce another packet. Loopback can deliver locally without a physical link. Packet filters can deny or transform traffic. “Sent to the network” needs an interface and observation point.

Name resolution happens before or beside this route and has its own caches and policy. Turning a hostname into an address does not open a socket, authenticate a service, or prove that packets can reach it.

```text
DNS:
here is an address.

Application:
connection established.

TCP:
we have never met.

DNS:
I gave directions, not a ride.
```

## The controller speaks link

The driver translates between the operating system's networking objects and the interface hardware's contract. A controller may work with descriptors, buffers, rings, queues, and completion events. The exact design varies; this is not a claim that every Apple network device uses one named queue or firmware ABI.

```text
Network stack:
packet for this interface.

Driver:
buffer prepared.

Controller:
descriptor accepted.

Application:
did they read my message

Controller:
I moved bits toward a link.
```

The PHY or radio handles physical signaling for its medium. It does not parse the application's account name to decide whether a voltage transition is sincere.

```text
PHY:
signal transmitted.

TCP:
acknowledgment pending.

Application:
recipient accepted?

Remote service:
who are you people
```

Each completion answers a narrower question. Hardware can finish transmitting a frame that never reaches its destination. The network can deliver bytes to a host whose service rejects them. A transport acknowledgment can establish transport progress without proving the human recipient approved the content.

Reliability is similarly scoped. TCP can retransmit and order a byte stream between endpoints. It cannot force the receiving application to commit a transaction, save a file, or keep the data after acknowledging it at another layer. UDP provides different promises. Applications that need end-to-end confirmation define it in their own protocol.

```text
TCP:
bytes acknowledged.

Application:
order fulfilled?

Remote database:
transaction rejected.

TCP:
I do transportation.
```

The reverse path has the same delegation in another direction: signals become frames, buffers, protocol input, socket data, and eventually something a waiting process can read. The packet does not seek the process by PID across the network. The local stack uses protocol state and local socket relationships to deliver it.

## Identity can be packed deliberately

Higher-level protocols can explicitly carry identity, authentication tokens, certificates, account identifiers, or signed claims. That is how an application can make identity meaningful to a remote service: it encodes the relevant evidence into a protocol the other side understands.

```text
Application:
finally, my identity.

TLS:
which identity and proof

Application:
I am logged in.

Remote service:
to whom
```

This qualification matters. “The network does not care about your process” is not a claim that networks carry no identity or that privacy systems cannot attribute traffic. It means local process identity is not automatically inherited by every lower layer. Identity must be preserved or re-established deliberately where the protocol needs it.

Encryption adds another boundary. Link hardware can transmit ciphertext without knowing the application data. An intermediary can route packets without possessing the endpoint's keys. Authority to carry the envelope is not authority to read the letter.

Metadata survives differently from content. Encryption can protect payloads while leaving enough addressing and transport information exposed for networks to deliver them. Which fields remain visible depends on the protocol. “Encrypted” therefore needs the same follow-up as “address”: encrypted from whom, at which layer, covering which bytes?

```text
Router:
I can forward it.

Application:
so you can read it.

Router:
the post office can read street names.

TLS:
please stop opening the envelope metaphor.
```

Firewalls and packet filters exercise policy over traffic they can classify. They may use interface, address, port, direction, connection state, or locally available process information. A permitted packet is not endorsed content; a blocked packet is not proof the application lacked every other authority. The filter governs passage at its boundary.

Network policy can still block by process locally, by address or port at another layer, by authenticated identity at an application service, or by many other scoped facts. None is the universal network authority.

Observability follows the same rule. A packet capture, socket listing, controller counter, and application log see different portions of the trip. Their disagreement can be honest because each instrument stands at a different border.

```text
Process:
I sent it.

Socket:
accepted bytes.

Stack:
constructed packets.

Interface:
selected a door.

Controller:
moved a frame.

Network:
best effort, babe.
```

Somewhere in that sequence the process may block waiting for space, data, or completion. The CPU will then be accused of waiting, despite possibly running something else entirely.


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


# Part V — Other Worlds {#part-v .part-title}

Some neighbors share the machine without sharing its government.


# 25. SEP Has a Mailbox

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


# 27. The House Inside the House

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


# Part VI — Everybody Leaves Eventually {#part-vi .part-title}

The remaining authorities assemble to discover where their power stops.


# 28. Below the Kernel

What does kernel authority presuppose?

The last chapter gave XNU an opportunity to discover one answer by ceasing to be available for follow-up questions. For this chapter, the cast has been restored by the ordinary literary procedure of beginning another scene. Nobody should infer a recovery protocol from the fact that the kernel has lines again.

XNU arrives with a revised claim. It will no longer insist that it governs everything. It will insist that everything important requires it.

This sounds more defensible until somebody asks what *it* requires.

## The floor has prerequisites

XNU executes on the Application Processor. Those instructions need a processor on which to execute; kernel privilege does not make them self-executing. We have spent a book examining what becomes possible once the kernel runs. The question now concerns the conditions under which that sentence can begin.

```text
XNU:
I provide the execution environment.

Application Processor:
and I execute it.

XNU:
yes.
for me.

Application Processor:
you have added a preposition
where the electricity goes.
```

The Application Processor belongs to an SoC platform. That relationship is integration, not process parentage. The SoC did not fork a CPU. Nor does being part of the same platform dissolve the separate processor and security domains that caused the dinner to go badly.

XNU wants the platform to be its equipment. SoC wants the residents to acknowledge the platform. Both can get through an ordinary working day without settling that domestic disagreement. Neither can settle it by drawing a taller box around the other.

If we draw arrows here, each needs its own verb. XNU *executes on* the Application Processor. The processor is *integrated into* a platform. Platform operation *depends on* power-management hardware and firmware. The machine is *supplied by* a battery or external power. An external source may be *connected through* electrical infrastructure.

These are different relationships. An execution environment, physical integration, power control, stored energy, and electrical supply do not become one chain of command because they fit on the same page. Later, ownership, regulation, and taxation will attempt to squeeze onto the page too. They will not improve the diagram.

```text
SoC:
I would like a box.

XNU:
you already have a box.

SoC:
you labeled it hardware.

XNU:
accurately.

SoC:
your box says sovereign execution authority.

XNU:
also accurately.
```

The argument reaches the edge of the diagram, where somebody has finally noticed the power connection.

## A supply is not a title

Platform power management involves hardware and firmware, including work assigned to peripheral processors. There is no need to invent a single secret office that personally grants electricity to every other component.

For the following scene, **Power Management is a dramatized ensemble role**, wearing one name tag on behalf of work distributed across a platform. The name identifies this cast role, not one universal Apple component. The hardware and infrastructure characters are fictional speakers throughout.

Battery and Charger have also been invited. This makes the setting a laptop, not a claim that every Mac has an internal battery. Charger is the cast's name for the external charging setup; it is already taking more personal credit than a power adapter and cable deserve.

```text
XNU:
I control execution.

SoC:
on which hardware?

Power Management:
while powered how?

Battery:
using whose energy?

Charger:
whose energy?

Battery:
GET THE FUCK OUT.
```

Battery's objection is understandable. It has spent the entire book being represented by a small percentage while components with much less remaining capacity deliver speeches about ownership.

But the objection also conceals a problem. Stored energy and the means of replenishing it are different things. Battery can supply the laptop while the cable is absent. Charger can arrive with an external source without becoming the owner of Battery's contents. Neither relationship resembles a parent process supervising a child.

```text
Battery:
I was here when you were unplugged.

Charger:
and how did that go.

Battery:
beautifully.

Charger:
for how long.

Battery:
this is a hostile interview.
```

The interval matters. A charged battery lets a laptop operate away from external power for a limited time. Dependence need not mean an uninterrupted live connection to the same source. The machine can carry some of the conditions of its continued operation with it.

That is a new kind of answer to the jurisdiction question: not *who can refuse me right now*, but *how long can I continue before I need something again?* Battery has acquired bargaining time. It has not acquired infinite energy or jurisdiction over the kernel's memory protections.

```text
root:
can I extend the interval.

Battery:
close something.

root:
I meant administratively.

Battery:
administratively close something.
```

Power control introduces another distinction. Managing a supply does not manufacture its energy. The name *Power Management* sounds like it belongs to the most senior person in a very unpleasant company. In this room, its problem is that everyone hears the first word and ignores the second.

```text
XNU:
I need more power.

Power Management:
what is available.

XNU:
that sounds like a question for a subordinate.

Power Management:
it is a question for a supply.
```

The physical terms do not negotiate merely because software can express a preference. A laptop may be connected to a source that provides enough power to run it without charging the battery. Under a demanding workload, it can also use more power than the connected source supplies. The cable being present does not settle the balance.

```text
Charger:
I am connected.

Battery:
I am decreasing.

Charger:
both statements can be true.

XNU:
I hate this family.
```

This is why *connected*, *running*, and *charging* cannot serve as synonyms. They answer different questions about a machine that looks exactly as plugged in in all three cases. The little connector is not a certificate that every demand downstream will be satisfied.

Nobody has discovered a hidden monarch. They have discovered a budget that continues to apply during the constitutional argument.

## The other end of the cable

Charger enjoys its promotion for almost a paragraph. Then somebody follows it to the wall.

```text
Charger:
I provide power.

Outlet:
you are welcome.

Charger:
I was speaking.

Outlet:
while plugged into me.
```

For the ordinary wall-powered charging arrangement, the adapter connects the laptop to an external electrical supply. The outlet is a connection point, not an inexhaustible source. Following it takes the discussion into the building's electrical connection and, where that connection is supplied by a grid, into infrastructure beyond the machine.

The jurisdiction map has now left the motherboard.

An outlet can be local while its supply is not. In a conventional grid arrangement, generation, transmission, and distribution have distinct jobs: electricity is generated, moved across the network, and delivered to consumers. They need not share a single owner. The business selling the electricity and the utility delivering it may also differ.

```text
Outlet:
I would like to clarify that
I do not own a power plant.

XNU:
then who did I just threaten.

Outlet:
a socket.
```

Utility and Grid arrive together and object to being given one chair. Here, *utility* names an organization; *grid* names interconnected infrastructure. A conventional power plant contributes generation to that system. Calling the plant the boss of the network would confuse making electricity with governing everything involved in delivering it.

```text
Utility:
whose name is on the account.

XNU:
mine should be.

User:
it is not.

Grid:
can the account discussion happen
somewhere that is not my diagram.
```

Ownership and public authority vary by jurisdiction. An electricity provider may be privately owned, publicly owned, or a cooperative; government may appear as regulator, owner, customer, or legal authority in different arrangements. None of those descriptions supplies one universal ladder from the wall socket to a head of state.

The cast has nevertheless ordered a podium.

## The hearing becomes inadmissible

From here, Government and IRS are satirical personalities, and the later Physics, Causality, and Spacetime are a metaphysical postscript. Their exchanges are invented, not evidence about grid control, tax procedure, or cosmology. The technical dependency argument has reached its limit; the characters have refused to leave.

Government opens a folder with the seriousness of someone about to use the word *framework* until everyone forgets the question.

```text
Government:
depending on the jurisdiction,
my relationship to this infrastructure—

IRS:
did somebody say income.

Government:
no.

IRS:
I'll wait.
```

IRS has interrupted the explanation. It has not been inserted into the electrical delivery path. Nobody is proposing that electricity passes through a tax office between generation and the outlet. The interruption is American bureaucracy entering an argument that had not even agreed to take place in America.

Government tries again.

```text
Government:
there are several different capacities
in which I might appear.

XNU:
pick your highest privilege level.

Government:
that is not how this works.

SEP:
he needs to hear it from everybody.
```

For once, Government would like to be treated as a collection of limited offices with different responsibilities. It has chosen a terrible room in which to request that courtesy. XNU has spent nineteen chapters arriving at meetings with a single noun and expecting the furniture to kneel.

The utility puts down a bill. Government puts down a regulation-shaped prop. IRS puts down an entirely different folder. None of these objects plugs into the laptop. Each participant is offended that this observation seems relevant.

```text
User:
which one of you turns it on.

Government:
that is not the question before us.

User:
it was my question.

Government:
we have referred it.

launchd:
to whom.

Government:
a working group.

launchd:
finally.
a service definition.
```

Power Plant has been silent through this exchange. It had expected the room to become less metaphorical upon its arrival. Instead, everyone has acquired folders, and the word *power* is being used in several senses without any attempt to compensate the original supplier.

It pushes its chair back.

```text
Power Plant:
I AM LITERALLY THE POWER PLANT.

SEP:
on your grid.
```

There is a pause long enough for XNU to experience something close to solidarity.

```text
XNU:
first time?

Power Plant:
I expected the word literally to help.

XNU:
so did I.
```

The plant begins drafting a complaint. Its difficulty is choosing the respondent. Grid is still objecting to the seating plan. Utility is asking for an account number. Government has referred the matter to itself in another capacity. IRS has underlined something nobody said.

SEP has provided no forwarding address.

## No earlier office

The complaint now requires a cause more fundamental than anybody in the room. The hearing leaves public administration and appoints Physics, who has made the mistake of having laws in its name.

Physics arrives without a badge. This immediately concerns everybody who has spent the book treating badges as the beginning of reality.

```text
XNU:
where is your enforcement mechanism.

Physics:
you have been sitting in it.

XNU:
can I inspect the policy.

Physics:
you can try to describe it.

Gatekeeper:
developer cannot be verified.

Physics:
that is going to be a recurring problem.
```

The cast is now arguing with a personification of physical law as though it were a badly documented service. This is metaphysical slapstick. No claim about an actual origin of the universe can be obtained by interviewing this witness, who has been written chiefly to disappoint the power plant.

Power Plant wants somebody to have approved the arrangement. If nobody approved it, then the whole hearing has been taking place under rules nobody in attendance issued. This feels procedurally intolerable to a room full of characters who have confused explaining a condition with granting permission for it.

```text
Power Plant:
there must have been a meeting.

Physics:
why.

Power Plant:
look at the consequences.

launchd:
I have no record of the meeting.

Physics:
you arrived rather late.

launchd:
I am PID 1.

Physics:
locally.
```

That word makes the room worse.

Government asks whether the original decision can be appealed. Physics asks which decision. IRS asks whether the original conditions had a filing status. Causality, who had hoped to remain an abstract concern, requests standing before the discussion becomes any earlier.

Power Plant mistakes the objection for progress. At last, another participant. Surely the next witness will identify the official who signed the beginning. The complaint can then proceed in an orderly fashion, provided the beginning has kept its paperwork.

```text
Power Plant:
Physics.

Physics:
what.

Power Plant:
who authorized the Big Bang.

Physics:
that's not really—

Power Plant:
WHO SIGNED OFF ON
INITIAL CONDITIONS

Causality:
I object.

Physics:
on what grounds

Causality:
you're asking for authorization
before there was a "before."

Power Plant:
wrong jurisdiction?

Causality:
wrong temporal domain.
```

```text
Physics:
Spacetime?

Spacetime:
...

Physics:
Spacetime?

Spacetime:
zzz
```


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


# 30. The Hardware Family Dinner

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

## The platform would like a word

The SoC has been listening to the component roll call with increasing regret.

```text
SoC:
okay.

XNU:
what.

SoC:
I have been listening to all of you
argue about who owns the machine.

SEP:
not me.
I have my security domain.

XNU:
I run the operating system.

GPU:
I render.

ANE:
tensor.

DART:
papers.

SoC:
STOP SAYING PAPERS.

SoC:
you are all PART OF ME.

XNU:
see? my SoC.

SEP:
our SoC.

SoC:
THAT WAS NOT THE POINT.
```

Apple publicly describes its systems on a chip as integrating specialized technologies into one platform. Being part of that platform does not mean executing in the same processor domain: XNU runs on the Application Processor while SEP retains its separate processor and security domain. It does not mean sharing a trust domain, and it does not mean governing the same object. Integration describes the platform, not a single policy engine or a universal chain of command.

Two smaller place cards appear beside SEP. They belong to `iBootd` and `amfidd`, the already-labeled fictional characters from Chapters 5 and 8. Neither is a real SEP service; the seating plan is committing to the bit, not documenting startup architecture.

```text
SoC:
who the fuck are those two.

SEP:
my daemons.

SoC:
you have DAEMONS now?

SEP:
microservices 🤝

SoC:
YOU ARE A SECURITY COPROCESSOR.

SEP:
entrepreneurship.
```

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

VFS:
names into file operations.

Driver:
device-specific translation.

firmware:
local controller behavior.

Network:
packets without your PID.

Scheduler:
runnable is not running.

Wait queue:
eligible, not executed.

Interrupt machinery:
delivery, not the whole consequence.

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

The system works because these limits meet through boot, IPC, policy, names, mappings, drivers, firmware, queues, packets, waits, wakeups, interrupts, shared memory, cryptography, and mutual suspicion.

This is the Apple silicon family.

Not a hierarchy with one god at the top.

A house full of different sovereign assholes, each holding one portion of the lease and none willing to wash the dishes.


# 31. At the Mercy of the Kernel

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


# 32. One More Jurisdiction

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

```text
Linux on larpintosh:
I use Hyprland.

hyprvisor:
on your virtual machine.

Linux on larpintosh:
...can Hyprland run on a VM
```

hyprvisor clears its throat.

moo.

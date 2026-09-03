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

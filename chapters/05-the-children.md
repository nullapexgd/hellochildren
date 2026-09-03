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

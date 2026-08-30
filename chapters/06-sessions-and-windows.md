# 6. Sessions, Windows, and Ceremonial Root

The Mac has booted. XNU governs execution. launchd has populated userspace. You still do not exist.

Computationally. We cannot help with the other kind.

There is no authenticated graphical session associated with your account. The machine may be alive, but it has not agreed that *you* are the person who gets a desktop.

Enter `loginwindow`, carrying the kind of keyring that causes a belt injury.

## Please authenticate before existing

Apple assigns `loginwindow` a coordinating role in login and user-environment setup. The internals evolve, and `loginwindow` does not become every authority it consults.

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

WindowServer sees windows, surfaces, displays, session state, event routing, and the machinery through which multiple clients inhabit one graphical universe.

Apple publicly documents the system window server delivering input events to applications. Private frameworks and implementation details add much more, but the family can make its point without pretending every private API is known.

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

Privilege can end a world without understanding it. That is power, not government.

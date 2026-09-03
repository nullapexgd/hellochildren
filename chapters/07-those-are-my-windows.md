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

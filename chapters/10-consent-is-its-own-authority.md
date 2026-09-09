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

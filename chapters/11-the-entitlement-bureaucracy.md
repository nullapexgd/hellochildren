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

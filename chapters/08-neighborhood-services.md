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

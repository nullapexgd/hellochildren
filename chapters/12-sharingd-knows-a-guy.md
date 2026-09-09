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

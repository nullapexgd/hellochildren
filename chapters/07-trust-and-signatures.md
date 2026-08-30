# 7. Trust and Signatures

An executable approaches the system.

It carries a signature, several entitlements, and a claim that notarization knows it personally.

Everybody at the desk asks a different question.

Code signing addresses integrity and signer identity under a trust model. Notarization records Apple’s malware check for submitted software. Gatekeeper applies launch policy. Trust caches, mandatory controls, and runtime enforcement answer other questions.

The family calls this entire layered system “the bouncer” because the family has been drinking.

## No single bouncer

It is tempting to put `amfid` alone at the door and say it decides whether code may exist.

That is a satisfying character and an inaccurate constitution.

AMFI spans kernel-side policy and supporting mechanisms. `amfid` participates in userspace validation and policy work, but code trust is not one daemon with a clipboard. Boot state, signatures, trust caches, entitlements, kernel enforcement, notarization, and Gatekeeper matter in different situations.

So the dialogue is a compression, not a protocol trace:

```text
Executable:
hello

amfid:
signature?
```

That question is **comic dialogue**. It is not an observed private protocol string.

The executable opens a folder.

```text
Executable:
Developer ID.

Gatekeeper:
notarization?

Executable:
stapled.

Kernel policy:
entitlements?

Executable:
here.

User:
I downloaded it from a forum called
DefinitelyNormalKernelTools.

Everyone:
why
```

## Eight badges

In the examined macOS build from the source conversation, `/usr/libexec/amfid` exposed eight entitlement keys. That number is a build-specific observation, not a universal constant.

The set included developer-mode control, NVRAM, protected storage, a keystore/keybag path, TCC allowance, hardened-process state, and IOKit access. The number destroyed a bad theory: more entitlements do not mean more authority.

The component crossing forty protected boundaries may need forty badges. The component enforcing one may need eight.

```text
sharingd:
I have 134 entitlements.

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

## Ad hoc code with ambitions

macOS can run code under several policies, and developers use ad hoc signatures legitimately. The joke targets code that confuses “I wrote the entitlement into XML” with “the system must grant it.”

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

This will disappoint fake launchd, who has already opened a text editor.

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
UID 2.

amfid:
leave.
```

## The title problem returns

Root arrives.

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
that is a different column.
```

Administrative choice can alter settings through authorized procedures. That is different from every request succeeding under the current policy.

The distinction sounds pedantic until it is the only thing separating a deliberate configuration change from arbitrary code execution.

## Trust is not virtue

The word *trusted* carries moral luggage. Computers do not care.

A valid signature is not a character reference. Notarization does not promise beautiful code. Trust mechanisms establish narrower facts: signer identity, integrity since signing, cache inclusion, policy satisfaction, or absence of known malware at a particular check.

```text
App:
Apple notarized me.

User:
are you good

App:
I passed a security process.

User:
are you useful

App:
that was not evaluated.
```

The most technically honest character in the chapter remains `amfid`, who has not once claimed to understand the app’s purpose.

```text
amfid:
signature?
```

Somewhere nearby, a system larger than the speaker checks the signature. The line works because `amfid` participates without becoming king.

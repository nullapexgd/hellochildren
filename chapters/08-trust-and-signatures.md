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

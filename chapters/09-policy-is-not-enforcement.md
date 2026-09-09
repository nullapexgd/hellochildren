# 9. Policy Is Not Enforcement

The executable leaves the signature desk carrying excellent paperwork.

Gatekeeper looks up.

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
that's your résumé.
```

Administrative authority is real. It can change some policies through authorized procedures. It does not force every policy check to return *yes* merely because UID 0 asked with excellent posture.

## Four verbs enter a security system

Descriptions of platform security become useless when every component is said to “protect the Mac.” A lock protects the Mac. So does a malware signature. So does refusing first launch. So does removing something that already ran. The verb needs an object and a time.

This chapter uses four:

```text
evaluate -> block -> detect -> remediate
```

They are not guaranteed to occur in that exact line for every file. The diagram is a vocabulary, not a private call trace.

**Evaluate** asks how a proposed operation fits policy. **Block** prevents an operation from proceeding. **Detect** recognizes something as known malware or suspicious material. **Remediate** responds after unwanted software or artifacts are present.

One component can participate in more than one verb. One favorable answer does not answer the next question.

```text
App:
my signature is valid.

Gatekeeper:
good for the signature.

App:
Apple notarized me.

XProtect:
I have newer definitions.

App:
I already passed.

Everyone:
which verb
```

## Gatekeeper works the arrival desk

Apple documents Gatekeeper around downloaded software and first open. It checks matters including identified-developer status, notarization, integrity, provenance, and user approval. It is not a tiny person intercepting every instruction the CPU executes.

That narrower job is still consequential. A program arriving from outside the App Store does not gain the right to launch by having a pleasing icon and a README that says “disable your antivirus.”

```text
Downloaded app:
I came from the internet.

Gatekeeper:
I noticed.

Downloaded app:
how

Gatekeeper:
you arrived carrying provenance
and a tutorial titled
HOW TO BYPASS THIS WARNING.
```

Users can approve particular software through documented controls. Managed policy can shape the available choices. Older command-line controls have changed over time; on the observed macOS 27.0 system, the `spctl` manual marks several rule-database and global-state modification options deprecated as of macOS 15.

That history matters. “An administrator could change this setting once” is not a timeless API contract. Authority can keep its name while the accepted form moves to a different office.

## The user can overrule a refusal, specifically

Apple provides a documented way for a user to approve a particular blocked app in Privacy & Security after attempting to open it. That is a scoped override made through an authorized interface. It is not the user abolishing code signing by clicking a button with feeling.

```text
User:
open anyway.

Gatekeeper:
for this app?

User:
yes.

Random unsigned thing nearby:
and me?

User:
who are you
```

The distinction explains why “the user is in charge” needs the same noun discipline as “root is in charge.” A user can supply approval where the policy accepts user approval. The user does not thereby become a signing certificate, a malware definition, or a kernel enforcement mechanism.

Root's role is similarly procedural. Administrator credentials can authorize changes that policy exposes to administrators. That does not turn the caller into the policy database or make a denied operation retroactively compliant.

```text
root:
I can change the rule.

Gatekeeper:
through the supported control.

root:
so I win.

Gatekeeper:
you have discovered settings.
```

## `syspolicyd` is an oracle, not a monarch

The local `syspolicyd(8)` manual calls `syspolicyd` the System Policy daemon. It says the daemon manages a policy database and serves as a general oracle other components may ask for a verdict on a proposed operation involving installation, loading, execution, or other use.

Oracle is Apple's word in the manual, which is almost unfairly good casting.

```text
Installer:
may I proceed

syspolicyd:
the policy says no.

Installer:
what do you personally believe

syspolicyd:
I am a database with office hours.
```

An oracle returns a policy verdict. Something still has to ask. Something still has to honor the result. A database row does not physically tackle a process.

```text
Policy:
deny.

Enforcement:
denied.

Policy:
I did that.

Enforcement:
you wrote it down.
```

This distinction is not an insult to policy. A map does not become useless because it cannot build the roadblock itself.

## XProtect checks the guest list again

Apple describes its malware defenses in layers. Gatekeeper and notarization help prevent or inhibit launch. XProtect uses threat intelligence and signatures to identify and block known malware, and Apple documents XProtect performing remediation as well.

The timing is the joke. A notarization check reports what Apple knew and evaluated for a submitted item at that time. Threat intelligence can change afterward.

```text
App:
I was notarized Tuesday.

XProtect:
it is Friday.

App:
I have a receipt.

XProtect:
I have an update.
```

This does not make notarization fake. It makes security knowledge time-dependent, which is ruder.

```text
Notarization ticket:
no known malware at assessment.

App:
so I am clean forever.

Notarization ticket:
I contain a date.
```

The phrase *known malware* contains the entire temporal boundary. A scanner cannot match a definition it does not have. A later definition does not travel backward and accuse the earlier service of perjury.

## MRT and the danger of immortal org charts

The observed macOS 27.0 build contains artifacts named `XProtect.bundle`, `XProtect.app`, and `MRT.app`. The names are directly observable. Their complete current division of labor is not something a directory listing can establish.

Apple's current platform-security documentation describes XProtect's detection and remediation roles. Older discussions often treat Malware Removal Tool, or MRT, as the remediation character. This edition keeps the installed `MRT.app` name as an observed artifact without forcing a historical org chart onto current private behavior.

```text
MRT:
I am still in the directory.

Narrator:
what exactly do you do now

MRT:
you have confused presence with semantics.

Narrator:
fair.
```

An installed name proves an installed name. A launch trace can prove activity under stated conditions. Neither gives us permission to invent the whole internal case-routing system because “MRT removes malware” fits nicely on a mug.

## A favorable answer is not diplomatic immunity

Now the app presents its collected approvals.

```text
App:
valid signature.

Signature desk:
yes.

App:
acceptable first-open policy.

Gatekeeper:
yes.

App:
no known malware match.

XProtect:
at this check, yes.

App:
then I may read the user's microphone.

TCC:
who invited you
```

That next refusal is not security contradicting itself. It is a new question about a protected resource and user consent.

Policy without enforcement is a wish.

Enforcement without policy is a very fast misunderstanding.

Neither sentence says policy and enforcement must live in one daemon. The system works because a verdict can cross a boundary without carrying every authority behind it.

The executable has proved its identity, survived an arrival policy, and avoided a known-malware match. It is now standing outside the microphone with no consent.

The résumé was excellent.

The next office wants the user.

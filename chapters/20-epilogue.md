# 20. One More Jurisdiction

We began with a useful lie: hardware at the bottom, kernel above it, userspace above that, and the purchaser floating near the top like a minor deity with AppleCare.

We end with a better picture.

Authority is always authority *over something*.

Boot ROM establishes the first trust in a boot chain and then leaves the argument.

XNU governs kernel execution on the Application Processor.

launchd organizes userspace services.

`loginwindow` coordinates authenticated session creation.

WindowServer governs a graphical environment.

Code-signing machinery establishes code identity. Gatekeeper and `syspolicyd` evaluate policy. XProtect brings time-dependent malware knowledge. Enforcement makes their answers consequential.

TCC asks for consent over protected resources. Entitlements carry signed capability claims to the borders that recognize them.

`sharingd` crosses an alarming number of protected boundaries in order to know a guy.

APFS presents System and Data volumes in one convincing coat. Snapshots make filesystem state plural. The seal asks whether changed system bytes belong to a boot-accepted state.

The MMU and DART make memory borders physical.

The GPU renders. ANE tensors. Storage translates. The display emits. The memory controller takes a number.

SEP protects a separate security domain and answers kernel privilege with the most devastating prepositional phrase in the book:

> On your processor.

Root remains powerful.

Fake launchd remains UID 2.

LaunchAngel remains unexplained.

The Civil War remains impossible. Its evidence note is the only participant whose authority survived the incident.

A guest kernel can govern a whole virtual world while the host schedules that world as a process.

The purchaser owns the machine in the ordinary human sense and can still lose an argument with a checkbox. Ownership authorizes enormous choices: erase it, recover it, lower a security policy through the proper path, install another system, or introduce it to gravity. It does not make every running protection mechanism interpret “I paid for this” as an access token.

```text
User:
I own this Mac.

Mac:
absolutely.

User:
then give me the key.

SEP:
which key.
```

This is not a story about nobody having power.

It is a story about nobody possessing power without a noun.

The front door opens one last time.

The last character is not an Apple component. It comes from another project and another layer of the joke.

```text
Linux:
I am the kernel.

hyprvisor:
that's awesome bro.

Linux:
give me the hardware.

hyprvisor:
no.

Linux:
I'M LITERALLY RING 0.

hyprvisor:
on your virtual machine.
```

Somewhere inside the guest, a process becomes root and feels a chill it cannot explain.

Linux stares at the virtual hardware.

The virtual hardware stares back.

hyprvisor clears its throat.

moo.

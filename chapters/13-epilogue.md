# 13. One More Jurisdiction

We began with a useful lie: hardware at the bottom, kernel above it, userspace above that, and the purchaser floating near the top like a minor deity with AppleCare.

We end with a better picture.

Authority is always authority *over something*.

Boot ROM establishes the first trust in a boot chain and then leaves the argument.

XNU governs kernel execution on the Application Processor.

launchd organizes userspace services.

`loginwindow` coordinates authenticated session creation.

WindowServer governs a graphical environment.

AMFI and its supporting mechanisms participate in code-trust enforcement.

`sharingd` crosses an alarming number of protected boundaries in order to know a guy.

The MMU and DART make memory borders physical.

The GPU renders. ANE tensors. Storage translates. The display emits. The memory controller takes a number.

SEP protects a separate security domain and answers kernel privilege with the most devastating prepositional phrase in the book:

> On your processor.

Root remains powerful.

Fake launchd remains UID 2.

LaunchAngel remains unexplained.

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

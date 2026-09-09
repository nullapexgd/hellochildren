# 17. The House Inside the House

After the Civil War, the book returns to technically defensible ways of putting software somewhere it was not born.

This time we use documented frameworks instead of Efeali typing `send`.

```text
Efeali:
I have another idea.

SPTM:
no.

Virtualization.framework:
I will handle this one.
```

A virtual machine lets one computer host another computing world. Inside that world, a guest kernel can create processes, manage guest memory, and govern guest devices. Outside it, the host still owns the resources that make the world possible.

A kernel can be sovereign in the house and still rent the house.

## Two frameworks, different altitudes

Apple's Hypervisor framework provides lower-level APIs for hardware-assisted virtualization. Apple's documentation describes virtual machines and virtual CPUs, with a VM represented in the host process and virtual CPUs associated with threads.

Virtualization.framework operates at a higher level. It provides configuration and lifecycle APIs for complete virtual machines, including supported macOS and Linux guests on Apple silicon.

```text
Developer:
I need a virtual CPU.

Hypervisor.framework:
how many

Developer:
I need a Mac.

Virtualization.framework:
finally, a different question.
```

The first framework is closer to CPU and memory machinery. The second helps assemble machines from configured devices, storage, networking, boot material, and guest resources. “Higher level” does not mean more privileged. It means the abstraction accepts a larger noun.

```text
Hypervisor.framework:
virtual processor state.

Virtualization.framework:
virtual machine configuration.

Developer:
which one is in charge

Both:
of what
```

We will stop here. Anyone attempting to introduce thirty pages of processor-control trivia will be placed in a guest with no network adapter.

## The nested jurisdiction map

The whole chapter fits in one diagram:

```text
host macOS
  |
  +-- host process + Apple virtualization frameworks
          |
          +-- virtual CPUs, guest memory, virtual devices
                  |
                  +-- guest kernel
                          |
                          +-- guest processes and services
```

The arrows mean “constructed from and constrained by,” not “the host personally performs every guest operation.” Once running, the guest kernel can schedule guest threads, expose guest filesystems, and enforce guest policy without asking the host to interpret every system call.

The host decides how much memory and how many virtual CPUs the VM receives. The guest decides what to do with the resources it sees.

```text
Guest kernel:
I manage all memory.

Host:
all 8 gigabytes I assigned you.

Guest kernel:
I did not request the adjective.

Host:
it was a number.
```

That is not fake authority. The guest's decisions are real inside the guest. A guest process that violates guest page protections does not escape punishment because the memory ultimately belongs to the host machine.

Jurisdictions can nest without becoming imaginary.

## The devices are convincing employees

A complete VM needs more than a CPU-shaped object. Virtualization.framework exposes configurations for storage, networking, displays, entropy, memory balloons, directories, and other devices depending on guest and platform support.

To the guest, those devices can look like the machine's hardware. To the host, they are resources mediated through the VM configuration and implementation.

```text
Guest:
my disk.

Virtual disk:
your blocks.

Host file:
my bytes.

Physical storage:
whose NAND

Everyone:
not now.
```

The abstraction is useful precisely because the guest does not need the host's full storage biography. It receives a device contract. The host remains able to stop the VM process, remove backing resources, or refuse a configuration the framework will not accept.

Inside the VM, `fsck` can feel like emergency government. Outside, the disk may be one file with a Finder tag.

## The abandoned apartments

> **Sidebar: rings 1 and 2**
>
> People often learn x86 privilege as four numbered rings, then discover that mainstream operating systems mostly built their lives around the most-privileged kernel ring and the least-privileged user ring.
>
> ```text
> Ring 1:
> I could have been somebody.
>
> Ring 2:
> we had floor plans.
>
> Ring 3:
> the apps are loud again.
> ```
>
> Apple silicon uses Arm's exception-level model rather than x86's ring vocabulary. The abandoned-apartment joke is historical shorthand, not an explanation of Apple virtualization. We are leaving before somebody brings a whiteboard to dinner.

## Root inside the guest

Root enters the virtual machine and immediately recognizes the furniture.

```text
guest root:
I own this machine.

Guest kernel:
within guest policy, mostly.

Host user:
pause.

guest root:
why did the universe stop
```

The host user does not become guest root by pausing the VM. Guest root does not gain host file access merely because its UID is zero. Each has authority over an object the other does not govern in the same way.

```text
guest root:
mount the host filesystem.

Virtualization.framework:
was a shared directory configured

guest root:
I am root.

Virtualization.framework:
in the PDF attached to your lease.
```

When the host exposes a shared directory or virtual network device, it creates an explicit bridge. The bridge has configuration and policy on both sides. It does not erase the boundary any more than a mailbox makes two houses one property.

## A world can be a process

From inside, the guest has boot, PID 1, users, daemons, filesystems, and perhaps its own argument about who owns the windows.

From outside, Apple documents the Hypervisor framework's VM as living in a user-space process. The whole guest civilization can therefore be contained by an object the host kernel schedules and can terminate.

```text
Guest launchd:
hello children

Host XNU:
one process.

Guest XNU:
I am literally the kernel.

Host XNU:
that is adorable.
```

The guest kernel's authority remains real. It is simply not the broadest authority relevant to its continued existence.

Privilege can end a world without understanding it. In virtualization, the world may have its own kernel, government, shutdown sequence, and strong views about this characterization.

## The lease remains upstairs

Virtualization is authority through abstraction with the paperwork left visible. The guest receives convincing processors, memory, and devices. The host keeps the resource boundary. Neither description cancels the other.

```text
Guest kernel:
I govern the machine.

Host:
you govern a machine.

Guest kernel:
same thing.

Host:
the indefinite article is in the lease.
```

There is one more consequence, but it belongs at the end of the book.

For now, everyone is invited to dinner.

This is a mistake.

# 21. The Firmware Nobody Invited

Userspace holds a census. Every respectable program receives a PID. launchd knows which services it started. Activity Monitor brings columns.

Then a controller executes code nobody can find in the process list.

## Nobody launched it

Firmware is software associated closely with hardware operation and startup. Some firmware executes on a peripheral processor. Some configures hardware before ordinary processes exist. It can be loaded and verified by an earlier boot stage or verified by a processor's own secure-boot chain.

None of that makes firmware supernatural. It means the Unix process model is not the only model of executing code in the machine.

```text
launchd:
show me your job label.

firmware:
no.

launchd:
bootstrap domain?

firmware:
also no.

launchd:
who raised you

Boot chain:
complicated question.
```

launchd's authority is enormous in the userspace civilization XNU creates. A peripheral processor is not an undocumented corner of that civilization merely because it lives in the same computer. It can have its own instruction stream, memory, firmware image, reset state, and startup rules.

The chapter title is a joke: the platform absolutely invited the firmware. launchd simply was not on the committee.

## Firmware is not one department

The word *firmware* covers too much to support one family biography.

Boot firmware participates in establishing the machine's early state and chain of trust. Device or controller firmware implements behavior close to a hardware block. Software on a peripheral processor may be downloaded at startup from the primary CPU or boot through a separate verification chain. Persistent firmware can have an update policy distinct from a runtime image loaded on every boot.

```text
User:
update the firmware.

Boot firmware:
whose

SSD controller:
whose

Display coprocessor:
whose

User:
the computer's

Firmware:
we have been over nouns.
```

Apple's public security documentation describes modern systems as containing peripheral processors for networking, graphics, power management, and other tasks. Where separate processors require firmware, Apple describes two broad protections: download verified firmware from the primary CPU at startup, or have the peripheral processor implement its own secure boot.

Those are categories, not a claim that every controller follows one sequence. Product and generation matter. The book refuses to turn “firmware verified” into a universal boot command shouted simultaneously across the SoC.

Verification answers a bounded question too. A signature and policy can establish that an image is acceptable to load under a particular trust scheme. They do not prove the firmware is bug-free, that its configuration is correct, or that every command it receives is wise. Authentic mistakes remain authentic.

```text
Verifier:
approved image.

Security review:
approved behavior?

Verifier:
different meeting.
```

Updates add time to the boundary. An update package can be authenticated before installation, and a processor can verify what it boots later. Rollback policy, activation, and recovery are component-specific. The chapter will not compress all of them into “Apple signed it, therefore Tuesday happened.”

## The controller has opinions

A controller can accept requests through registers, queues, shared memory, or another device-specific interface and execute firmware that interprets them. By the time an application request arrives, its original nouns may be gone.

The storage controller does not receive a Finder path. A display coprocessor does not receive “make the window feel more premium.” A network controller does not receive a process's moral case for low latency.

```text
Application:
please perform the feature.

Driver:
command prepared.

Controller:
queue entry accepted.

Application:
did you preserve my intent

Controller:
I preserved bits 7 through 12.
```

Firmware's authority is narrow but concrete. It can govern the controller's local operation, scheduling, or protocol within its design. It does not become the kernel because it executes code, and XNU does not become the firmware's line manager because it submitted a request.

The controller also sees a different world. It may know ring positions, command identifiers, buffer addresses, link state, temperature, or error codes that have no direct representation in the calling application's model. Conversely, it may know nothing about windows, users, paths, or why the request exists.

```text
Controller:
queue 3 stalled.

Application:
the user is getting impatient.

Controller:
is that a register

Application:
emotionally.
```

Abstraction works because the driver translates between those worlds. Translation does not make either description fake. It lets the application avoid learning a device protocol and lets the controller avoid learning product management.

An error may originate there and travel upward through layers that cannot repair it. The driver can translate the result. The kernel can wake a waiter. The application can display “Something went wrong,” the traditional GUI representation of five jurisdictions refusing to name the guilty party.

## Other processors have childhoods

Chapter 2 introduced the hardware relatives briefly because boot must prepare more than the Application Processor. Now the gray rectangle labeled HARDWARE can testify.

```text
Application Processor:
everybody ready?

Display controller:
firmware verified

Storage controller:
firmware verified

Thunderbolt controller:
I brought—

DART:
don't
```

Some specialists receive firmware from the primary processor. Some establish trust within their own boot environment. The Secure Enclave, explored later, is a particularly strong example of a distinct processor and security domain. Other coprocessors have different protections and responsibilities; sharing the category *peripheral processor* does not make them miniature SEPs.

Public Asahi Linux reverse engineering supplies useful names and implementation detail for particular Apple-silicon generations, such as DCP for display work and S5E for NAND/SSD control on documented targets. Those receipts are explicitly reverse engineering, not Apple documentation and not a license to generalize one chip's topology across the family.

```text
XNU:
I loaded your firmware.

Peripheral processor:
thank you.

XNU:
so I am your kernel.

Peripheral processor:
you delivered lunch too.
```

Loading an image is authority over a startup input. It is not proof that the loader schedules every instruction afterward, owns the processor's local policy, or understands its private runtime state.

## What's your PID

The inevitable census begins.

```text
launchd:
I manage userspace.

firmware:
cool.

launchd:
what's your PID

firmware:
my what
```

The exchange is dramatization. “firmware” is a composite character, not an Apple process hiding its PID, and no real component said this. Its architectural claim is modest: firmware executing outside the ordinary macOS process model does not acquire a Unix PID merely to make Activity Monitor comfortable.

This does not mean no firmware-related helper ever appears in userspace. Update tools, loaders, diagnostics, and services can be ordinary processes. Their PIDs identify those processes, not every processor or firmware image they help manage.

Likewise, a firmware blob stored in a filesystem is not executing merely because it exists. It becomes operational only through the component's loading or boot process. The file can have a path and signature; the running firmware can inhabit another processor with neither a pathname nor a Unix task. One artifact participates in two jurisdictions at different times.

```text
launchd:
then how do I restart you

firmware:
which reset domain

launchd:
kickstart service

firmware:
that's adorable.
```

Reset, reload, update, and restart are different operations. Their availability and authority depend on the component. A user-space service can be restarted without resetting its device. A controller can reset without rebooting the whole Mac. A firmware update can require verification and a later activation step. The verbs need objects again.

```text
User:
turn it off and on again.

launchd:
the service?

Driver:
the interface?

Controller:
the engine?

Power Management:
the domain?

User:
I regret asking experts.
```

A reboot may incidentally restart several of these relationships, which is why it often helps and rarely explains anything. The successful ritual does not identify which layer was stale.

Firmware can therefore be alive, authenticated, outdated, waiting, wedged, or perfectly healthy while the service above it is broken. “The firmware” is not a diagnosis. It is a neighborhood.

And every house in that neighborhood has a different reset switch.

The hardware relatives are not above launchd. They are outside the jurisdiction that makes launchd's usual questions meaningful.

That distinction protects the book from a tempting hierarchy. Boot ROM is not CEO of the display controller. A storage controller is not subordinate to a GUI process in the organizational sense. The components participate in dependency and control relationships that name specific images, resets, commands, buffers, and results. “Runs earlier” and “runs underneath” are not ranks.

The firmware nobody invited was invited by boot policy, hardware design, or a driver. It simply arrived before the seating chart and refuses to wear a PID sticker.

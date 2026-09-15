# 20. You Never Talked to the Hardware

The user clicks a button. The application says it sent the request. The kernel says it handled the operation. The driver says it programmed the device. The device says it did the work.

Everybody is telling the truth at the level where they invoice.

## The application takes credit

Consider a client application communicating with a DriverKit extension. Apple documents DriverKit as a framework for drivers that run in user space. Its sample client uses an `IOUserClient` connection and method calls to exchange validated data with a driver, including asynchronous callbacks.

This is one documented route for one class of interaction. It is not the secret universal pipeline behind every click on macOS. Some devices use Apple-provided drivers, some paths stay in kernel code, some frameworks expose higher-level services, and memory-mapped or other direct mechanisms exist under controlled conditions.

Our application will nevertheless announce victory immediately.

```text
Application:
I told the device.

Driver:
you called my client interface.

Application:
through the system.

Driver:
you filled in a structure.
```

That structure matters. A user-client boundary does not accept human intention; it receives arguments. Apple's DriverKit sample contrasts checked and insecure dispatch paths and validates properties such as counts and structure sizes before calling the driver's method.

The application may be perfectly authorized to request an operation and still submit malformed input. Authority to knock is not authority to redesign the doorbell packet.

```text
Application:
but the user clicked Print.

Driver method:
scalar input count?

Application:
the icon was blue.

Driver method:
structure size?
```

## The kernel forwards the complaint

DriverKit drivers run in user space, but that does not mean an application simply finds the driver process and begins shouting across ordinary memory. The system manages the service and connection. DriverKit's `IOUserClient` represents a connection to another service managed by the system; framework calls carry requests across the boundary.

The kernel's role varies with the family and operation. It may provide transport, enforce access, manage objects, map memory, and coordinate with the hardware-facing service. Saying “the kernel did the I/O” can be useful shorthand. It can also hide the driver that understands the device-specific contract.

```text
Application:
kernel, make the hardware do it.

XNU:
which service

Application:
the hardware one.

XNU:
I see the problem has arrived pre-debugged.
```

Delegation is not abdication. The system still controls which driver may run and which clients may connect. DriverKit uses entitlements for driver and user-client access. The driver receives authority over a defined interface, not a transferable deed to the platform.

Nor is “user-space driver” a demotion into ordinary applicationhood. It has a specialized framework, lifecycle, entitlements, device relationship, and system-managed communication path. PID alone cannot explain the job.

The kernel also remains the office that can revoke the relationship when a process exits, a service stops, or policy changes. The client cannot preserve access by photocopying a connection handle into a text file. Handles name live kernel-managed relationships; they are not bearer bonds redeemable after the objects behind them disappear.

```text
Application:
I saved the connection number.

XNU:
the connection is gone.

Application:
but the number is right here.

XNU:
frame it.
```

This resembles file descriptors without making every I/O connection a regular file. The reusable lesson is object lifetime: a small integer or language object represents authority only while the system relationship behind it remains valid.

## The driver owns a translation problem

Hardware does not usually want the application's pointer. Chapter 16 already prosecuted that address for impersonating a universal coordinate.

DriverKit provides memory-descriptor objects for describing buffers and sharing them across relevant boundaries. An `IOBufferMemoryDescriptor`, for example, can hold data moving into or out of a driver and can be passed to APIs that map it for another process. A hardware operation may additionally require device-accessible mappings under the platform's DMA protections.

The driver therefore receives several questions disguised as one buffer:

```text
Application:
here are my bytes.

Driver:
whose address

Application:
mine.

Driver:
the device is not you.

DART:
and neither of you is automatically mapped.
```

The exact mapping and hardware APIs depend on the driver family and device. We do not invent them here. The durable lesson is that software must turn a client-visible object into a buffer and address contract the relevant device can use, for long enough to complete the operation and no longer.

That lifetime is authority with a clock. Releasing or reusing a buffer before completion can make yesterday's legitimate mapping point at today's unrelated data. The device cannot infer that the application has moved on emotionally.

## The queue has never heard of your button

Drivers handle concurrency and asynchronous events. DriverKit's `IODispatchQueue` serially executes submitted blocks, and DriverKit provides dispatch sources for events such as timers and hardware-related interrupts. A request can be accepted while waiting its turn; an asynchronous completion can arrive later.

```text
Application:
the button click happened first.

Driver queue:
in the interface.

Application:
so the operation happened first.

Driver queue:
you have confused arrival with completion.
```

Queues provide order within their stated scope. A serial driver queue can order its blocks without proving the physical device finished the corresponding operations in that same moment. The device can have its own command queues, firmware, and completion mechanism. “Queued,” “submitted,” “accepted,” and “completed” are separate receipts again.

Cancellation adds another noun. Stopping future queue work is not necessarily undoing an operation already submitted to hardware. DriverKit documents queue cancellation in terms of stopping dequeue and waiting for in-flight tasks. Whether a particular device command can be canceled is a device contract, not a motivational speech from the application.

Completion travels upward too. A device event can lead to a hardware-related interrupt source, driver work, and an asynchronous callback, depending on the interface. The callback is not the hardware itself visiting the application. It is the system delivering a result through the relationship established earlier.

```text
Application:
the device called me.

Driver:
I invoked your completion.

XNU:
after an event.

Device:
I changed one electrical condition.

Application:
team effort.
```

Polling is another possible path: software can check state rather than wait for an interrupt. That difference matters to performance and timing, but not to the chapter's point. Either way, the application's high-level action becomes device-specific work and returns through defined boundaries.

## The device did the work

Eventually the device changes a register, moves bytes, emits a packet, produces samples, or performs whatever operation its interface defines. The driver interprets completion and reports upward. The framework delivers a callback. The application redraws its icon and claims it personally moved electrons.

```text
Device:
done.

Driver:
operation completed.

XNU:
client may resume.

Application:
I did it.

Device:
what is your voltage
```

This is not a universal five-stage pipeline. A display update, storage request, USB transfer, neural-network operation, and network packet use different frameworks and hardware paths. Some operations avoid a client-driver round trip. Some hardware is controlled by kernel components or firmware. Direct access can exist behind mappings and policy. The example proves delegation, not one mandatory staircase.

Even “device” may name a logical service rather than one physical component. Drivers can compose, and one request can cross several services before reaching a controller. Counting boxes in a diagram does not establish constitutional rank; it establishes how many places can return an error.

It also explains why every layer can report an error the others could not predict. The client can fail validation. The service can be unavailable. Mapping can fail. The queue can stop. The device can reject a command. Completion can report a hardware-specific result. Nobody needs total authority to ruin the afternoon.

Success is equally scoped. A client method can return successfully because the request was accepted. A driver can report submission success because the command reached the device queue. A later completion can report the device result. If the operation involves persistent media or a network peer, additional boundaries remain. One green checkmark cannot inherit promises from offices it has not visited.

The application has authority over its requested feature. The system has authority over the connection. The driver has authority over a device interface. DART has authority over DMA translation. The device has authority over whether its physical operation succeeds.

You talked to an abstraction that talked to an abstraction that arranged a very specific audience with hardware.

The cable remains innocent. A cable should still not be a constitutional amendment.

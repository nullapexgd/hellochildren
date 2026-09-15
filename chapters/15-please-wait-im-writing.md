# 15. Please Wait, I’m Writing

## The Save button has made an announcement

The author presses Save. A dot disappears from the window title. This is the most reassuring punctuation event in computing.

Somewhere beneath it, a much less reassuring discussion concerns the word *done*.

```text
Application:
saved.

User:
so I can relax.

Application:
I have updated the interface.

User:
that wasn't the part I was worried about.
```

An application's Save command has whatever contract that application gives it. It might wait for a completed storage operation, delegate to a document framework, or announce progress while work continues. The button's appearance alone tells us none of that. Our example will follow ordinary buffered output to a local regular file; other routes exist, and nobody is required to visit every desk here.

The application first has bytes it wants to store. It may also have an output buffer in its own process. A library can accept output into that buffer without having sent all of it through a system call yet. For a C output stream, `fflush` pushes buffered data through the stream's underlying write function.

That is useful progress. It is also a reason to ask where a buffer lives before declaring that it has been flushed. Emptying an application buffer and emptying a storage device's volatile cache are different work, even though both get the same gratifying verb.

```text
Application buffer:
empty.

User:
the data is safe?

Application buffer:
the data has left me.

User:
you sound like my shipping notification.
```

A crash before the program submits buffered output can lose work that never reached the filesystem. That is an earlier failure than losing submitted data during a power cut. The distinction matters because asking the filesystem to finish cannot recover bytes the application has not handed it.

## Accepted is not completed

At the system-call boundary, `write()` attempts to write a specified number of bytes through a descriptor. Its successful result is a byte count. That number deserves to be read.

Under the interface's permitted conditions, a write can transfer fewer bytes than requested. The program must handle the actual result and any error rather than translating “returned something nonnegative” into “the whole chapter is safe.” We'll give our example the easier case: the requested count came back in full.

```text
Application:
4096 bytes, please.

write():
4096.

Application:
forever?

write():
you passed a size, not a prophecy.
```

The success has real meaning. In the ordinary regular-file model, a subsequent successful read of those positions sees the new data until it is modified again. The current file state has changed. Calling that merely an illusion would erase the very contract that lets programs exchange data through files.

But a read can obtain the current bytes while storage work remains. Seeing the new contents in another window, or reading them back immediately, does not simulate losing power. The machine is still powered, with its useful temporary state intact.

Filesystem work includes more than carrying the paragraph's bytes downward. It must maintain the information that makes those bytes reachable as part of a file: contents, size, allocation, and whatever bookkeeping the operation requires. The exact work depends on the filesystem and operation. There is no single procession in which every Mac writes the same structures in the same order.

Apple describes APFS crash protection using copy-on-write. A filesystem can protect its structural consistency and still recover a state older than the application's latest intention. A perfectly readable previous draft is a consistent filesystem's way of ruining your afternoon.

In our example, a successful ordinary write establishes the updated file state. A durability request asks for more: finish the relevant work under a contract that reaches the required storage boundary. The pause between those promises can be productive batching, until the author starts leaning toward the power button.

## Close is not a sworn affidavit

`close()` releases a descriptor. On the last relevant reference it also permits cleanup of the open instance. The file doesn't need a reader to stay named in its directory; the name and open lifetime were separate in the previous chapter, and they remain separate when a writer leaves.

```text
Application:
I closed it.

Filesystem:
thank you for returning the key.

Application:
so the building is earthquake-proof.

Filesystem:
what
```

Close can report an error from previously uncommitted output. That is one reason its result matters. Successful close, however, is not a documented demand that the device flush all its buffered writes into permanent storage.

When a process exits, its descriptors are freed. Even a clean exit therefore tells us about the process finishing; by itself it cannot certify durable storage. Keep that distinction handy for the evening when XNU decides to dismiss the entire staff.

`fsync` is a more pointed request. On macOS, its manual describes moving modified data and attributes from the host to the drive. The same manual warns that a drive may still buffer or reorder writes, leaving some or all of the data unwritten after power failure. It uses platter-era language, but the host/device distinction isn't abolished by replacing a spinning disk with flash.

For the stronger operation, macOS provides `fcntl` with `F_FULLFSYNC`. The installed manual describes an fsync followed by a device flush request. Its stated guarantee concerns data previously fsynced on that same device: “data that had been fsync'd on the same device before is guaranteed to be persisted when this call returns.”

That sentence has a subject, a scope, and a completion point. APFS is among the documented supported filesystems. The call can take time, and an error result cannot be treated as success.

```text
Application:
why are we waiting

F_FULLFSYNC:
because you asked a stronger question.
```

## The controller has its own inbox

“The device completed it” sounds final until we ask what *it* was. A normal write completion and completion of a flush request need to be interpreted under their respective contracts. The word *completion* doesn't silently append “through any future loss of power” to every operation.

Device buffering helps explain why software asks for a stronger boundary. A device can have accepted data that still depends on power. To demand persistence, the request has to cover that remaining work, and the device has to honor the request.

Apple's full-sync manual even retains a warning about certain FireWire drives ignoring flush requests. That is a warning about those devices, not a discovery that the Mac's internal SSD is lying. It does explain why a documented request and compliant hardware both belong in the sentence about guarantees.

```text
Controller:
completed.

Application:
the write or the flush

Controller:
look at your request.

Application:
I named it saveFinalReallyFinal.

Controller:
that did not reach this department.
```

Below the filesystem, flash translation also prevents an application from assigning every byte a permanent seat in NAND. Persistence is about being able to recover the required data under the storage contract. It does not require that the application know which physical cells currently hold it. A controller's internal placement work is not a file manager with smaller icons.

The exact hardware can change while the host's buffers and the device's pending work remain separate concerns. The application's receipt has to cover the work it is relying on.

## Please survive the lights going out

There is another problem even after the individual writes acquire respectable receipts. Suppose an application stores a balance in one record and a corresponding history entry in another. It wants both changes to represent one completed transaction. Persisting only one can leave durable bytes describing an incomplete application operation.

The filesystem can be healthy while the application's accounts disagree. The application needs a protocol that makes its own group of changes recoverable. Naming every operation “Save” does not supply that protocol.

```text
Filesystem:
the records are readable.

Application:
they disagree about where the money went.

Filesystem:
I preserve your writing.
I don't do your books.
```

For a document, replacing the old file with a newly written file creates a related boundary. A name replacement can give readers an orderly transition between objects. That namespace behavior alone doesn't establish that the replacement's payload has reached permanent storage. The writer still needs the appropriate persistence operations and error handling for its chosen save method. There isn't a universal two-line recipe hiding in the word *atomic*.

So the question at the power button is specific: which state has the application promised to recover, after which successful operations, under which failure? An application crash and loss of device power stop different pieces of the work. Neither is reproduced by politely closing a window and opening it again.

The author does not need a NAND map. The author needs the software's “saved” to match the promise they depend on, with the relevant work completed before the celebration.

```text
User:
please survive the lights going out.

Storage stack:
that's the request.

User:
can you make the wait less annoying

Progress indicator:
I have been training for this my whole life.
```

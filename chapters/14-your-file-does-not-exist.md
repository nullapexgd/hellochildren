# 14. Your File Does Not Exist

The title is something a filesystem might say during a difficult breakup. It needs a qualification: the name you supplied might no longer identify anything, while the file you already opened remains perfectly usable.

Computing has found a way to make “it's over” depend on reference counting.

## The name at the door

`/Users/efeali/book.txt` looks reassuringly specific. It has slashes. It has a surname. It ends in a format modest enough to survive several generations of software ambition.

It is a pathname: instructions for finding something through a directory tree. A directory entry associates a name with a filesystem object. The object supplies the contents and attributes; the name is how a lookup gets there. Several names can refer to the same regular file through hard links, so the name cannot also be its one true soul.

```text
File:
my name is book.txt.

Directory:
that's what I call you.

Other directory:
I call him final-final.txt.

File:
please don't introduce me like that.
```

Lookup has a starting place. An absolute pathname begins at the process's root; an ordinary relative pathname starts at its current directory. `openat` can instead start a relative lookup from a directory descriptor. The short name `book.txt` leaves quite a lot of the address on the envelope blank.

The route can also contain indirection. Familiar macOS paths `/etc`, `/tmp`, and `/var` lead through symbolic links into `/private`. The user can spend years navigating these paths without noticing the extra component.

```text
User:
/var

Filesystem:
/private/var

User:
why hide the word private

Filesystem:
it was in the path.
```

A symbolic link supplies another path to follow. A firmlink joins the paired locations from the previous chapter. A mount point exposes another filesystem. The tree makes them convenient to traverse without making them the same mechanism.

macOS even supports a limited set of synthetic links and empty directories at the root, described by `synthetic.conf` and constructed during boot. A synthetic empty directory can provide a mount point; it is not an ordinary writable folder waiting to receive children. Being visible in a listing is a remarkably small job description.

## Open after disappearance

Suppose a program successfully opens our ordinary local text file for reading. It receives a file descriptor, a small integer in that process's table of open references. We'll call it `7`.

The integer refers to an *open file description*, the open instance with such state as its access mode and current offset. That description refers to the file. The distinction becomes less bureaucratic when the directory starts deleting things.

Another process successfully calls `unlink` on the file's last name. The directory entry disappears. A fresh attempt to open that pathname, without asking to create it, now fails because the name is absent.

Our first program can keep reading through descriptor `7`.

```text
Directory:
he no longer works here.

Reader:
I'm talking to him.

Directory:
then please stop using reception.
```

Removing the last link postpones removal of the file's contents while open references remain. This is ordinary Unix file lifetime, assuming the unlink succeeds. It is not a special undelete privilege and doesn't need the Trash to intervene. A graphical application's Delete command may have a different workflow; `unlink` is the specific operation at this meeting.

Now create a new file under the old name. New lookups can reach the replacement. The first reader still holds the earlier object, which has not been promoted into the replacement merely because the two share a former address.

That gives us a perfectly respectable state of affairs in which one reader sees the old draft and a newly opened reader sees the new draft. Both can truthfully say they opened `book.txt`. Their opening times matter.

Nor is `7` permanent identification. Closing it releases that descriptor slot for reuse. A later open may return `7` for something else. Writing the number on a sticky note does not preserve the relationship.

There can also be several descriptors for one open description: duplicating a descriptor shares its current offset, whereas opening the file separately creates a separate open instance. Two bookmarks can therefore turn out to be the same bookmark. Unix has been doing collaborative editing to people's file positions for decades.

## Which version exists

An open reference preserves access to an object through a name change. It does not freeze the object's contents. If someone modifies that same live file, keeping it open is not a request to retain yesterday's paragraphs.

A snapshot supplies a different kind of continuity. It records a read-only volume view at a particular time. Imagine a Friday snapshot containing the old draft. On Saturday the live volume's draft changes. Reading the snapshot and reading the live volume can give different contents under corresponding paths without either read being wrong.

```text
Live file:
I've grown.

Friday snapshot:
you still think this needs a blockchain.

Live file:
THAT WAS A WORKING DRAFT.
```

The same distinction covers absence. A file created after Friday's snapshot can exist in the live view and have no entry in Friday's view. A file removed from the live view can still appear in a retained earlier snapshot. Closing the last live open reference doesn't order every snapshot to forget its own state, and logical removal isn't a physical-erasure certificate.

Mounts add a question about where the reader is standing. Mounting a filesystem at a directory normally exposes the mounted filesystem's contents there and hides the directory's previous contents until unmount. The covered files have not been deleted. Their usual route is occupied.

```text
User:
this directory used to have my notes.

Mount point:
this entrance now serves another building.

User:
did you demolish the first one

Mount point:
we put up a sign.
```

A mounted disk image or network share can inhabit the same tree as local storage. The slash does not announce that the next operation will have a different failure mode. It certainly doesn't promise that a remote server obeys the local filesystem's every lifetime detail.

This is why “I can see it” and “my program can't open it” need an actual path and context before becoming an argument. There may be a permission failure, a changed name, or a different mounted view. An error return is evidence about that attempted operation, not a census of all the world's copies.

## The storage department objects

XNU would like to get on with the read.

```text
XNU:
read /Users/efeali/book.txt.

SSD:
what's a Users

XNU:
...

SSD:
what's a file
```

This is dialogue about the filesystem/block-storage boundary, not a trace of a command XNU sends. By the time an ordinary file read needs storage I/O, software has work to do turning its request into something that the storage interface can service.

Darwin's virtual filesystem machinery, or VFS, gives different filesystems a common set of ways to participate in the kernel's file operations. A vnode is the kernel's representation of an active file or directory. Filesystem-specific code supplies the operations and the knowledge of that filesystem's structures.

The vnode isn't another spelling of the pathname, the application's descriptor, or a physical spot in flash. It is useful to the kernel because it represents an object the kernel can work with. It doesn't need a tiny folder icon to accomplish this.

```text
Application:
my document.

VFS:
file operation.

Filesystem:
I can work with that.

SSD:
finally, somebody will send something usable.
```

Flash introduces its own translation. Apple's APFS documentation describes a flash translation layer that can group writes into NAND blocks; separate logical locations do not let the caller dictate exact physical placement. The bytes don't retain a little `/Users` badge that the controller consults while deciding where to put them.

None of this makes the file imaginary. It makes the file a software object whose storage depends on other representations. The SSD character's offense is that the introductions have arrived several abstractions too early.

## Existence needs a noun

Our draft can now have a missing name, a surviving open reference, and an earlier version in a snapshot. A replacement can take its old pathname while an existing reader finishes the original. The storage beneath those views is still doing storage, without becoming the arbitrator of which draft the author meant.

For the author, “the file” is the manuscript. For a particular read, it is the object reached by that reference in that view. The disagreement usually stays invisible because the layers cooperate. It becomes visible exactly when someone insists that renaming, deleting, replacing, opening, and retaining a version must all mean the same thing.

```text
Author:
fine. this object, through this reference,
in this view.

XNU:
beautiful.

Author:
please save these bytes.

XNU:
we've reached a different problem.
```

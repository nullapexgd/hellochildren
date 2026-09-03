# 6. Who Owns the User Session?

The Mac has booted. XNU governs execution. launchd has populated userspace. You still do not exist.

Computationally. We cannot help with the other kind.

Your account can exist in a directory while nobody is logged in. Your password can be accepted before your desktop exists. Your desktop can exist while a background service associated with your account has no window at all. These facts travel together so often that the wallpaper encourages us to call them one thing.

The wallpaper is lying.

## Please authenticate before existing

Enter `loginwindow`, carrying the kind of keyring that causes a belt injury.

Apple's detailed public account of this territory is historical. Its archived daemon-lifecycle documentation describes `loginwindow` coordinating the visual and security portions of login, then setting up the authenticated user environment. Current device-management documentation still exposes `com.apple.loginwindow` as the payload type for Login Window behavior.

That supports a durable role, not a promise that every private call path from old OS X survived unchanged. The receptionist still works here. We are not publishing the floor plan behind the desk.

```text
loginwindow:
I have a hundred keys.

launchd:
because you keep coming to my building.

loginwindow:
how many keys do you have for launchd

launchd:
ask whom?
```

An account name answers *which recorded identity?* Authentication answers *has this attempt supplied acceptable proof?* A session answers *which live environment is being formed for that identity now?* One may lead to the next. None is a synonym for the next.

```text
User:
password.

loginwindow:
one moment.

User:
why

loginwindow:
we are determining whether you exist,
whether you may exist here,
which version of you is logging in,
and what furniture that version expects.
```

Authentication, directory identity, keychain state, preferences, and graphical startup are related. They are not one operation named `let_human_in()`.

The family metaphor calls `loginwindow` the receptionist. This is unfair to receptionists, who are rarely responsible for initiating an authenticated computing environment while the guest repeatedly asks why the wallpaper has not appeared.

## The account was already here

This is the part humans find suspicious. If the account already existed, what exactly did login create?

Not the account. A live relationship between that identity and this period of activity.

The distinction explains several otherwise haunted observations. Files can belong to a user who is asleep. A scheduled system task can refer to an account with no desktop on screen. Two processes can carry the same numeric user identity yet inhabit different moments, service contexts, or expectations about what “the current session” means.

The book will not turn that last sentence into a claim about one undocumented internal object. It is the safer architectural point: persistent identity and live session state answer different questions.

```text
Account record:
I've existed for three years.

loginwindow:
congratulations.

Account record:
so I am logged in.

loginwindow:
you are a row with a home directory.

Account record:
harsh.

loginwindow:
accurate.
```

Logging out makes the boundary even clearer. The account remains. Its files remain. The particular user environment can end. Identity survives the party because identity was never the party.

## Root arrives without an appointment

Root assumes UID 0 should simplify the encounter.

```text
root:
I do not need to log in.

loginwindow:
then you do not need a graphical session.

root:
I want the desktop.

loginwindow:
for which authenticated user environment

root:
the root one

loginwindow:
please stop inventing products at the desk
```

Unix credentials matter. They can answer file-access and process-privilege questions with tremendous force. They do not manufacture an authenticated human, choose the active user's preferences, or make every per-user service regard the caller as its resident.

This is where root becomes ceremonial in a very specific sense. The title remains real. The ceremony is root announcing it to an office currently asking for a different noun.

```text
root:
I can read the user's files.

loginwindow:
that is a file answer.

root:
I can signal the user's processes.

loginwindow:
that is a process answer.

root:
I am running out of answers.

loginwindow:
you brought the wrong form.
```

## The apartment above the system

Once a user environment is active, services and agents can live in a per-user context rather than the root system context. Chapter 4 called launchd's world a civilization; here we discover it has zoning.

A system daemon may serve the whole machine. A user agent may belong to one logged-in environment. An application may arrive later and ask that environment for a service by name. The exact private construction has changed across releases and contains more machinery than this family portrait shows. The point is the boundary: machine-alive and user-present are different conditions.

```text
system service:
I've been awake since boot.

user agent:
I live with Efe.

system service:
the account?

user agent:
the current session.

system service:
same thing.

loginwindow:
absolutely not.
```

Account ownership does not make the service global. System scope does not make the daemon a member of every user's session. launchd can organize both without pretending they occupy one flat household.

This is also why “the user launched it” can be a useful explanation and a terrible complete specification. Which user identity? Which active environment? Which service context? Which policy accepted the request? The ordinary sentence compresses all four because ordinary people are trying to open Calendar, not defend a dissertation before breakfast.

Inside the machine, the missing nouns still matter.

## The handoff the user calls “the Mac”

The session becomes visible only after authority passes through several jurisdictions. This is the map; the next chapter lives in its right-hand half.

```text
account identity + authentication
              |
              v
         loginwindow
              |
              v
  authenticated user session
      |                 |
      v                 v
per-user services   WindowServer
                          |
                          v
                    GPU execution
                          |
                          v
                 display scanout -> light -> user
```

Nothing in the diagram is promoted to supreme owner by appearing lower or farther right. `loginwindow` does not render. A user agent does not become WindowServer because it owns a menu. WindowServer cannot authenticate the person by arranging the password field beautifully.

At the end of login, the account has become a live user environment. The services in that environment can answer. The graphical government can now construct the world the user will recognize.

Root can still end many of its processes. That does not mean root formed the session, understands it, or can substitute a title for the identity it was built around.

Privilege can end a world without understanding it. That is power, not government. Apple and modern politics still argue about who invented this.

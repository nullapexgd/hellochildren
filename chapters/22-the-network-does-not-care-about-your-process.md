# 22. The Network Does Not Care About Your Process

The application opens a socket. The network receives a packet. Between those sentences, the process loses most of its biography.

Packets do not cross a link carrying a Unix PID because the sender was proud of it.

## The socket knows locally

A socket is a local operating-system object exposed through a descriptor. It connects a process to a networking endpoint and protocol state. Local policy can know which process opened it, which credentials applied, which sandbox rules matter, and which interface choices are allowed.

```text
Process:
socket 12 is mine.

Network:
what's a 12

XNU:
local descriptor.

Network:
keep it local.
```

Calls such as `connect`, `send`, and `recv` operate through that local object. Their return values describe work at the socket interface. A successful send does not mean a remote application accepted the message, just as writing to a file did not automatically prove durable storage.

Buffers make that distinction practical. The stack can accept bytes from the process while transmission and acknowledgment remain pending. Backpressure can later make another write block or fail. The socket's local success is meaningful—it accepted the specified work—but it cannot sign a receipt on behalf of an unseen peer.

```text
send():
accepted.

Application:
delivered?

send():
I work at departures.
```

Socket type and protocol matter. A stream supplies different semantics from a datagram. A local Unix-domain socket does not traverse an Ethernet PHY merely because the API contains the word socket. This chapter follows an ordinary Internet packet far enough to show boundaries, not to invent one universal path.

## The packet leaves without your PID

The networking stack turns application data into protocol data under the rules in use. Transport and network headers carry protocol-defined fields: ports, addresses, sequence state, checksums, and other information appropriate to that protocol. The sender's macOS PID is not an Internet routing field.

```text
Application:
tell them process 472 sent it.

TCP:
port.

IP:
address.

Application:
UID?

IP:
not a routing field.
```

Local tools and policy engines may attribute traffic to processes because the operating system can relate sockets to tasks. That attribution is real and useful. It is not evidence that every router or receiver sees the local process table.

Addresses can also be rewritten or hidden by tunnels, relays, and network address translation beyond the process's view. The source identity visible to a remote server can differ from the local interface state. This chapter makes no claim about which such mechanisms a particular connection uses; it merely refuses to treat a local endpoint as a globally preserved biography.

Checksums provide integrity checks for defined fields and failure patterns. They do not authenticate the human sender. Sequence numbers organize a transport stream. They do not establish moral seniority among packets. Protocol fields possess the authority their protocol assigns and no more.

Likewise, network-layer addresses identify interfaces or endpoints under a network protocol; they are not CPU virtual addresses from Chapter 16. Port numbers help transport demultiplexing; they are not Mach ports. Computing reused *port* because the original ambiguity was insufficient.

## The interface chooses a door

Routing and interface selection decide where traffic should go next. A Mac can have Wi-Fi, Ethernet, loopback, tunnels, and other interfaces. Policy, route state, destination, and availability influence the choice.

```text
Packet:
I need to leave.

Routing table:
destination?

Packet:
the internet.

Routing table:
that is not a row.
```

The selected interface has its own framing and link behavior. An IP packet carried over Wi-Fi is not transmitted as raw source-code intent. It is packaged for the link, handed toward the relevant driver and controller, and eventually represented as signals by a radio or physical interface.

Virtual interfaces complicate the picture usefully. A tunnel can accept a packet and produce another packet. Loopback can deliver locally without a physical link. Packet filters can deny or transform traffic. “Sent to the network” needs an interface and observation point.

Name resolution happens before or beside this route and has its own caches and policy. Turning a hostname into an address does not open a socket, authenticate a service, or prove that packets can reach it.

```text
DNS:
here is an address.

Application:
connection established.

TCP:
we have never met.

DNS:
I gave directions, not a ride.
```

## The controller speaks link

The driver translates between the operating system's networking objects and the interface hardware's contract. A controller may work with descriptors, buffers, rings, queues, and completion events. The exact design varies; this is not a claim that every Apple network device uses one named queue or firmware ABI.

```text
Network stack:
packet for this interface.

Driver:
buffer prepared.

Controller:
descriptor accepted.

Application:
did they read my message

Controller:
I moved bits toward a link.
```

The PHY or radio handles physical signaling for its medium. It does not parse the application's account name to decide whether a voltage transition is sincere.

```text
PHY:
signal transmitted.

TCP:
acknowledgment pending.

Application:
recipient accepted?

Remote service:
who are you people
```

Each completion answers a narrower question. Hardware can finish transmitting a frame that never reaches its destination. The network can deliver bytes to a host whose service rejects them. A transport acknowledgment can establish transport progress without proving the human recipient approved the content.

Reliability is similarly scoped. TCP can retransmit and order a byte stream between endpoints. It cannot force the receiving application to commit a transaction, save a file, or keep the data after acknowledging it at another layer. UDP provides different promises. Applications that need end-to-end confirmation define it in their own protocol.

```text
TCP:
bytes acknowledged.

Application:
order fulfilled?

Remote database:
transaction rejected.

TCP:
I do transportation.
```

The reverse path has the same delegation in another direction: signals become frames, buffers, protocol input, socket data, and eventually something a waiting process can read. The packet does not seek the process by PID across the network. The local stack uses protocol state and local socket relationships to deliver it.

## Identity can be packed deliberately

Higher-level protocols can explicitly carry identity, authentication tokens, certificates, account identifiers, or signed claims. That is how an application can make identity meaningful to a remote service: it encodes the relevant evidence into a protocol the other side understands.

```text
Application:
finally, my identity.

TLS:
which identity and proof

Application:
I am logged in.

Remote service:
to whom
```

This qualification matters. “The network does not care about your process” is not a claim that networks carry no identity or that privacy systems cannot attribute traffic. It means local process identity is not automatically inherited by every lower layer. Identity must be preserved or re-established deliberately where the protocol needs it.

Encryption adds another boundary. Link hardware can transmit ciphertext without knowing the application data. An intermediary can route packets without possessing the endpoint's keys. Authority to carry the envelope is not authority to read the letter.

Metadata survives differently from content. Encryption can protect payloads while leaving enough addressing and transport information exposed for networks to deliver them. Which fields remain visible depends on the protocol. “Encrypted” therefore needs the same follow-up as “address”: encrypted from whom, at which layer, covering which bytes?

```text
Router:
I can forward it.

Application:
so you can read it.

Router:
the post office can read street names.

TLS:
please stop opening the envelope metaphor.
```

Firewalls and packet filters exercise policy over traffic they can classify. They may use interface, address, port, direction, connection state, or locally available process information. A permitted packet is not endorsed content; a blocked packet is not proof the application lacked every other authority. The filter governs passage at its boundary.

Network policy can still block by process locally, by address or port at another layer, by authenticated identity at an application service, or by many other scoped facts. None is the universal network authority.

Observability follows the same rule. A packet capture, socket listing, controller counter, and application log see different portions of the trip. Their disagreement can be honest because each instrument stands at a different border.

```text
Process:
I sent it.

Socket:
accepted bytes.

Stack:
constructed packets.

Interface:
selected a door.

Controller:
moved a frame.

Network:
best effort, babe.
```

Somewhere in that sequence the process may block waiting for space, data, or completion. The CPU will then be accused of waiting, despite possibly running something else entirely.

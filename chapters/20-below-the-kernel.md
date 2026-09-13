# 20. Below the Kernel

What does kernel authority presuppose?

The last chapter gave XNU an opportunity to discover one answer by ceasing to be available for follow-up questions. For this chapter, the cast has been restored by the ordinary literary procedure of beginning another scene. Nobody should infer a recovery protocol from the fact that the kernel has lines again.

XNU arrives with a revised claim. It will no longer insist that it governs everything. It will insist that everything important requires it.

This sounds more defensible until somebody asks what *it* requires.

## The floor has prerequisites

XNU executes on the Application Processor. Those instructions need a processor on which to execute; kernel privilege does not make them self-executing. We have spent a book examining what becomes possible once the kernel runs. The question now concerns the conditions under which that sentence can begin.

```text
XNU:
I provide the execution environment.

Application Processor:
and I execute it.

XNU:
yes.
for me.

Application Processor:
you have added a preposition
where the electricity goes.
```

The Application Processor belongs to an SoC platform. That relationship is integration, not process parentage. The SoC did not fork a CPU. Nor does being part of the same platform dissolve the separate processor and security domains that caused the dinner to go badly.

XNU wants the platform to be its equipment. SoC wants the residents to acknowledge the platform. Both can get through an ordinary working day without settling that domestic disagreement. Neither can settle it by drawing a taller box around the other.

If we draw arrows here, each needs its own verb. XNU *executes on* the Application Processor. The processor is *integrated into* a platform. Platform operation *depends on* power-management hardware and firmware. The machine is *supplied by* a battery or external power. An external source may be *connected through* electrical infrastructure.

These are different relationships. An execution environment, physical integration, power control, stored energy, and electrical supply do not become one chain of command because they fit on the same page. Later, ownership, regulation, and taxation will attempt to squeeze onto the page too. They will not improve the diagram.

```text
SoC:
I would like a box.

XNU:
you already have a box.

SoC:
you labeled it hardware.

XNU:
accurately.

SoC:
your box says sovereign execution authority.

XNU:
also accurately.
```

The argument reaches the edge of the diagram, where somebody has finally noticed the power connection.

## A supply is not a title

Platform power management involves hardware and firmware, including work assigned to peripheral processors. There is no need to invent a single secret office that personally grants electricity to every other component.

For the following scene, **Power Management is a dramatized ensemble role**, wearing one name tag on behalf of work distributed across a platform. The name identifies this cast role, not one universal Apple component. The hardware and infrastructure characters are fictional speakers throughout.

Battery and Charger have also been invited. This makes the setting a laptop, not a claim that every Mac has an internal battery. Charger is the cast's name for the external charging setup; it is already taking more personal credit than a power adapter and cable deserve.

```text
XNU:
I control execution.

SoC:
on which hardware?

Power Management:
while powered how?

Battery:
using whose energy?

Charger:
whose energy?

Battery:
GET THE FUCK OUT.
```

Battery's objection is understandable. It has spent the entire book being represented by a small percentage while components with much less remaining capacity deliver speeches about ownership.

But the objection also conceals a problem. Stored energy and the means of replenishing it are different things. Battery can supply the laptop while the cable is absent. Charger can arrive with an external source without becoming the owner of Battery's contents. Neither relationship resembles a parent process supervising a child.

```text
Battery:
I was here when you were unplugged.

Charger:
and how did that go.

Battery:
beautifully.

Charger:
for how long.

Battery:
this is a hostile interview.
```

The interval matters. A charged battery lets a laptop operate away from external power for a limited time. Dependence need not mean an uninterrupted live connection to the same source. The machine can carry some of the conditions of its continued operation with it.

That is a new kind of answer to the jurisdiction question: not *who can refuse me right now*, but *how long can I continue before I need something again?* Battery has acquired bargaining time. It has not acquired infinite energy or jurisdiction over the kernel's memory protections.

```text
root:
can I extend the interval.

Battery:
close something.

root:
I meant administratively.

Battery:
administratively close something.
```

Power control introduces another distinction. Managing a supply does not manufacture its energy. The name *Power Management* sounds like it belongs to the most senior person in a very unpleasant company. In this room, its problem is that everyone hears the first word and ignores the second.

```text
XNU:
I need more power.

Power Management:
what is available.

XNU:
that sounds like a question for a subordinate.

Power Management:
it is a question for a supply.
```

The physical terms do not negotiate merely because software can express a preference. A laptop may be connected to a source that provides enough power to run it without charging the battery. Under a demanding workload, it can also use more power than the connected source supplies. The cable being present does not settle the balance.

```text
Charger:
I am connected.

Battery:
I am decreasing.

Charger:
both statements can be true.

XNU:
I hate this family.
```

This is why *connected*, *running*, and *charging* cannot serve as synonyms. They answer different questions about a machine that looks exactly as plugged in in all three cases. The little connector is not a certificate that every demand downstream will be satisfied.

Nobody has discovered a hidden monarch. They have discovered a budget that continues to apply during the constitutional argument.

## The other end of the cable

Charger enjoys its promotion for almost a paragraph. Then somebody follows it to the wall.

```text
Charger:
I provide power.

Outlet:
you are welcome.

Charger:
I was speaking.

Outlet:
while plugged into me.
```

For the ordinary wall-powered charging arrangement, the adapter connects the laptop to an external electrical supply. The outlet is a connection point, not an inexhaustible source. Following it takes the discussion into the building's electrical connection and, where that connection is supplied by a grid, into infrastructure beyond the machine.

The jurisdiction map has now left the motherboard.

An outlet can be local while its supply is not. In a conventional grid arrangement, generation, transmission, and distribution have distinct jobs: electricity is generated, moved across the network, and delivered to consumers. They need not share a single owner. The business selling the electricity and the utility delivering it may also differ.

```text
Outlet:
I would like to clarify that
I do not own a power plant.

XNU:
then who did I just threaten.

Outlet:
a socket.
```

Utility and Grid arrive together and object to being given one chair. Here, *utility* names an organization; *grid* names interconnected infrastructure. A conventional power plant contributes generation to that system. Calling the plant the boss of the network would confuse making electricity with governing everything involved in delivering it.

```text
Utility:
whose name is on the account.

XNU:
mine should be.

User:
it is not.

Grid:
can the account discussion happen
somewhere that is not my diagram.
```

Ownership and public authority vary by jurisdiction. An electricity provider may be privately owned, publicly owned, or a cooperative; government may appear as regulator, owner, customer, or legal authority in different arrangements. None of those descriptions supplies one universal ladder from the wall socket to a head of state.

The cast has nevertheless ordered a podium.

## The hearing becomes inadmissible

From here, Government and IRS are satirical personalities, and the later Physics, Causality, and Spacetime are a metaphysical postscript. Their exchanges are invented, not evidence about grid control, tax procedure, or cosmology. The technical dependency argument has reached its limit; the characters have refused to leave.

Government opens a folder with the seriousness of someone about to use the word *framework* until everyone forgets the question.

```text
Government:
depending on the jurisdiction,
my relationship to this infrastructure—

IRS:
did somebody say income.

Government:
no.

IRS:
I'll wait.
```

IRS has interrupted the explanation. It has not been inserted into the electrical delivery path. Nobody is proposing that electricity passes through a tax office between generation and the outlet. The interruption is American bureaucracy entering an argument that had not even agreed to take place in America.

Government tries again.

```text
Government:
there are several different capacities
in which I might appear.

XNU:
pick your highest privilege level.

Government:
that is not how this works.

SEP:
he needs to hear it from everybody.
```

For once, Government would like to be treated as a collection of limited offices with different responsibilities. It has chosen a terrible room in which to request that courtesy. XNU has spent nineteen chapters arriving at meetings with a single noun and expecting the furniture to kneel.

The utility puts down a bill. Government puts down a regulation-shaped prop. IRS puts down an entirely different folder. None of these objects plugs into the laptop. Each participant is offended that this observation seems relevant.

```text
User:
which one of you turns it on.

Government:
that is not the question before us.

User:
it was my question.

Government:
we have referred it.

launchd:
to whom.

Government:
a working group.

launchd:
finally.
a service definition.
```

Power Plant has been silent through this exchange. It had expected the room to become less metaphorical upon its arrival. Instead, everyone has acquired folders, and the word *power* is being used in several senses without any attempt to compensate the original supplier.

It pushes its chair back.

```text
Power Plant:
I AM LITERALLY THE POWER PLANT.

SEP:
on your grid.
```

There is a pause long enough for XNU to experience something close to solidarity.

```text
XNU:
first time?

Power Plant:
I expected the word literally to help.

XNU:
so did I.
```

The plant begins drafting a complaint. Its difficulty is choosing the respondent. Grid is still objecting to the seating plan. Utility is asking for an account number. Government has referred the matter to itself in another capacity. IRS has underlined something nobody said.

SEP has provided no forwarding address.

## No earlier office

The complaint now requires a cause more fundamental than anybody in the room. The hearing leaves public administration and appoints Physics, who has made the mistake of having laws in its name.

Physics arrives without a badge. This immediately concerns everybody who has spent the book treating badges as the beginning of reality.

```text
XNU:
where is your enforcement mechanism.

Physics:
you have been sitting in it.

XNU:
can I inspect the policy.

Physics:
you can try to describe it.

Gatekeeper:
developer cannot be verified.

Physics:
that is going to be a recurring problem.
```

The cast is now arguing with a personification of physical law as though it were a badly documented service. This is metaphysical slapstick. No claim about an actual origin of the universe can be obtained by interviewing this witness, who has been written chiefly to disappoint the power plant.

Power Plant wants somebody to have approved the arrangement. If nobody approved it, then the whole hearing has been taking place under rules nobody in attendance issued. This feels procedurally intolerable to a room full of characters who have confused explaining a condition with granting permission for it.

```text
Power Plant:
there must have been a meeting.

Physics:
why.

Power Plant:
look at the consequences.

launchd:
I have no record of the meeting.

Physics:
you arrived rather late.

launchd:
I am PID 1.

Physics:
locally.
```

That word makes the room worse.

Government asks whether the original decision can be appealed. Physics asks which decision. IRS asks whether the original conditions had a filing status. Causality, who had hoped to remain an abstract concern, requests standing before the discussion becomes any earlier.

Power Plant mistakes the objection for progress. At last, another participant. Surely the next witness will identify the official who signed the beginning. The complaint can then proceed in an orderly fashion, provided the beginning has kept its paperwork.

```text
Power Plant:
Physics.

Physics:
what.

Power Plant:
who authorized the Big Bang.

Physics:
that's not really—

Power Plant:
WHO SIGNED OFF ON
INITIAL CONDITIONS

Causality:
I object.

Physics:
on what grounds

Causality:
you're asking for authorization
before there was a "before."

Power Plant:
wrong jurisdiction?

Causality:
wrong temporal domain.
```

```text
Physics:
Spacetime?

Spacetime:
...

Physics:
Spacetime?

Spacetime:
zzz
```

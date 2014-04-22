# Human interaction with the robotic platform

// TODO: Decide on and, if desired, elaborate on getting data
// from experiments out

Few software project are in themselves useful without a way to
interact with the world. The world in the case of Splotbot is mainly
the scientist designated to use the system. A world consisting of
scientists can potentially be a large and diverse one, in the interest
of being useful for as large a subset as possible it seems advisable
to aim for the lowest common denominator and preferably make it easy
to extend at a later time. Keeping in mind that the end-user is likely
to have advanced use-cases in mind for the EvoBot, it is relevant to
not limit the usage of the platform with the user interface.

## Requirements

The following is a summary of the thoughts behind the requirements for
the EvoBot user interface. It is to be seen as an informal discussion
with actual formal requirements marked with **bold**.

At the lowest level of requirements for the EvoBot platform we have
that it **must provide the user with the ability to control as well as
receive feedback from it**. This control requirement is trivially
required, the feedback is thought of as visual feedback from a camera
as well as some status messages about how a task has been or is being
performed. The visual feedback is required in a scenario where the
robot is out of sight from the scientist, e.g. under a fume hood.

When defining requirements for the user facing part of a system it is
certainly advantageous to consider the end-user of the system. The
users of the EvoBot will be scientists occupied with advanced chemical
and/or biological experiments. Acknowledging the highly specialized
expertise these people possess coupled with the ever present fact that
humans rarely are experts in many things at once, one important
property of the EvoBot is that it 
**must run without special technical setup**. 
This means that the barrier to start using the EvoBot must be
inconspicuously small. This does not mean that there must be no setup
process, but the steps, if any, should only have to be performed once
and not have an impact on ongoing use. This enables a technician
on-site to perform the installation for seamless ongoing usage.

The complement to the previous arguments is that we, the designers of
EvoBot, certainly do not possess the expertise to figure out which
experiments will actually be beneficial to run on the platform. It is
therefore important to not design a user interface that will
eventually get in the way of the user. It is important that the
interface isn't limiting with respect to advanced/unforeseen
use-cases, but rather that the GUI of the EvoBot 
**must never overshadow functionality that the EvoBot platform can 
perform**. Specifically the interface should always provide the user with
access to control the lowest common denominator of functionality, e.g.
direct access to driving a motor. Inversely it should also be possible 
for a user to command the robot in an efficient manner. This poses the
requirement on the user that she has a certain level of EvoBot
proficiency. Such proficiency could for instance be the ability to
write in a programming language understood by the EvoBot. As for what 
"efficient" actually means, it is thought of as a way to provide the user
with the ability to "replay" experiments without actively controlling the
EvoBot. Thus, it **must be possible to program experiments** to run on
the EvoBot.


The final requirement for the EvoBot interface is a non-functional one.
Developing the robot is a constant reminder that the platform has certain
limitations when it comes to computational power. Therefore
it is relevant to aim for a solution that has a low performance overhead
and allows favours the limited resource platform. This is a
hard-to-quantify requirement and is therefore only stated informally.

## Description of the current solution

The above requirements ties in with one of the overall requirements for
the project. Name that concerning high availability for the
user. This is to be understood as the ability for anybody on any kind
of reasonable PC to be able to run the software. Little research is
required to realize that this calls for some form of common runtime.
In the modern world of heterogenious platforms this common runtime
realistically is a web browser, and preferably a reasonably up-to-date
one. It is considered as a prerequisite for the Splotbot that such a
platform is present on the client PC, and the GUI can therefore safely
be implemented in web technologies.

With the above goals in mind, a design consisting of two components is 
proposed:

- Overlying web GUI interface presented to the user, run on her computer
- A communications layer run on Beaglebone, interacting with
aforementioned GUI and the underlying EvoBot software. Mediating
messages between the two.

Narrowing the technologies down to "web" is not really a precise
definition. The world of web is a large one with an abundance of
frameworks doing identical or similar things. The EvoBot client does
not require very exotic features in this regard, but must support
calls against a REST server and provide support for constructing
a reasonably looking GUI. No member of the team has extensive flair
for UI- or aesthetic design, so any help a in this regard is a plus.

The framework AngularJS was chosen for the frontend client as it
provides all the features (and more) that was seen as requirement.
Furthermore there exists tools around it which can help with
generating the files and structure, compensating for the teams lack of
knowledge in the UI field.

The communication layer is written in NodeJS as it is built with great
support for web clients while boasting support for low-level interaction
with C and C++. It has a third not insignificant advantage that the 
BeagleBone runs a variant of the language as its native scripting
language. There are no plans to rewrite any parts of the robot-interacting
code in javascript, but its reassuring to know that the platform is 
natively, and likely actively, supported.

The integration between the two layers is very tight in the sense that one
will not work make sense without the other. It makes sense therefore to 
make sure that full interdependence exists between the two layers. This
is in practical terms achieved by having the communication layer be
responsible for hosting the client layer. This has the added benefit of
minimizing the steps needed for starting the EvoBot.

The communication layer is agnostic towards which client run on
top of it, making it possible to make different clients work equally
well. The communication layer will have to be computationally light,
but will be responsible for a lot of IO work. It should aim to not
slow down the EvoBot.

With knowledge of the platform it should be possible to circumvent
all GUI control and command the robot using a high-level programming
language with meaningful semantics. This is achieved by simply providing 
a basic text field for input of commands.

## Reflection

- It is working
- It gives us blah blah blah
- We are not dancers

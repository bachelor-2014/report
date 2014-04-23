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
receive feedback from it (R1)**. This control requirement is trivially
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
**must run without special technical setup (R2)**. 
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
perform (R3)**. 
Specifically the interface should always provide the user with
access to control the lowest common denominator of functionality, e.g.
direct access to driving a motor. Inversely it should also be possible 
for a user to command the robot in an efficient manner. This poses the
requirement on the user that she has a certain level of EvoBot
proficiency. Such proficiency could for instance be the ability to
write in a programming language understood by the EvoBot. As for what 
"efficient" actually means, it is thought of as a way to provide the user
with the ability to "replay" experiments without actively controlling the
EvoBot. Thus, it **must be possible to program experiments (R4)** to run on
the EvoBot.

The final requirement for the EvoBot interface is a non-functional one.
Developing the robot is a constant reminder that the platform has certain
limitations when it comes to computational power. Therefore
it is relevant to aim for a solution that has a low performance overhead
and allows favours the limited resource platform. This is a
hard-to-quantify requirement and is therefore only stated informally.

## Description of the current solution

The above requirements ties in with one of the overall requirements for
the project. Namely that concerning high availability for the
user. This is to be understood as the ability for anybody on any kind
of reasonable PC to be able to run the software. Little research is
required to realize that this calls for some form of common runtime.
In the modern world of heterogenious platforms this common runtime
realistically is a web browser, and preferably a reasonably up-to-date
one. It is considered as a prerequisite for the Splotbot that such a
platform is present on the client PC, and the GUI can therefore safely
be implemented in web technologies. Furthermore there is an informal
requirement stated above regarding usage consumption. The least limiting
way of achieving this is to move the computations to the client pc. 

With the above goals in mind, a design consisting of two components is 
proposed:

- Overlying web GUI interface presented to the user, run on her computer
- A communications layer run on Beaglebone, interacting with
aforementioned GUI and the underlying EvoBot software. Mediating
messages between the two.

### The interface elements

The actual elements shown in the GUI is determined from the config
file as described in \ref(sec:modularity). The GUI has the same kind
of modularity as the rest of the EvoBot, which means that every
element in the config file has a standalone component in the GUI. This
fulfils two of the stated requirements, namely **R1** and **R3**:
Since the elements that move the robot around and gives visual
feedback is defined in the config, making a GUI element for them and
let the bootstrap process always instantiate all elements will assure
that this functionality is always exposed to the user. 

One requirement that is not solved with all the config defined
components is **R4**. As it is concerning programming these very
components, it is inevitably on a higher level and requires special
configuration. Thu GUI part of is shamefully simple, a text field. The
underlying functionality warrants for a specialized language for these
features, which has lead to the development of Rucolang.

// TODO: Describe or ref Rucolang

### The bootstrap process

Using the EvoBot must be as simple as possible, as **R2** prescribes.
This means both for starting up the board and actually using it as an
end-user. The first part is easily achieved as we have full control of
what is going to happen. Seeing as the client only makes sense with
the rest of the EvoBot, starting it will also start all other parts
of the system. We've chosen a platform that can interoperate with the
rest of our codebase and as such the compile and run process can easily
be triggered be the communication layer. Lastly, as mentioned, we have
full control over this startup process, which means that it can all be
started as a service when the board starts. This will require a technician
only if something goes wrong in the process.

In terms of ongoing use, the control is less in our hands. We have many
good reasons for running the client on the users PC, but it does have
the drawback that it requires some, albeit small, amount of work done
by the user, giving up our control. Specifically we require that:

- The user is on the same network as the EvoBot,
- The user knows the IP of the EvoBot

The last requirement is the harder to solve. It is possible to discover the
EvoBot using standard unix utilities, but the process differs already 
between Mac and linux. It is unclear if it is even possible on a windows
or mobile platform. There is the solution that we give the control to
technicians on-site. Specifically technicians who have control over the 
network. That way it is possible to always assign the same IP to the EvoBot
based on its mac address.

### Choice of technologies

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
will not work without the other. It makes sense therefore to 
make sure that full interdependence exists between the two layers. This
is in practical terms achieved by having the communication layer be
responsible for hosting the client layer. This has the added benefit of
minimizing the steps needed for starting the EvoBot.


## Reflection

It makes sense to reflect on the two seperate elements of this design
atomically as the strengths and weaknesses of one should not impact
the other.

### Reflection on architecture 

Overall the architecture chosen solves the issues we hoped for it to
solve and is in itself a solid concept. The idea of having a thin
layer in between the backend C++ code and the frontend makes a lot of
sense with our goals in mind, and has proven to be nicely uncoupled
when developing the platform. Furthermore the design has good
prospects for future development as the communication layer is
agnostic towards which client run on top of it, making it possible to
make different clients work equally well. 

### Reflection on technologies

The strengths of a chosen technology often becomes more clear when
viewed in the company of alternatives. Our overall choice of
technology, web and a REST server solves our requirements and comes
with a few extra bonuses, including but not limited to:

- Keeping the pages static the GUI can in its entirety be moved to the
client PC for rendering, sparing precious resources on the Beaglebone.
- A huge amount of libraries for GUI related stuff.

Possible alternatives to web technologies would be using a cross
platform GUI library such as GTK, QT, java-swing, etc. But they all
have the major flaw of requiring software to be installed locally,
possibly alienating some users.

#### Change of Web technologies

As for the specific choice of AngularJS, it was done mostly based on:
- Prior experience within the team
- the fact that it is a fairly stable framework with some years behind it
- it has large corporate backing by google and by a large online community.

Plenty alternatives exists for angular, mainly divided into two categories:
- Similar Javascript frameworks
- Languages that compile to javascript, with a framework around it

In the first category, there are plenty to choose from, but they're all
either younger/less mature and/or has less support/learning resources.
The second category is exciting because Javascript is no ones
favourite language. The thought of changing it for something better is
very appealing, and there seems to be one for every style
of programming:

- Lisp: Clojurescript,SchemeToJs
- Functionally: Elm(Haskell-subset), js_of_ocaml (OCaml).
- Imperative: Dart, llvm-to-js, Go2js

All of these would make for an exciting project on their own, and
could provide some much missed features to the world of web-programming.
Their are also not all esoteric, as some of them has large backing
and communities around them. Unfortunately their are all too
much of a risk to pick up and use for an important project as this.

#### Change of communication layer

There is no shortage of languages that provides both support for RESTful
interfaces and libraries for this task. Many languages also has
decent support for interfacing with C, though this is often a task
with varying success as the libraries for doing so are both complex and
often unmaintained. NodeJS seemed as the stronger candidate because
despite being a relatively new entrant already shines in many of these
areas and is used by so many in varying settings from hobby-hackers to
large corporations. Within the team there was experience with both NodeJS
and solving the same task in other languages (python, C#, etc.), and
NodeJS was voiced as the simpler way out. Its also relatively lightweight
and is built with non-blocking IO in mind, making it unlikely that this
layer will become a bottleneck in the project.

When actually using the technology it was discovered that ease of use
was not as high as one could have hoped. The most noteworthy of these
issues is the interoperability with C as it was one of the major
reason for choosing the language. There was both an element of
actually not getting things to work, and a feeling that the
combination just is not ideal. The thing that caused the most trouble was 
using callbacks between the two languages, which resulted in using a work
around with curl in lieu of getting the advertised functionality to work.

The idea that the combination is less-than-ideal springs from subjective
observation where the solution seems "clunky". There is much to be said
about a language like javascript which lacks conveniences that we've come
to love such as types and integers. Even more is to be said about
combining it with languages that has a rich type system like C++ or a
language like C where integers are quite omnipresent, but it is a subject
for another time. For now it makes sense to mention how the development
process has been firsthand. It is largely dominated by a lot of casting
to odd predefined types, that often seems a bit for from the underlying
datatypes in C and C++, which prompts thoughts about whether the languages
are too far apart, and if a language closer to C would make the process
easier. The second consideration is that it must be rather inefficient 
to keep crossing such a high barrier, which may be improved with a
language with more similar semantics. The second thing that feels "clunky"
is the build process itself. Instead of regular Makefiles
we are left with a specialized JSON file, which partly consists of
text you would place in a Makefile, but now coupled to specific keys
in a map structure which is sparsely (if at all) documented. This results
in a lot of guessing about things that are usually trivial and likely
could have been kept in a more familiar way.

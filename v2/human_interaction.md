# Human interaction with the robotic platform

// TODO: Decide on and, if desired, elaborate on getting data
from experiments out

Few software project are in themselves useful without a way for the software to
interact with the world. In the case of EvoBot the world is mainly
the scientist designated to use the robot. A world consisting of
scientists can potentially be a large and diverse one, in the interest
of being useful for as large a subset as possible it seems advisable
to aim for the lowest common denominator to some extend and preferably make it easy
to extend at a later time. At the same task, end-users are likely
to have advanced use-cases in mind for the EvoBot, making it relevant to
not limit the usage of the platform with the user interface. This section
describes our experiences with trying to live up to this.

## Goals

The following is a summary of the thoughts behind the concerning the user
interface of EvoBot. It is to be seen as an informal discussion with actual
formal goals marked with **bold**.

The main value that EvoBot seeks to provide its users stems from the top level
goal that it **must provide the user with the ability to control as well as
receive feedback from it**. The goal is apparent directly from the expected uses
of the robotic platform. The user is expected to program an experiment, which
EvoBot can then run. The experiment data must the be available for the user to
see, so the experiment data can be used in research. As an extension of this
goal, we seek to allow the user to **see experiment data while the experiment is
running**, as this allows for the scientist to monitor an experiment while it is
running. One could imagine e.g. that the user wished to run an experiment
without knowing exactly what to expect. By allowing real-time result data
monitoring, the experiment could keep running, until the user decides to
terminate it based on the result data. The following goals are concerned further
with how to achieve this interaction with the robotic platform.

When considering the goals it is certainly advantageous to consider the end-user
of the system. The users of the EvoBot will be scientists occupied with advanced
chemical and/or biological experiments. Acknowledging the highly specialized
expertise these people possess coupled with the ever present fact that humans
rarely are experts in many things at once, one important property of the EvoBot
is that it **must run without special technical setup**.  This means that the
barrier to start using the EvoBot must be inconspicuously small. This does not
mean that there must be no setup process, but the steps, if any, should only
have to be performed once and not have an impact on ongoing use. This enables a
technician on-site to perform the installation for seamless ongoing usage.

The complement to the previous arguments is that we, the designers of EvoBot,
certainly do not possess the expertise to figure out which experiments will
actually be beneficial to run on the platform. It is therefore important to not
design a user interface that will eventually get in the way of the user. In
order to balance between functionality and easy of use, we set the goal of the
graphical user interface to **not overshadow functionality that the EvoBot
platform can perform**.
Specifically the user interface should always provide the user with
access to control the lowest level of functionality, e.g.
direct access to driving a motor, making sure that any unexpected uses of the
robot requiring the doing of so is equally possible as expected uses.
At the same time, we strive to make the expected use as efficient as possible.

An 'experiment' can be many things, and it is not possible to foresee all the
different experiments the user might need to run. We therefore find it necessary
that the **user can program experiments making use of every functionality of
EvoBot**. For this we pose a requirement on the user that she has a certain
level of EvoBot proficiency. Such proficiency could for instance be the ability
to write in a programming language understood by the EvoBot, as to give
ourselves a fair chance of not trying to cope with providing both very high
usability while keeping the complexity of the functionality. Sticking to what we
are familiar with, programming languages, is a way of limiting the scope of the
project.

The final goal for the EvoBot user interface is a non-functional one.
Developing the robot is a constant reminder that the platform has certain
limitations when it comes to computational power. Therefore it is relevant to
aim for a solution that has a low performance overhead and allows favours the
limited resource platform. This is a hard-to-quantify requirement and is
therefore only stated informally.


## Description of the current solution

The goal concerning the barrier of entry of starting to use EvoBot is one that
has a strong effect on how the user interface is build, as anybody on any kind
of reasonable PC to be able to run the software. Little research is
required to realize that this calls for some form of common runtime.
In the modern world of heterogenious platforms this common runtime
realistically is a web browser, and preferably a reasonably up-to-date
one. It is considered as a prerequisite for EvoBot that such a
platform is present on the client PC, and the GUI can therefore safely
be implemented in web technologies. Furthermore there is an informal
requirement stated above regarding usage consumption. It is therefore
advantagous to move as much of the computation to the computer of client, which
can be done by running the application in a web browser. 

With the above goals in mind, a design consisting of two components is 
proposed:

- Make EvoBot server er web client to the user that runs on her computer
- Have a communications layer run on BeagleBone, interacting with
aforementioned graphical userinterface and the underlying EvoBot software,
mediating messages between the two.


### Construction of the graphical user interface

The actual elements shown in the GUI is determined from the config file as
described in \ref{sec:modularity}. The GUI has the same kind of modularity as
the rest of the software running the EvoBot, which means that every element in
the config file has a standalone component in the GUI. An example could be a set
of X/Y axes which can be homed in moved. As shown in figure
\ref{fig:gui_screenshot_controls}, this functionality is graphically available for the
user to access. This helps achieving two of the goals, namely that the user
can control the low level parts of EvoBot (the single components) as well as
the user receiving feedback from running experiments. 

![The graphical user interface provides a control for each component of EvoBot.\label{fig:gui_screenshot_controls}](images/todo.png)

The graphical controls do, however, not help with solving the goal of
programming experiments. It is rather achieved by introducing a domain specific
language for controlling the robot as described in chapter
\ref{sec:experiment_interaction}. The graphical user interface can, however, aid
the user in programming in this language. Therefore, a simple text editor
with syntax highlighting is included in the web client with a button to run
the code on EvoBot as shown in figure \ref{fix:gui_screenshot_rucola}. This
makes the flow of programming and running experiments as simple as possible
and furthermore without requiring the user to install anything on her
computer.

![The graphical user interface provides a text editor with syntax highlighting in which experiments can be programmed and run.\label{fig:gui_screenshot_rucola}](images/todo.png)

As a final note, the GUI contains a page showing all the experiment data logged
as described section \ref{sec:experiment_data}. Figure
\ref{fig:gui_screenshot_logging} shows a screenshot of this page.

![The page where the user can see, download, and clear logged experiment data.\label{fig:gui_screenshot_logging}](images/todo.png)


### The bootstrap process

If using the EvoBut is to be as simple as possible, this includes starting up
the robotic platform as well as connecting to it. The first part is easily
achieved as we have full control of what is run on the BeagleBone. By running
the all the software as a service which starts up when the BeagleBone boots,
including the software the serves the client application to the web browser of
the user, means that starting up the robot requires only from the user that she
supplies power to it. This will require a technician only if something goes
wrong in the process.

The second part where the user must connect to the robot have, however,
introduced difficulties, as connecting to EvoBot requires two things: 

- The user is on the same network as the EvoBot
- The user knows the IP of the EvoBot

The second of these points is the hardest to solve. In our test setup, we have
used Unix utilities to discover the IP address based on the MAC address of the
BeagleBone, but the process differs already between Mac and linux. It is unclear
if it is even possible on a Windows or mobile platform. There are, however,
solutions to the problem. One solution could be that the EvoBot is always
connected to the same router, which will assign it a static IP address. The user
can then connect to the same router, knowing the IP address to be fixed. This
could be taken a step further to mount the router as part of EvoBot, making it
part of the robot. The users can then connect to the robot either with an
ethernet cable or through WiFi. A cheap router would be sufficient as only a
single user is expected to be connected at any one time, so the price of the
EvoBot would only increase slightly. In any of these cases, it requires a
technician to do the setup.


### Choice of technologies

Narrowing the technologies down to the development of a 'web client' is a rather
unprecise definition. The world of web is a large one with an abundance of
frameworks doing identical or similar things. The EvoBot client does not require
very exotic features in this regard, but must at a minimum support calls against
a REST server and provide support for constructing a reasonably looking GUI. No
member of the team has extensive flair for UI- or aesthetic design, so any help
in this regard is a plus.

If nothing is to be installed on the computer of the user, JavaScript seems the
obvious choice, as this runs in every (reasonably) modern browser. Alternatives
would be embeddable applications written in languages such as Java or Flash, but
using such a technology would pose a further requirement on something to be
installed, which can otherwise be avoided.

The framework AngularJS was chosen as a framework for developing the frontend
client as it provides all the features (and more) that was seen as requirement.
Furthermore there exists tools around it which can help with generating the
files and structure, compensating for the teams lack of knowledge in the UI
field.

The communication layer is written in NodeJS as it is built with great
support for web clients while boasting support for low-level interaction
with C and C++. It has a third not insignificant advantage that the 
BeagleBone runs a variant of the language as its native scripting
language. There are no plans to rewrite any parts of the robot-interacting
code in JavaScript, but its reassuring to know that the platform is 
natively, and likely actively, supported.

The integration between the client layer and the communication layer is very
tight in the sense that one will not work without the other. It makes sense
therefore to make sure that full interdependence exists between the two layers.
This is in practical terms achieved by having the communication layer be
responsible for hosting the client layer. This has the added benefit of
minimizing the steps needed for starting the EvoBot.


### Summary of the design
The design outlined above is illustrated in figure \ref{fig:gui_design_outline}.
It shows the calls involved the process of starting up the EvoBot, connecting to
it, and interacting with it through the web client.

![A sequence diagram showing the communications between the communication layer and the web client during startup and usage.\label{fig:gui_design_outline}](images/todo.png)


## Reflection

It makes sense to reflect on the two seperate elements of this design (the
client and the web server) atomically as the strengths and weaknesses of one
should not impact the other.

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

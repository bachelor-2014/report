# Human interaction with the robotic platform
\label{sec:human_interaction}

Few software projects are in themselves useful without a way for the software
to interact with the world. In the case of EvoBot the world is mainly the
scientist designated to use the robot. A world consisting of scientists can
potentially be a large and diverse one. In the interest of being useful for as
large a subset as possible it seems advisable to aim the design at the lowest
common denominator and preferably make it easy to extend at a later time. At
the same time, end users are likely to have advanced use cases in mind for
EvoBot, making it relevant to not limit the possible usage of the platform with
the user interface. This chapter describes our experiences with trying to live
up to this.

## Goals
\label{sec:human_interaction_goals}

The following is a summary of the thoughts concerning the user interface of
EvoBot. It is to be seen as an informal discussion with actual goals marked
with **bold**.

The main value that we seeks to provide the users of EvoBot stems from the top
level goal that it **must provide the user with the ability to control as well
as receive feedback from experiments**. The goal is apparent directly from the
expected uses of the robotic platform. The user is expected to program an
experiment, which EvoBot can then run. The experiment data must then be
available for the user to see, so the experiment data can be used in research.
As an extension of this goal, we seek to allow the user to **see experiment
data while the experiment is running**. One could imagine e.g. that the user
wishes to run an experiment without knowing exactly what the outcome is. By
allowing real-time result data monitoring, the experiment could keep running,
until the user decides to terminate it based on the result data. The following
goals are concerned with how to achieve this interaction with the robotic
platform.

When considering the goals it is certainly advantageous to consider
the end-user of the system. The users of the EvoBot will be scientists
occupied with advanced chemical and/or biological experiments.
Acknowledging the highly specialized expertise these people possess
coupled with the ever present fact that humans rarely are experts in
many things at once, one important property of the EvoBot is that it
**must run without special technical setup**. This means that the
barrier to start using EvoBot must be inconspicuously small. This
does not mean that there must be no setup process, but the steps, if
any, should only have to be performed once and not have an impact on
ongoing use. This enables a technician on-site to perform the
installation for seamless ongoing usage.

The complement to the previous arguments is that we, the designers of
EvoBot, certainly do not possess the expertise to figure out which
experiments will actually be beneficial to run on the platform. It is
therefore important to not design a user interface that will
eventually get in the way of the user. In order to balance between
functionality and ease of use, we set the goal for the graphical user
interface to **not overshadow functionality that the EvoBot platform
can perform**. Specifically the user interface should always provide
the user with access to control the lowest level of functionality,
e.g. direct access to driving a motor, making sure that any unexpected
uses of the robot requiring the doing of so is equally possible as
expected uses. At the same time, we strive to make the expected use as
efficient as possible.

In order to make sure programming in Rucola, the domain specific language that
can be executed on EvoBot, also does not require technical setup, we find it
necessary to ensure that the graphical user interface **provides a way of
writing and executing Rucola code directly on the robotic platform**.

The final goal for the EvoBot user interface is a non-functional one.
Developing the robot is a constant reminder that the platform has
certain limitations when it comes to computational power. Therefore it
is relevant to aim for a solution that has a low performance overhead
and favours the limited resource platform. This is a hard-to-quantify
requirement and is therefore only stated informally.


## User interface in Splotbot

Splotbot keeps its heritage as a 3D printer by being being built on
the same components as the RepRap printer [@gutierrez2012, p.  43-48].
This means, amongst other things, that all instructions goes to the
Arduino in the form of G-code. Over the course of @gutierrez2012
a small set of Python script is constructed to abstract away the G-Code, and
instead allow the user to control Splotbot from python code,
using more familiar commands such as 'moveWater'. This is analogous to
Rucola in the EvoBot project. Although the exact classification of this set
of Python scripts can be discussed, it will in the following discussion
be referred to as 'the Splotbot library'.

For a user to conduct an experiment with the Splotbot library the
'main' script `splotbot.py` includes most of the needed functionality,
but for specific needs such as camera calibration and filtering
additional scripts are needed. The effects of this that the user needs
to know her way around a Python project in addition to knowing the
specifics of the Splotbot library. What is given in turn is easy
extendability to new use cases. If the user possess knowledge of both
Python and G-code he is equipped to both run experiments as well as
add new methods to the python library.

It can easily be argued that this solution is not very user friendly. It is
highly likely that all users of the Splotbot (and EvoBot) will indeed not be
proficient in Python, but this also applies to Rucola.
In fact, the argument probably holds even more merit in the case of
Rucola. Where Rucola shines over the Python solution, however, is in
terms of focus of the language. For a user to program an experiment in
Rucola she has only to look at code for that specific experiment, not
surrounding methods and unnecessary clutter of main methods, import
statements and different files. For extending the language, the user
is probably at a loss though, and should ask for help from a computer
scientist.

The final discussion between the two solutions is a matter of
dependencies. Once Rucola is compiled into EvoBot, the user needs
nothing but a web browser installed to use it. In the case of the
Splotbot library, she needs to make sure she has a compliant version
of Python, the Printrun application used for sending G-Code
instructions to the Arduino, and the needed Arduino drivers. Printrun
in turns has it owns list of dependencies [@printrun].

## User interface in EvoBot

The goal of not requiring special technical setup has a huge impact on the
development of the platform, as it poses the requirement that all generally used
platforms must be able to interact with EvoBot effortlessly. Little research is
required to realize that this calls for some form of common runtime. In the
modern world of heterogeneous platforms this common runtime realistically is a
web browser, and preferably a reasonably up-to-date one. It is considered a
prerequisite for EvoBot that such a platform is present on the PC of the user,
and the graphical user interface can therefore safely be implemented in web
technologies. As the power of the BeagleBone Black is limited, it is
advantageous to move as much as possible of the computation to the computer of
the client, which can also be achieved when running the application in a web
browser. 

With the above goals in mind, a design consisting of two components is 
proposed:

- Have EvoBot serve a web client to the web browser of the user 
- Have a communications layer run on the BeagleBone Black, interacting with
aforementioned graphical user interface and the underlying EvoBot software,
mediating messages between the two. A graphical representation of this
can be seen in figure \ref{fig:architecture}.

### Constructing the graphical user interface

The actual elements shown in the graphical user interface (GUI) are determined
from the same configuration file used on robot startup as described in
chapter
\ref{sec:software}. The GUI has the same kind of modularity as the rest of the
software running EvoBot, which means that every element in the
configuration file has a standalone graphical component. An example could be
a set of x and y axes which can be (1) homed and (2) set to a specific
position. As shown in figure \ref{fig:gui_screenshot_controls}, this
functionality is graphically available for the user to access. This helps
achieving two of the goals, namely that the user can control the low level
parts of EvoBot (the single components) as well as the user receiving
feedback from running experiments, as each control can react on messages
sent from EvoBot, such as status events, or, in the case of a camera
where images grabbed are emitted as events, for giving give direct visual
feedback as seen in figure \ref{fig:gui_screenshot_camera}.

We have personally experienced that it serves as very good feedback that when a
component is added to the hardware and configuration file, the component is
immediately available as a graphical control, providing not only the information
that the component was registered correctly, but also allowing the user to
control it, testing that everything works as expected. And since this is just
one part of the graphical user interface, it puts no restriction on what can be
done in the rest of the client, giving every possibility of extending with
wanted functionality.

\begin{figure}[h]
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/gui_controls}
        \caption{The control of a component}
        \label{fig:gui_screenshot_controls}
    \end{subfigure}%
    ~
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/gui_camera}
        \caption{Camera feedback}
        \label{fig:gui_screenshot_camera}
    \end{subfigure}
\end{figure}

The graphical controls do, however, not help with solving the goal of
programming experiments. This is instead achieved by aiding the user in
programming in the domain specific language, Rucola, described in section
\ref{sec:experiment_interaction}. A simple text editor with syntax
highlighting is included in the web client with a button to run the code on
EvoBot as shown in figure \ref{fig:gui_screenshot_rucola} (the syntax
highlighting is actually C#, as the syntax is similar to Rucola.  Providing
proper keyword highlighting would be an improvement on this). This makes the
flow of programming and running experiments as simple as possible without
requiring the user to install anything on her computer.

We have considered one limitation with the text editor and programming language.
Without knowing for sure (this ought to be tested on actual users), we expect
that the learning of a programming language might be difficult for people who
have never worked with programming before, which we believe is true for some of
the users. It would be possible to add to the GUI a way of graphically writing
the code, providing drag-and-drop functionality and hopefully higher ease of
use. We have also considered the possibilities of allowing a user to record
their actions and save them as a program for later user. But the implementation
of these is considered out of scope of this project.

![The graphical user interface provides a text editor with syntax highlighting
in which experiments can be programmed and run.
\label{fig:gui_screenshot_rucola}](images/gui_rucola.png)

At a final note, the GUI contains a panel showing all the experiment data logged
as described section \ref{sec:logging}, allowing her to see, download,
and clear the data. Figure \ref{fig:gui_screenshot_logging} shows a screenshot
of this panel.

![The panel where the user can see, download, and clear logged experiment data.
\label{fig:gui_screenshot_logging} ](images/gui_logs.png)

The design outlined above is illustrated in figure \ref{fig:gui_design_outline}.
It shows the calls involved the process of starting up EvoBot, connecting to
it, and interacting with it through the web client.

![A sequence diagram showing the communications between the communication layer
and the web client during startup and usage.
\label{fig:gui_design_outline}](images/client_sequence.pdf)


### The bootstrap process
Using EvoBot needs to be as simple as possible. This includes starting up the
robotic platform as well as connecting to it. The first part is easily achieved
as we have full control of what is run on the BeagleBone Black. By running our
software as a service it starts up when the BeagleBone Black boots, allowing the
user to simply power the board to start the program and make EvoBot ready for
use. This will require a technician only if something goes wrong in the process. 

Connecting to the robot have, however, introduced difficulties, as connecting to
EvoBot requires two things: 

- The user is on the same network as EvoBot
- The user knows the IP address of EvoBot

Both of these issues were initially solved in software. While developing the
platform, we have used UNIX utilities to discover the IP address based on the
MAC address of the BeagleBone Black, but the process differs already between Mac
and Linux[^1]. It is unclear if it is even possible on a Windows or mobile
platform. Instead a hardware solution was introduced in the form of a simple
wireless router. This is connected to the BeagleBone and is configured to always
assign the same IP to the machine. This way we know that the EvoBot can be
accessed over the wireless network, "EvoBot", and be found by pointing a web
browser to 192.168.1.2:8000. This is intuitive for us, but not necessarily for
end users of EvoBot. To ease the process we have generated a QR code, which
will open the correct URL, and is useful if running the client for instance on a
tablet, as can be seen in figure \ref{fig:table_control}. When using a regular
PC, instructions for opening a browser and pointing it to the correct URL will
still have to be provided.

![EvoBot controlled using a tablet.
\label{fig:table_control}](images/tablet_control.jpg)

[^1]:The scripts used on both Mac and Linux are available in 
our 'util' repository [@bachelor_util].

### Choice of technologies
Narrowing the technologies down to the development of a 'web client' is a rather
imprecise definition. The world of web is a large one with an abundance of
frameworks doing identical or similar things. The EvoBot client does not require
very exotic features in this regard, but must at a minimum support calls against
a REST and web socket server as well as provide support for constructing a
reasonably looking GUI. No member of the team has extensive flair for UI- or
aesthetic design, so any help in this regard is a plus.

If nothing is to be installed on the computer of the user, JavaScript seems the
obvious choice, as this runs in every (reasonably) modern browser. Alternatives
would be embeddable applications written in languages such as Java or Flash, but
using such a technology would pose a further requirement on something to be
installed, which can otherwise be avoided.

The framework AngularJS was chosen as a framework for developing the
client as it provides all the features for making the development
easier. The choice landed on AngularJS because of it being a stable
framework with solid cooperate backing and because we, the developers,
have prior experience using it. Alternative solutions could be to
either use a similar JavaScript library or a language that compiles to
JavaScript with a framework around it. We decided to take the safe
route and use technologies we have experience with.

The strengths of a chosen technology often becomes more clear when viewed in the
company of alternatives. Our overall choice of technology, web and a REST and
web socket server solves our requirements and comes with a few extra bonuses,
including but not limited to:

- Keeping the pages static the GUI can in its entirety be moved to the
client PC for rendering, sparing precious resources on the BeagleBone Black
- A vast number of libraries for GUI related development exists

We first considered writing the RESTful/web socket server in C++, continuing the
existing path of development. C++ does not provide the best support for creating
such a web service. So instead we decided to go for newer technologies and went
looking for a language with interoperability with C++ and good support for
creating a web service.

There is no shortage of languages that provides both support for RESTful
interfaces and libraries for this task either. Many languages also has decent
support for interfacing with C++, though this is often a task with varying
success as the libraries for doing so are both complex and often unmaintained.
NodeJS seemed as the stronger candidate because of it already being integrated
with the BBB through the BoneScript libraries and because of the support for web
sockets through the socket.io library, which makes it possible to send data
continuously from the server to the client. NodeJS also has the nice benefit of
being relatively lightweight and is built with non-blocking IO in mind, making
it unlikely that this layer will become a bottleneck in the project. NodeJS was
therefore chosen as the technology used for the communication layer.

The integration between the client layer and the communication layer is very
tight in the sense that one will not work without the other. It makes sense
to make sure that full interdependence exists between the two layers.
This is in practical terms achieved by having the communication layer be
responsible for hosting the client layer. This has the added benefit of
minimizing the steps needed for starting up EvoBot.

When actually using the technology it was discovered that ease of use was not as
high as one could have hoped. The most noteworthy of these issues is the
interoperability with C++ as it was one of the major reason for choosing the
language. There was both an element of actually not getting things to work, and
a feeling that the combination is simply not ideal.

The idea that the combination is less than ideal springs from subjective
observation where the solution seems 'clunky'. There is much to be said about a
language like JavaScript which lacks conveniences that we have come to love such
as types and integers. Even more is to be said about combining it with languages
that has a rich type system like C++ or a language like C where integers are
quite omnipresent. For now it makes sense to mention how the
development process has been firsthand. It is largely dominated by a lot of
casting to odd predefined types, that often seems a bit far from the underlying
data types in C and C++. This prompts thoughts about whether the languages are
too far apart, and if a language closer to C would make the process easier. The
second consideration is that it must be rather inefficient to keep crossing such
a high barrier, which may be improved with a language with more similar
semantics. The second thing that feels 'clunky' is the build process itself.
Instead of regular Makefiles we are left with a specialized JSON file, which
partly consists of text you would place in a Makefile, but now coupled to
specific keys in a map structure which is sparsely (if at all) documented. This
results in a lot of guessing about things that are usually trivial and much time
spend getting it to work as expected.

All of these nuisances are however just that, nuisances. Small bumps
on the road. In the end we achieved to build a fully functioning web
interface with all the features we set out to achieve. The user
interface consists of very different technologies, and it has been
proven that they can, although not trivially, be correctly put
together and amount to a pleasant user experience on different devices
without imposing dependencies on the client. Furthermore, much of the
underlying technologies opens up to a more heterogeneous approach to
client-server communication. There really is not much in the way of
constructing a 3rd party client.

##Summary

EvoBot is not much good if no one can access and control it. With
Splotbot this interaction is achieved through a small set of Python
scripts capable of generating and sending G-Code to the Arduino unit
on Splotbot. This solution does however impose a lot of requirements
on the user as well as introduce a whole library, including
boilerplate code, for the user to grok before being able to run even
the simplest of experiments. The EvoBot provides a similar form of
interaction with its Rucola domain specific language, which gives a
more intuitive experience for the user. The main drawback for Rucola,
however, is that it is less easily extended with new functionality and
use cases.

For EvoBot we developed a web based user interface consisting of a front end
client and a REST and web socket based web service which serves the front end
code as well as communicates with the back end. This allows EvoBot to be used
from any modern web browser.

The graphical user interface consists of graphical controls constructed from the
configuration file also used to initialize the core software at startup.
Furthermore it provides a text editor for writing and executing Rucola code as
well as access and control over logged data.

The problem of establishing connection to the robot was handled by having a
fixed IP address on which to connect as well as a QR code for access from
tablets. All this combined results in the goals of achieving control of the full
capabilities of the robotic platform without technical setup are achieved.

# Splotbot client

Few software project are in themselves useful without a way to
interact with the world. The world in the case of Splotbot is mainly
the scientist designated to use the system. A world consisting of
scientists can potentially be a large and diverse one, in the interest
of being useful for as large a subset as possible it seems advisable
to aim for the lowest common denominator and preferably make it easy
to extend at a later time. With these goals in mind a design consisting
of two components is proposed:

- Overlying GUI interface presented to the user, run on her computer
- A communications layer run on Beaglebone, interacting with
aforementioned GUI and the underlying Splotbot software. Mediating
messages between the two.

The GUI interface will in the scope of this project be intuitive
point-and-click, and will provide feedback to the user in the form
of a video feed and buttons representing the possibilities of the
Splotbot in the present setting. The GUI can be "heavy" but should
mainly draw resources from the client PC, not the Beaglebone.

The communication layer will be agnostic towards which client run on
top of it, making it possible to make different clients work equally
well. The communication layer will likely be computationally light,
but will be responsible for a lot of IO work. It should aim to not
slow down the Splotbot.

## GUI Layer

One of the requirements for this project is high availability for the
user. This is to be understood as the ability for anybody on any kind
of reasonable PC to be able to run the software. Little research is
required to realize that this calls for some form of common runtime.
In the modern world of heterogeneity of platforms this common runtime
realistically is a web browser, and preferably a reasonably up-to-date
one. It is considered as a prerequisite for the Splotbot that such a
platform is present on the client PC, and the GUI can therefore safely
be implemented in web technologies.

### Elaboration

Narrowing the technologies down to "web" is not really a precise definition.
The world of web is a large one with an abundance of frameworks doing
the same or similar things. The Splotbot client does not require very
exotic features in this regard, but must support calls against a REST server
and provide support for constructing a reasonably looking GUI. No member of
the team has extensive flair for UI- or aesthetic design, so any help a
in this regard is a plus.

The framework AngularJS was chosen as it provides all the features
(and more) that was seen as requirement. Furthermore there exists tools
around it which can help with generating the files and structure, 
compensating for the teams lack of knowledge in the UI field.

### Alternatives and advantages

Possible alternatives to web technologies would be using a cross
platform GUI library such as GTK, QT, java-swing, etc. But they all
have the major flaw of requiring software to be installed locally,
possibly alienating some users.

Using web as the platform yields several advantages, including but not
limited to:

- Keeping the pages static the GUI can in its entirety be moved to the
client PC for rendering, sparing precious resources on the Beaglebone.
- A huge amount of libraries for GUI related stuff.

As for the specific choice of AngularJS, it was done mostly based on:
- Prior experience within the team
- the fact that its a fairly stable
framework with some years behind it
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


## Communications layer

As explained, the communication layer has the noble job of facilitating
communcation between a client and the Splotbot software.
Few but important requirements exists:

- Must be able to transport data
- Must have C ways to interact with Splotbot (C++)
- Must have a way to communicate with the web browser

The first requirement is a no brainer and does not in fact eliminate
any serious candidates. The communication layer doesn't necessarily
have to know anything about the data as long as it can transport it
without compromising it. It is, however, important that it can support
things like video streaming, which will impose the requirement of soft
realtime-like transportation.

The second requirement can be solved in different ways, a form of FFI
to the C language would tie the two together nicely with a minimum of
dependencies, but the task can also be solved using shared memory of
some form of messaging over sockets etc.

The third and last requirement is in itself quite open. Almost
everything can talk to a http socket, and it does not have to be
a language feature assuming that a library like curl exists on the
Beaglebone. It would however be a big plus if the language supported
seamless support for easily setting up a REST based server, as it is
almost certain that the client will prefer REST to anything else.

### Elaboration

NodeJS was chosen for this part of the software. This provides
an out-of-the-box support for both REST communication as well
as FFI to the C-language. As for data processing, there is of course
support for sending and receiving arbitrary bytes, as well as
support for video streaming using web-sockets.

NodeJS was designed for easy use as a webserver, and has therefore
great and mature support for such a use-case. There is also a thriving
community resulting in a huge amount of libraries as well as plenty of
guides and examples of how to build REST servers easily (and sometimes
in one line).

As for the FFI, the NodeJS runtime is written in C, and is itself
a tour de force in communicating between two foreign languages (C and
javascript). A quick search reveals that there exists one agreed upon
library to use for this task. A different kind of interop that would
also result from NodeJS is that between Splotbot and the Bonescript
language present on the Beaglebone. Bonescript is a form of javascript,
having the bridge between C++ and javascript will certainly help in the
event that something has to be done in this language rather than in C++.


### Alternatives and advantages

There is no shortage of languages that provides both support for RESTful
interfaces and libraries for easing this task. Many languages also has
decent support for interfacing with C, though this is often a task
with varying success as the libraries for doing so are both complex and
often unmaintained. NodeJS seemed as the stronger candidate because
despite being a relatively new entrant already shines in many of these
areas and is used by so many in varying settings from hobby-hackers to
large corporations. Within the team there was experience with both NodeJS
and solving the same task in other languages (python, C#, etc.), and
NodeJS was voiced as the simpler way out. Its also relatively lightweight
and is built with non-blocking IO in mind, making it likely that this
layer will not become a bottleneck in the project.

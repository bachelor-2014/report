# Human interaction with the robotic platform

// TODO: Decide on and elaborate on getting data out from experiments

Few software project are in themselves useful without a way to
interact with the world. The world in the case of Splotbot is mainly
the scientist designated to use the system. A world consisting of
scientists can potentially be a large and diverse one, in the interest
of being useful for as large a subset as possible it seems advisable
to aim for the lowest common denominator and preferably make it easy
to extend at a later time. Keeping in mind that the end-user is likely
to have advanced use-cases in mind for the EvoBot, it is necessary to
not limit the usage of the platform with the GUI. With these goals in
mind a design consisting of two components is proposed:

- Overlying GUI interface presented to the user, run on her computer
- A communications layer run on Beaglebone, interacting with
aforementioned GUI and the underlying EvoBot software. Mediating
messages between the two.

The GUI interface will be intuitive
point-and-click, and will provide feedback to the user in the form
of a video feed and buttons representing the possibilities of the
EvoBot in the present setting. The GUI can be "heavy" but should
mainly draw resources from the client PC, not the Beaglebone.

With knowledge of the platform it should be possible to circumvent
all GUI control and command the robot using a high-level programming
language with meaningful semantics. This is achieved by simply providing 
a basic text field for input of commands.

The communication layer will be agnostic towards which client run on
top of it, making it possible to make different clients work equally
well. The communication layer will likely be computationally light,
but will be responsible for a lot of IO work. It should aim to not
slow down the EvoBot.

## Description of the current solution

One of the requirements for this project is high availability for the
user. This is to be understood as the ability for anybody on any kind
of reasonable PC to be able to run the software. Little research is
required to realize that this calls for some form of common runtime.
In the modern world of heterogeneity of platforms this common runtime
realistically is a web browser, and preferably a reasonably up-to-date
one. It is considered as a prerequisite for the Splotbot that such a
platform is present on the client PC, and the GUI can therefore safely
be implemented in web technologies.

Narrowing the technologies down to "web" is not really a precise
definition. The world of web is a large one with an abundance of
frameworks doing the same or similar things. The Splotbot client does
not require very exotic features in this regard, but must support
calls against a REST server and provide support for constructing
a reasonably looking GUI. No member of the team has extensive flair
for UI- or aesthetic design, so any help a in this regard is a plus.

The framework AngularJS was chosen as it provides all the features
(and more) that was seen as requirement. Furthermore there exists
tools around it which can help with generating the files and
structure, compensating for the teams lack of knowledge in the UI
field.

### Reflection

- Is it working?
- Is it broken?
- Are we dancers?

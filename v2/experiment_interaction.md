# Autonomous interaction with experiments
\label{sec:experiment_interaction}

Some experiments expected to be run on EvoBot are currently run
manually by a person who monitors the experiment, and if a certain
event occurs, such as a droplet no longer moving, she modifies the
experiment e.g. by adding more of the droplet liquid. EvoBot
must be able to run such experiments autonomously. Autonomous is to be
understood in the sense that the experiments will be started by a human but will
be completely self sustained and be capable of actively reacting to changes
happening in the observed experiment. This is the focus of this chapter.

We first introduce our goals regarding this before looking at each part of
the system, discussing how the goals are fulfilled. Finally we look at the
result of the approach including a discussion of possible improvements and
alternative solutions.

##Goals
The idea behind an autonomous experiment is to define an experiment execution
that loops and continuously adjusts over time. This is illustrated in figure
\ref{fig:reactive_loop}. The loop begins with the initial actions that will be
executed setting up the experiment. This initial setup could for instance
include picking up liquid and putting it into a petri dish. After the
initial actions the experiment is running, and components detect events such
as droplets moving. Based on events in the system the robot then reacts on
the on these events and their corresponding data, possibly doing new actions
which change the experiment. This loop creates a reactive feedback process
where the outcome of the experiment is based on data gathered throughout the
experiment.

\begin{figure}
    \centering
    \includegraphics[width=0.6\textwidth]{images/autonomous}
    \caption{Reactive experiment loop.}
    \label{fig:reactive_loop}
\end{figure}

Making a user capable of defining experiments in this system requires a few
capabilities added to the robot. First of all, **the user must be able to send
instructions to components**. Secondly, the components **must be able to
communicate events with data**.  Lastly, **it must be possible for the events
emitted by the components to influence further execution of the experiment based
on definitions by the user**.

##Executing instructions on EvoBot
\label{sec:autonomous_instructions}
<!-- Introduce problem-->
When running experiments on EvoBot, a core feature is the ability to send
instructions to the individual components to make the robot perform different
actions. We want a system that allows us to easily enqueue instructions and then
get them executed sequentially making the robot carry out actions in order. We
also want instructions to be capable of taking parameters, that is to allow us
to instruct a component to based on given parameters perform a certain action
e.g. moving a motor to a certain position.

<!-- Execution the integer instruction buffer, action list-->
At the core of our instruction execution model lies two important data
structures, the instruction buffer and the action list.  The instruction buffer
is a thread safe FIFO queue that contains integer instructions and integer
arguments. The point is that new instructions gets added to the instruction
buffer, which then gets emptied by a worker thread, executing every instruction.
In this system we define instructions as integers being the index of the actions
in the action list. The action list is a list of functions that takes a pointer
to the instruction buffer. When an action gets invoked with the instruction
buffer it pops the needed amount of arguments from the instruction buffer
and calls a method of a component with the arguments. This cycle will continue as
new instructions are put into the buffer and popped and executed. An
illustration of this is given in figure \ref{fig:instruction_buffer}. To ensure
that the instructions are run in sequential order there is only a single worker
thread. If a component wants something executed in parallel it has the
responsibility of spawning a new thread.

![Instruction buffer and action execution cycle.
\label{fig:instruction_buffer}](images/instruction_buffer.png)

<!--Component registration actions, based on configuration file ordering-->
The actions in the action list are registered by each component. On the startup
of EvoBot software, the configuration file is loaded and every component is
initialized as described in chapter \ref{sec:software}. When all components have
been initialized, the software loops over them asking them to register their
actions in the action list. The placement of a specific action in the action
list is therefore determined by the order of the components in the configuration
file, as well as how many actions each component has and also in which order a
component has defined its actions. The code defining the logic for an action can
be found in the specific component.

<!--Only integers, possible extension, alternatives-->
With the instruction buffer and the action list as described above we achieve
the instruction execution as initially wanted. While this implementation fully
supports the executing model, it does so with the limitation that it
only supports
integers as arguments. A possibly useful extension could be to extend the engine
to be capable of holding other data types such as strings, floats and doubles.
Floats and doubles could fit into the current model as they could just be put
into the buffer as one or more integers (depending on bit-lengths) and later be
converted back into their desired type by the action call as they get popped.
Strings of an undefined length would be harder and more inefficient to fit into
the buffer. Here we propose the possibility of storing a pointer to the string
as an integer on the stack, making it possible for the action call to access the
string at a later point by converting the integer to the pointer.  Making more
data types available would potentially make some component methods richer with
more options. While we did not encounter such needs in our limited
implementation it might be a desired feature at a later stage.

##Sending events with experiment data
\label{sec:autonomous_events}
<!--Introduce problem-->
At this point we can execute instructions and thereby make the robot capable of
performing a user defined set of actions. Now we want to extend the model to
enrich the communication possibilities of components. We want to make them
capable of informing the user and the rest of the system of their state and
possible discoveries in the experiment. To do this we want to make a system
where components can announce that something have happened and include some
data.  The data attached to such announcements must be propagated to the user.
An event based system seems appropriate for this situation.

<!--Event callback and pointer-->
To extend EvoBot to include an event system, we introduced the event function.
This is a single function that every component calls when wanting to communicate
an event. We store this function in the `Splotbot` class in a variable,
making it possible to change the function at a later stage. Every component gets
initialized with a pointer to the function, allowing them to call the function
when needed and to ensure that updating the event function will propagate to the
components. Our event system therefore allows us to bind an event function such
that we can send data to the client etc.

<!--Data and Component usage-->
Sending data required us to define what data we wanted to send for each event.
We wanted the system to be universal so it could be used it to both propagate
values such as droplet speed, as well as images from our camera to the client
through the event system. The data is for flexibility purposes defined as a
single string, making it the responsibility of the receiver to parser the string
and handle the data.

The event system allows EvoBot to send data to the user, making her capable
of seeing images, numeric data etc. This however does not allow the user to make
the robot react to the data, as the only way to extended the event binding is
through modification of the C++ source code.

##Programming experiments
\label{sec:autonomous_programming}
<!--Introduce problem-->
Giving the user the option of defining a complete experiment required us to
look back to figure \ref{fig:reactive_loop}. Here we could see that firstly the
user must be able to control the loop. More specifically the user must be able
to define the initial experiment actions, which events to react to, and
the reactive actions that must be fired off based on the event output.
The execution of instruction codes makes it possible to define the
initial actions, but not the reactive ones.

We made an effort to make this design more user friendly. The way to achieve
this user friendliness is to make the language for the robot interaction closer
to human language by introducing a programming language to run on the robot.
Being software developers and therefore familiar with programming languages has
the advantage of us being capable of designing and implementing such a language
in reasonably short time, making it an attractive design decision from a
development point of view.

<!--Not interpreter, not other language, make DSL!-->
To do this we must first address the question of what language and why. An initial
thought could be to use one of many available language interpreters for
C++. An interpreter does however not fit our model exactly. An issue with using
an interpreter is that suddenly we have to support an entire programming
language with all of its features in our model and what capabilities it might
have, so instead it seems natural to look at making a small and
suitable domain specific language (DSL).

###Rucola
<!-- Robotic Universal Control Language -->

This section describes and discusses the created DSL,  Robotic
Universal Control Language (Rucola). The language was designed to fit
our exact needs. It was built around two core features: Calling
component actions and listening for events. The Rucola compiler exists
as a sub folder in the main C++ code and functions largely as a black
box from the point of the view of the rest of the software. It
provides an interface for compiling a string of Rucola code into
integer instructions as well as for invocation of events, resulting in
further integer instructions being added to the instruction buffer. 
Within the Rucola compiler, the string
is used to create an abstract syntax tree (AST), which is compiled
into instruction code. We use Flex [@flex] as lexer and Bison [@bison]
as parser generators.

<!-- Basic features -->
The basic language features of Rucola consists of integer arithmetics,
variables, conditionals, and a print statement. The variable binding is global
and is stored internally in Rucola, even between compilation and event calls.
The variables and bindings can be reset by compiling with an empty string. The
arithmetics, conditionals, and variable access happens on compilation time from
Rucola to instruction codes. The print statement is for debugging purposes and
is executed at compile time, so it is mostly useful for printing variables. It
simply takes a string to be printed and a tuple of expressions. An example of
the different constructs can be seen in figure
\ref{fig:rucola_language_constructs}.

\begin{figure}
    \begin{lstlisting}[language=csh]
        a = 20
        b = a - 10

        if(a > b){
            ...
        } else {
            ...
        }

        print "Variables" (a,b)
    \end{lstlisting}

    \caption{Rucola language constructs.}
    \label{fig:rucola_language_constructs}
\end{figure}

Calling component actions is somewhat trivial in our current model. What we do
is that we first make every component register its actions in a map, where the
key is the name of the action and the value is a `struct` containing the instruction
number of the action and how many arguments it takes. We denote this the action
map. We then store the action map in another map where the keys are the
component names. When a specific component is called with a specific action and
arguments, we retrieve the instruction number of the action and the amount of
arguments it takes via the map structure. We can check that it is both a valid
component and action as well as whether the amount of arguments is correct. Finally
we translate the call into the action number followed by the arguments and
include it in the list of instructions that we compile to. An example of a
component action call is shown in figure \ref{fig:rucola_component_action_call}.

\begin{figure}
    \begin{lstlisting}[language=csh]
        Component.action(1,2)
    \end{lstlisting}

    \caption{Rucola component action call.}
    \label{fig:rucola_component_action_call}
\end{figure}

Event callbacks are less trivial, but with a few adjustments to our model
they are incorporated 
into the system. Here we cross a border where we combine
interpretation with compilation. On the time of initially compiling the code we
do not follow the event branches in the AST. We instead save them in a map from
event name to the AST. As part of setting the event callback up in EvoBot, we
include a call to the Rucola event compilation. This means that all events are
received by Rucola before they are further emitted to the user. If a called
event is bound in Rucola, we compile it into instructions and add them to the
instruction buffer. If the event is not bound, no instructions are added.

For events to be really reactive we must also introduce event arguments. In a
system where everything is integers, event arguments are of course also
integers. Our approach to introducing this into the EvoBot event model is to
extend the amount of arguments an event in EvoBot takes, from event name and
data to also include a list of integers. The integers are bound to variables by
the user at the time of the event call. This is done by taking the integer list
and binding the integers to names in the internal variable map. It is up to the
user to decide the names and the amount of variables she wants bound to
variables. Figure \ref{fig:rucola_event_binding} shows an example of the code of
an event binding.

\begin{figure}
    \begin{lstlisting}[language=csh]
        (event: arg1, arg2) -> {...}
    \end{lstlisting}

    \caption{Rucola event binding.}
    \label{fig:rucola_event_binding}
\end{figure}

Our current implementation of the language faces a few minor issues that could
be resolved. One of them is that the else branch in the if-else statement must
contain some code to be valid Rucola code in the parser. Another nice to have
feature would be to change event arguments to not be included in the global
scope, to make them only available for the event itself unless assigned to a
global variable.

##Event reaction experiment
\label{sec:autonomous_experiments}
<!-- Introduction to the experiment -->
For the event based reactive system on EvoBot we designed a small experiment
to test the reaction time of EvoBot. The experiment is designed to measure the
time that goes between something happening in the physical world until the
EvoBot have processed and reacted on it. The experiment is as follows:

1. An event designed to watch the droplet speed is bound in the EvoBot system using Rucola
2. When the speed of the droplet gets above a certain threshold it will move the servo motors
3. The camera is moved to simulate droplet speed above the threshold 
4. The time from the actual movement of the camera to the movement of the servo
motor is recorded. This is done with a physical stop watch. The precision of the
timings are limited by this.

The experiment was repeated 21 times. The Rucola test program is shown in figure \ref{fig:rucola_event_experiment}.

\begin{figure}
    \begin{lstlisting}[language=csh]
        servoPos = 0

        (Camera_dropletspeed: speed) -> {
            if (speed > 10) {
                Servo1.setPosition(servoPos)
                
                if (servoPos == 0) {
                    servoPos = 90
                } else {
                    servoPos = 0
                }
            } else { a = 0 }
        }

    \end{lstlisting}

    \caption{Rucola test program for the event reaction experiment.}
    \label{fig:rucola_event_experiment}
\end{figure}

<!--
Trial         | Time (Seconds) 
---------     | -------------
1             |    05:54          
2             |    05:40          
3             |    05:37          
4             |    07:04          
5             |    06:44          
6             |    06:41          
7             |    05:70          
8             |    04:94          
9             |    07:30          
10            |    06:02          
11            |    06:04          
12            |    05:61          
13            |    06:79          
14            |    05:92          
15            |    05:88          
16            |    06:45          
17            |    07:91          
18            |    05:76          
19            |    05:85          
20            |    04:74          
21            |    05:41          
**Average**   |    **06:02**

Table: Experiment results
-->

<!--Discussion of results -->
The experiment shows an average of about **6 seconds** in reaction time from a
droplet movement detected to movement of the servo motors. The times recorded
spans from around **5 to 8 seconds**, which is somewhat stable. For the
kind of slow droplet experiments EvoBot is expected to handle, we do
believe these times would be acceptable for experiments, but it would likely
cause issues, if experiments changing more quickly are run.

##Summary
\label{sec:autonomous_summary}

In order to make EvoBot capable of running autonomous experiments it was
necessary to extend the EvoBot software with an event based system. The
resulting software is capable of both executing instructions and emitting events
with data. In order no make use of these capabilities, while also providing a
way for the user to define experiments, a domain specific language named Rucola
was created. Rucola is executed directly on EvoBot and allows the user to
define entire reactive and autonomous experiments that can be run on the
robotic platform.

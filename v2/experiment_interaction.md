# Autonomous interaction with experiments
\label{sec:experiment_interaction}
 The EvoBot should not only be able to run experiments, it should also be
 capable of running autonomous experiments. Autonomous in the sens that the
 experiments will be started by a human but will be completely self sustained
 and be capable of actively reacting to changes happening in the observed system.
 This chapter looks at the implementation of the system that allows a user to
 define an experiment and how this system allows for having autonomous
 experiments.

 We first introduce the goals of the experiment running system. We then look at
 each part of the system discussing how it has tried to achieve the goals and
 the result of the approach including a discussion of possible improvements and
 alternative solutions.

##Goals
The idea behind an autonomous experiment is to define a experiment execution
that loops and continuously adjusts overtime. This is illustrated in figure
\ref{fig:reactive_loop}. The loop begins with the initial actions that will be
executed setting up the experiment for example picking up liquid and putting in
into a petri dish. After the initial actions the experiment will be running,
events with data such as droplet movement will be detected by components. Based
on events in the system the robot will then react on the data possibly doing new
actions which will change the experiment. This loop will create an autonomous
reactive feedback process that will do actions to change the outcome of the
experiment based on data gatherer throughout the experiment.

![Reactive experiment loop. \label{fig:reactive_loop}](images/autonomous.png)

Making a user capable of defining autonomous experiments in this system requires
a few capabilities added to the robot, making these capabilities available will
be the goals of this chapter

1. Being able to send instructions to components to perform actions
2. Components should be able to communicate events with data in their execution
   and in the observed experiment.
3. Being able to program the experiment and get it executed on EvoBot. In which
   it should be possible to send instructions to components and react to data
   communicated by the components.

In this chapter we will in section \ref{sec:autonomous_instructions} look at how
instructions are executed on EvoBot, we will then in section
\ref{sec:autonomous_events} look at the event system in EvoBot and in section
\ref{sec:autonomous_programming} we look at exactly how the user is to program
the experiments. In section \ref{sec:autonomous_experiments} we run experiments
on the system and finally in section \ref{sec:autonomous_summary} we summarise
the chapter.

##Executing instructions on the EvoBot
\label{sec:autonomous_instructions}
<!-- Introduce problem-->
When running experiments on EvoBot a core features is the ability to send
instructions to the individual components to make the robot perform different
actions. We want a system that allows us to easily enqueue instructions and then
get them executed sequentially making the robot carry out actions in order. We
also want instructions to be capable of taking parameters, that is to allow us
to instruct a component to based on some parameters perform a certain action,
for example we might want instruct a motor to move to a certain position.

<!-- Execution the integer instruction buffer, action list-->
At the core of our instruction execution model lies two important data
structures, the first being the instruction buffer and the second being the
action list. The instruction buffer is a thread safe FIFO queue that contains
integer instruction and integer arguments. The point is that new instructions
gets added to the instruction buffer, which then gets emptied by a main worker
thread, executing every instruction. In this system we define instructions as
integers being the index of the actions in the action list. The action list is a
list of functions that takes a pointer to the instruction buffer. When an action
gets invoked with the instruction buffer it starts by popping the wanted
arguments from the instruction buffer, calling a components method with the
arguments. This cycle will continue as new instructions are put into the buffer
and taken out and executed, it can be seen as an illustration in figure
\ref{fig:instruction_buffer}. To ensure that the instructions are run in
sequential order there is only a single worker thread and if a component wants
something executed in parallel it will have the responsibility of spawning a new
thread.

![Instruction buffer and action execution cycle.
\label{fig:instruction_buffer}](images/instruction_buffer.png)

<!--Component registration actions, based on configuration file ordering-->
The actions in the action list are directly registered by the individual
component. On the startup of the EvoBot software the configuration file is
loaded and every component is initialized. After every component have been
initialized, the software loops over them asking them to registered their
actions in the action list. The placement of a specific action in the action
list is therefor determined by the order of the components in the configuration
file, as well as how many actions each component have and also in which order a
component have defined it's actions. Every action is simply a function that
takes a pointer to the instruction buffer, when the action is invoked it pops
the amount of arguments it needs from the buffer, the action definition is
defined in the components implementation. The code for an action can be found in
the specific component often defined as a simple lambda expression that pops
from the instruction buffer and wraps a normal method.

<!--Only integers, possible extension, alternatives-->
With the instruction buffer and the action list as described above we achieve
the instruction execution as initially wanted. While this implementation fully
supports the executing model we want, an observation that can be made is that we
only support integers as arguments. A possibly useful extension could be to
extend the engine to be capable of holding other data types such as strings,
floats and doubles.  Floats and doubles could fit into the current model as they
could just be put into the buffer as one or more integers (depending on
bit-lengths) and later be converted back into their desired type by the action
call as they get popped.  Differently strings of an undefined length would be
harder and more inefficient to fit into the buffer, here we propose the
possibility of storing a pointer to the string as an integer on the stack,
making it possible for the action call to access the string at a later point by
converting the integer to the pointer.  Making more data types available would
potentially make some component methods richer with more options, while we did
not encounter such needs in a limited implementation it could be and issue at a
later stage.

The solution in this state allows for arbitrary user defined experiments, where
a user can define a set of instructions that can make the robot do something.
This does not however allow the user to get any feedback from the system, nor
does it allow the user to define autonomous experiments.

##Sending events with experiment data
\label{sec:autonomous_events}
<!--Introduce problem-->
So now we can execute instructions and thereby make the robot capable of
performing a user defined set of actions. Now we want to extend the model to
enrich the communication possibility of components. We want to make them capable
of informing the user and the rest of the system of their state and possible
discoveries in the experiment. To do this we want to make a system where
components can announce that something have happened and including some data. We
want to be able to listen to this output and propagate it to the user. In other
words we want an event based system.

<!--Event callback and pointer-->
To extend EvoBot to include an event system, we introduced the event function.
This is a single function that every component calls when wanting to communicate
an event. We store this pointer in the Splotbot (main) class in a variable,
making it possible to change the function at a later stage. Every component gets
initialized with a pointer to the function in the Splotbot (main) class,
allowing them to call the function when needed and to ensure that updating the
event function will propagate to the components. Our event system therefor
allows us to bind an event function such that we can send data to the client
etc.

<!--Data and Component usage-->
Sending data required us to define what data we wanted to send for each event.
We wanted the system to be universal so we used it to both propagate values such
as droplet speed, as well as images from our camera to the client through the
event system. The data is for flexibility defined as a single string, making it the
responsibility of the receiver to parser the string and handle the data.

The event system allows EvoBot to send data to the user, making them capable
seeing images, numeric data etc. This however does not allow the user to make
the robot react to the data and the only way to extended the event binding is
through changing the C++ source code.

##Programming experiments
\label{sec:autonomous_programming}
<!--Introduce problem-->
Making the user capable a completely defining an experiment requires us to look
back to figure \ref{fig:reactive_loop}. Here we can see that firstly the user
must be able to control the loop, more specifically the initial experiments
instructions, the event reaction and the reactive instructions that must be
fired off based on the event output. The initial experiments instructions are
actually already available by directly coding in instructions codes. We however
want to make it more human friendly, so the natural option was to introduce a
programming language to the EvoBot, making the user capable of programming a
complete experiment and making it run on the robot.

<!--Not interpreter, not other language, make DSL!-->
However we must first address the question of what language and why. An initial
thought could be to be using one of many available language interpreters for
C++. An interpreter does however not fit our model exactly. An issue with using
an interpreter is that suddenly we have to support an entire programming
language with all of its features in our model and what capabilities it might
have, so instead it seems natural to look at making a small DSL instead.

<!--
A core issue with an interpreter is how
it would fit into our model, we would need to find an interpreter that would
allow the user to call C++ function, thereby making it possible for the user to
get C++ calls turned into instructions for the instruction buffer, while this
approach would be workable it would be lacking guarantees in execution order.
Lets imagine that two events gets called at the same time and the interpreter
starts to call C++ functions, here we have no control of which order event
instructions are put on the buffer.  We want to guarantee that the instructions
from an event will be eventually run in sequential order, so the user can
synchronize the hardwares positions. Next we looked at the possibility of
finding a language where we could get an AST, the problem here becomes to
support a language in its entirety. We therefor choose to build our own domain
specific language for our robot.
-->

###Rucola
<!-- Robotic Universal Control Language -->
Introducing Robotic Universal Control Language, or in short Rucola. The language
is designed to fit our exact needs and are therefor build around two core
features, calling component actions and listening for events. Rucola exists as a
sub folder in the main C++ code, where it functions as a black box. The
interaction between Rucola is compiling a string with code into instruction and
being able to invoke events for more instructions. We use Flex [@flex] as lexer
and Bison as parser [@bison] generators. Rucola takes a string creates an AST
and compiles that into instruction code.

<!-- Basic features -->
The basic language features of Rucola consists of arithmetics, variables,
conditionals and a print statement. The variables binding is global and is
stored internally in Rucola even between compilation and event calls, this can
however be reset by compiling with an empty string. The arithmetics,
conditionals and variable access happens on compilation time from Rucola to
instruction codes. The print statement is for debugging purposes and is executed
at compile time, so it is mostly useful for printing variables, therefor it
simply takes a string to be printed and a tuple of variables/expressions.
Example of the different constructs can be seen in below:

```Cs
a = 20
b = a - 10

if(a > b){
    ...
} else {
    ...
}

print "Variables" (a,b)
```

Calling component actions are somewhat trivial in our current model. What we do
is that we first make every component register there actions in a map, where the
key is the actions name and the value is a struct containing the actions
instruction number and how many arguments it takes. We then store the action map
in a map mapping from the component name to the action map. When a specific
component is called with a specific action and arguments, we simply retrieve the
action's instruction number and the amount of arguments it takes via the map
structure, we can therefor both check that its a valid component and action as
well as checking if the amount of arguments are correct.  Finally we translate
the call into the action number followed by the arguments and include it in the
list of instructions that we compile to. An example of a component action call
can be found below:

```Cs
Component.action(1,2)
```

Event callbacks are less trivial, but with a few adjustments to our model we can
incorporate them into our system. Here we strike a boundary where we combine
interpretation with compilation. On the time of initially compiling the code, we
don't follow the event branches in the AST we instead save them in a map from
event name to the AST. As part of setting the event callback up in EvoBot, we
include a call to the Rucola event compilation. If upon called an event is bound
in Rucola we compile it into instructions and put it on the stack. If an event
isn't bound we simply return an empty list of instructions.

For events to be really reactive we must also introduce event arguments. In a
system where everything is integers, event arguments are also simply integers.
Our approach to introducing this into the EvoBot event model is to extended the
amount of arguments an event in EvoBot takes, from event name and data to also
include a list of integers, these will only be used in Rucola. The integers will
be bound to variables by the user at the events call time, this is done by
taking the integer list and binding them to the names in the Rucola event's
internal variable map. It is then up to the user to decide the names and the
amount of variables he want to include into his scope, it is all about the
amount of variables available and the order of them. An example of an event
binding can be found in the code below:

```Cs
(event: arg1, arg2) -> {...}
```

Our current implementation of the language faces a few minor issues that could
be resolved. One of them is that the else branch in the if else statement must
contain some code to be valid Rucola code in the parser. An other nice to have
feature would be to change event arguments to not be included in the global
scope, to make them only available for the event it self unless assigned to an
other variable.

##Event reaction experiment
\label{sec:autonomous_experiments}
<!-- Introduction to the experiment -->
For the event based reactive system on the EvoBot we designed a small experiment
to test the reaction time of the EvoBot. The experiment is designed to measure
the time that goes between something have happen in the physical world until the
EvoBot have processed and reacted to it.

The experiment is designed as follows. We bound an event in the EvoBot system
using Rucola, the event is designed to watch the droplet speed and when it
gets above a certain limit it will move the servo motors. The experiment is then
to move the cameras xy axis to get the movement speed of the droplet above the
limit and make the stepper motors move. We then time the time from the actual
movement of the xy axes to the movement of the stepper motor and record this.
This should give us an idea of the reaction time EvoBot can have on an actual
event. Below is first the test program used and then the resulting table.

```Cs
servoPos = 0
Servo1.setPosition(0)
Servo2.setPosition(90)

BottomAxes.home()
BottomAxes.setPosition(10, 10)

(Camera_dropletspeed: speed) -> {
    if (speed > 10) {

        print "Speed " (speed)

        servoPos = (servoPos % 90) + 10
        Servo1.setPosition(servoPos)
        Servo2.setPosition(90 - servoPos)
    } else { b = 3 }
}

Camera.mode(2)
```

\begin{table}[h]
\begin{tabular}{ll}
\textbf{Trial} & \textbf{Time (Seconds)} \\
1              &                   \\
2              &    05:40          \\ 
3              &    05:37          \\
4              &    07:04          \\
5              &    06:44          \\
6              &    06:41          \\
7              &    05:70          \\
8              &    04:94          \\
9              &    07:30          \\
10             &    06:02          \\
11             &    06:04          \\
12             &    05:61          \\
13             &    06:79          \\
14             &    05:92          \\
15             &    05:88          \\
16             &    06:45          \\
17             &    07:91          \\
18             &    05:76          \\
19             &    05:85          \\
20             &    04:74          \\
21             &    05:41          \\
22             &    05:54          \\
\textbf{Average}        &    \textbf{05:75}
\end{tabular}
\end{table}

<!--Discussion of results -->
So an average of almost 6 seconds in reaction time from a droplet movement
detected to movement of the servo motors. The times recorded spans from around 5
to 8 seconds, somewhat stable in time. The real question here is whether these
results are acceptable for actual experiments. For the kind of slow droplet
experiments the Splotbot was capable of handling, we do believe these times
would be acceptable for experiments. 

##Summary/Conclusion
\label{sec:autonomous_summary}
To make the EvoBot capable of running autonomous experiments, we extended the
EvoBot software with the capabilities to sending instructions to components and
we made it possible for components to communicate events with data. We then made
it possible to program experiments.

To allow for execution of instructions we introduced an instruction buffer. This
buffer holds instructions and parameter values. An action list is created at
startup to contain all of the possible component actions available as functions,
an instruction number is the index to the action list. On execution the buffer
takes the instruction and uses it to call an action from the list of actions.
An action will then take the parameters from the buffer and do a method call to
a component. Combined the instruction buffer and action list allows a user to
defined a set of instructions and values to execute a none responsive
experiment.

We then introduced events to the system, allowing a component to communicate
when something have happen. All components will be initialised with the same
pointer to an event function. They can then use the function to send an event
with event data.

Finally we completed the system with a programming language that allows the user
to define autonomous experiments. The language includes basic features such as
arithmetics, variables, conditionals and a print statement. More importantly the
language also contains the possibility of calling components actions, which will
result in instructions and values being put on the instruction buffer. To make
the language capable of making autonomous experiments, it also contains a
possibility for binding and listening for events and event data and use it to
call more component actions.

Combined these features allows the user to define an entire reactive and
autonomous experiment in the programming language and get it run on the EvoBot
using the instruction buffer and event system.

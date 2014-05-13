# Autonomous interaction with experiments
\label{sec:experiment_interaction}
 The EvoBot should not only be able to run experiments, it is also made to be
 capable of running autonomous experiments, that is to say that the experiments
 will be start by a human but will be completely self sustained and be capable
 to actively react to changes happening in the observed system. This chapter
 looks at the implementation of the system that allows a user to define an
 experiment and how this system allows for having autonomous experiments.

 We first introduce the goals of the experiment running system. We then look at
 each part of the system discussing how it has tried to achieve the goals and
 the result of the approach including a discussion of possible improvements and
 alternative solutions.

##Goals
The idea behind an autonomous experiment is to define a experiment executing
that loops and continuously adjusts overtime. This is illustrated in figure
\ref{fig:reactive_loop}. The loop begins with the initial actions that will be
executed setting up the experiment for example picking up liquid and putting in
into a petri dish. After the initial actions the experiment will be running,
events with data such as droplet movement will be detected by components. Based
on events in the system the robot will then react doing new actions which will
change the experiment. This loop will create and autonomous reactive feedback
process that will running do actions to change the outcome of the experiment
based on data gatherer throughout the experiment.

![Reactive experiment loop. \label{fig:reactive_loop}](images/autonomous.png)

Making a user capable of defining autonomous experiments in this system requires
a few capabilities added to the robot, making these capabilities available will
be the goals of this chapter

1. Being able to send instructions to components to perform actions
2. Components should be able to communicate events with data in their executing
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
actions. What we want for the execution is an system that allows us to easily
enqueue instructions and then get them executed sequentially making the robot
carry out actions in order. We also want instructions to be capable of taking
parameters, that is to allow us to instruct a component to based on some
parameters perform a certain action, for example we might want instruct a motor
to move to a certain position.

<!-- Execution the integer instruction buffer, action list-->
At the core of our instruction execution model lies two important data
structures, the first being the instruction buffer and the second being the
action list. The instruction buffer is a thread safe FIFO queue that contains
integer instruction and integer arguments. The point is that new instructions
gets added to the instruction buffer, which then gets emptied by a main work
thread executing every instruction. In this system we define instructions as
integers which is the index of the actions in the action list. The action list
is a list of functions that takes a pointer to the instruction buffer. When an
action gets invoked with the instruction buffer it starts by popping the wanted
arguments from the instruction buffer, calling a components method with the
arguments. This cycle will continue as new instructions are put into the buffer
and take out and executed, it can be seen as an illustration in figure
\ref{fig:instruction_buffer}. To ensure that the instruction are run in
sequential order there is only a single runner thread and if a component wants
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
list is therefor determined by the order on the components in the configuration
file, as well as how many actions each component before the action in question's
component have and also in which order the action's component have defined it's
actions. Every action is simply a function that takes a pointer to the
instruction buffer, when the action is invoked it pops the amount of arguments
it needs from the buffer, this is defined in the components implementation. The
code for an action can be found in the specific component often defined as a
simple lambda expression that pops from the instruction buffer and wraps a
normal method.

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
possibility of storing a pointer to the string as an integer on the stack as
well, making it possible for the action call to access the string at a later
point by converting the integer to the pointer.  Making more data types
available would potentially make some component methods richer with more
options, while we did not encounter such needs in a limited implementation it
could be and issue at a later stage.

The solution in this state allows for arbitrary user defined experiments, where
a user can define a set of instructions that can make the robot do something.
This does not however allow the user to get any feedback from the system, nor
does it allow the user to define autonomous experiments.

##Sending events with experiment data
\label{sec:autonomous_events}
%Introduce problem
So now we can execute instructions and thereby make the robot capable of
performing a user defined set of actions. Now we want to extend the model to
enrich the communication possibility of components. We want to make them capable
of informing the user and the rest of the system of their state and possible
discoveries in the experiment. To do this we want to make a system where
components can announce that something have happened, including some data and we
want to be able to listen to this output and propagate it to the user. In other
words we want an event based system.

%Event callback and pointer
To extend EvoBot to include an event system, we introduced the event function.
This is a single function that every component calls when wanting to communicate
an event. We store this pointer in the main class in a variable, making it
possible to change the function at a later stage. Every component gets
initialized with a pointer to the function in the main class, allowing the to
call the function when needed and to ensure that updating the event function
will propagate to the components. Our event system therefor allows us to bind an
event function such that we can send data to the client etc.

%Data and Component usage
Sending data required us to define what data we wanted to send for each event.
We wanted the system to be universal so we used it to both propagate values such
as droplet speed, as well as images from our camera to the client through the
event system. This made is take the step to make the event system take a single
string as the entirety of the data, making it the responsibility of the receiver
to decide how to handle the data. 

The event system in itself allows us send data to the user, making them capable
seeing images, numeric data etc. This however does not allow the user to make
the robot react to the data and the only way to extended the event binding is
through changing the C++ source code.

##Programming experiments
\label{sec:autonomous_programming}
%Introduce problem

%Not interpreter, not other language, make DSL!

%Wanted features

%Language spec %Component Call %Event listening %Arithmetic %Conditional %Print
%Robotic Universal Control Language

```Cs
Component.action(1,2)
```

```Fsharp
(event: arg1, arg2) -> {

}
```

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
    } else { print "dropletspeed called" () }
}

Camera.mode(2)
```

%Lexer Parser AST process.

%Hookup to components, instruction buffer and event system


##Event reaction experiment
\label{sec:autonomous_experiments}
%Introduction to the experiment

%Data Presentation

%Discussion of results, is it okay?

##Summary
\label{sec:autonomous_summary}


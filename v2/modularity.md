# Achieving modularity in hardware and software
The EvoBot is but a step on the ladder towards the end goals stated by
the EVOBLISS project. It is unclear exactly what functionality will be
required from the platform down the road, this brings a need for
a hardware and software architecture that supports the addition and
replacement of components without requiring major alterations to the
existing setup. Modularity is for this reason considered essential to
the design of the robotic platform.

Modularity is also of importance from the point of view of the user in
getting as much 'experiments for the money' as possible. Modularity in
the robotic platform can be a means of reusing much of the same
hardware for very different experiments, exchanging as little as
possible, rather than having to have a specialized robot for each type
of experiment to run.

In this chapter, we first outline the goals concerning the modularity
of the platform in more practical details. We then describe what we
have done to achieve these goals, followed by a discussion of the
experiences we have made during the course of the project in this
regard.

## Goals
'Modularity' bears varying meaning between people. The modularity we are
discussing is modularity in the hardware components of the robot.  Such hardware
components can be added and removed, and the various hardware setups are
supported by the software controlling the robot.  The modularity must exist in
several granularities. It must both be possible to e.g. add an additional
syringe or camera to the setup, as well as removing all components but a single
RC servo motor, altering the setup completely. From this, we have put forth two
goals. The first is that **all functional parts of the robot must be
exchangeable**. By this we mean that the robot is allowed to consist of some
base hardware and software, such as the frame of the robot and the core part of
the source code. But this basis must serve as a platform on which the rest of
the robot can be build. When discussing these advantages of such modularity, it
is important to keep in mind the requirements they impose on the user, that is,
to what degree we consider it fair to inconvenience the user. Our second goal
stems from this. It is that **altering of the setup must be a little as possible
an inconvenience to the user**. This goal is difficult to quantify, but we have
included it, as it is important to keep in mind, as it has an effect on the
design decisions made.

## The current design
As modularity influences much if the design, this sections many different parts
of the robot. We have attempted to split it into shorter sections, each explaining
an area of interest. We start by explaining the level of modularity we have
implemented, outlining the design decisions underlying the rest of the work on
reaching the goal. We then give an outline of the architecture of EvoBot with focus on
modularity, followed by a more details on the implementation of the specific
parts of the EvoBot.

### Underlying design decisions
In order for such modularity in hardware to exist, the software must know how to
handle different kinds of components e.g. knowing how to step a stepper motor as
well as knowing what hardware components the setup consists of. Each of these
two can either be done automatically in the software, or it can require user
input. For this prototype of the Evobot we have decided that the software has to
know how to handle a number of basic components such as stepper motors and RC
servo motors, while changing the hardware setup requires the user to inform the
robot of the changes made (which components the setup consists of and how it is
connected to the BeagleBone Black). Based on this information, the software
provides an interface to the user, allowing her to control the components. More
specifically, this 'informing' is achieved through a configuration file, which
contains all the information about the setup needed to control it. This is
elaborated in section \ref{sec:modularity_design_configuration_file}.

In the case of the user wanting to use a component not supported by the
software, the software must be altered and recompiled. In order to avoid the
user / developer (without meaning to do so) altering the implementation of support
for existing components, support for additional hardware components in the
software must be achievable by implementing a fixed software interface as
decoupled as possible from the implementations of existing components. Section
\ref{sec:modularity_design_software_components} explains this in more detail.

### Modularity throughout the architecture
The requirement of modularity has deep impact on the overall architecture of the
robotic platform, as the modularity must be reflected in everything, both
hardware and software parts. We will here give an overview of the architecture
and components, keeping modularity in focus, followed by a more detailed
explanation of how the different parts of the architecture are designed to
support the goal set forth.

The architecture of EvoBot is outlined in figure \ref{fig:architecture_overview}
showing the interaction between the four main parts of the robotic platform. The
architecture is layered (the bottom layer is to the left in the figure); the
first two parts cover the hardware itself and the controlling of it, and the
next two parts are an attempt to create an environment in which the user
interface can be built.

![Outline of the architecture of EvoBot.\label{fig:architecture_overview}](images/architecture_overview.png)

- The bottom layer of the architecture is the hardware. The basis of the
  hardware is the frame on which the rest of the components are mounted. Each
  hardware component is then considered an individual module in the
  architecture. This is e.g. an RC servo motor, a set of X/Y axes driven by
  stepper motors, or a camera.
- The next layer is the software controlling the hardware. It is initialized
  from a configuration file defining the hardware, creating the coupling
  between the software and the hardware. This allows for modularity to the
  extend that modules can be added and removed requiring only that the
  configuration file is updated accordingly and the robot rebooted. This layer
  also include the logging of experiment data. This layer communicates only with
  the below layer (the hardware) through GPIO manipulation and messages to/from
  serial devices.
- The basis for the user interface is a web server. This is a thin wrapper on
  top of the below layer controlling the hardware, allowing for a simple way to
  interact with the robot. This layer communicates both with the below layer
  through function calls and with the above layer through distribution of events
  such as e.g. the event of a camera detecting a droplet with certain
  properties.
- The top layer is the graphical user interface itself, interacting only with
  the below web server. In this layer, the configuration file used for
  initializing the software layer controlling the hardware is also loaded. Based
  on this file the graphical user interface is built, continuing the coupling
  between the hardware and the software to also include the graphical user
  interface, as an attempt to support the goals of modularity. This layer
  interacts with the below layer by sending instructions to the robot and
  through receiving events transmitted by the below layer.

The architecture reflects the modularity in all layers. In the architecture,
the hardware components are considered separate modules, and the same modules
are represented as modules in the remaining layers (except for the web server
which knows no logic but simply forwards incoming requests from the below and
above layers). The difficulty in achieving this lies in the layers having to all
agree on the setup (the core software must know what hardware to control, and
the user interface must equally know in order to sent instructions to the robot
that makes sense).

### Gluing together the different layers
\label{sec:modularity_design_configuration}
As mentioned in the architecture description, the coupling between hardware
and software is done in a configuration file. This configuration file
then ensures that the user interface and hardware interacting components are
in sync, allowing hardware components to be trivially added.

The goal that the robot must know a number of basic components is a
question of implementing these in (1) the software layer controlling the
hardware, and (2) in the user interface. Currently, the components implemented
are:

- `XYAxes`. A set of two axes driven by stepper motors.
- `RCServoMotor`. An RC servo motor capable of rotating 90 degrees.
- `Camera`. A camera capable of grabbing images from a video device and
  doing droplet detection. 
- `Scanner`. A component with no corresponding hardware component, which
  instead makes use of existing `XYAxes` and `Camera` components to
  grab multiple images and stitching them together using computer vision
  techniques, resulting in the scan of a surface area larger than what can be
  grabbed in a single image.
- `CameraCalibrator`. Similar to the `Scanner` component, this component
   has no hardware of its own, but contain references to an `XYAxes`and a
   `Camera` component. It contains the logic of automatically calibrating the
   camera (see section \ref{sec:computer_vision}), allowing for removal of
   radial distortion and for computing the values needed for some of the image
   stitching algorithms (see section \ref{sec:image_stitching}).
- //TODO add the rest of the components when done

More such components can be added in the software as defined in the
requirements. The implementation of a component is done in the following steps:

- The settings of the component must be defined e.g. a syringe component which
  consists of two servo motors connected to the Servo Controller. The definition
  must be reflected in the configuration file. The definition must at the very
  least have a type name (e.g. Syringe), a name (unique for each component
  instance), and how it is connected to the peripherals of the BeagleBone Black.
- The component must be implemented, inheriting from the `Component` C++ class
  and implementing the virtual methods.
- The `componentinitializer.cpp` file must be updated to know about this new
  type of component including how to initialize it from the configuration file.
- In the client, a corresponding GUI component must be implemented, and the
  service `configService` in the file `config.js` must be updated to know
  the number of actions registered by the new component.

The configuration file is written in JSON, as it provides a human readable
format which is natively supported in javascript as well. JSON has become 
a kind of lingua franca data exchange format and libraries for it exists for
most languages, including C. The thoughts behind the structure of it is to keep
it as minimal as possible, stating only what is needed to achieve the needed
functionality. As described above, this entails a name, a type and often some
element of IO interaction. Name and type is always required, and are thus top 
level elements. The rest is optional and exists in a general "parameter" 
object in the configration. Currently the most verbose example of this structure
is the XYAxes:

```json
	{
		"type": "XYAxes",
		"name": "BottomAxes",
		"parameters": {
			"x_port": "X",
			"y_port": "Y",
			"x_limit_switch_port": "J9",
			"y_limit_switch_port": "J11",
			"x_step_limit": 79,
			"y_step_limit": 58
		}
	}
```

### Modularity in the hardware
The hardware is currently modular in the sense that different components can be
attached and removed. This is mainly an effect of our delightfully simple
carriage design as depicted in \ref{fig:carriage_design}. It has a number of
wooden pins with a fixed distance between them. Modules designed for the EvoBot
must then have holes fitting these, making them both easy to attach and remove
(assuming that the holes are the correct size, with which we have had
difficulties). This makes it a relatively trivial task to design new modules. We
must admit, however, that we have tested only with the camera module. It is very
likely that a better design can be made.

Looking further down the road, it has been voiced as a desire by people involved
in the EVOBLISS project to have further extendibility of the platform
components, such as making the robot consist of several frames on top of each
other, achieving modularity in a more coarser granularity. The current EvoBot
platform does not support such features, but an alternative design with this in
mind is discussed in section \ref{recommendation_of_better_design}.

![Carriage design.\label{fig:carriage_design}](images/todo.png)

### The use of BeagleBone Black peripherals
In order to make the BeagleBone interact with the actual hardware, we have to
make use of its peripherals. For this, we actually make no directly use of the
GPIO pins of the BBB, rather, we interact with the hardware in two different
ways, depending on the hardware:

1. The stepper motors and limit switches are controlled through the BeBoPr++
cape on which the BBB is attached.
1. RC servo motors and cameras are controlled through USB, the camera being
directly connected to the BBB, while the RC servo motors are connected to a USB
controlled servo controller, the Polulu Maestro Servo Controller *//TODO check
the name*, which is then connected to the BBB.

Figure \ref{fig:modularity_design_peripherals} shows how everything is
connected.

![How the hardware is connected to the peripherals of the BBB.\label{fig:modularity_design_peripherals}](images/todo.png)

The USB devices introduce no difficulties. The camera registers itself as a
video device, which can be read from, and the servo controller can be controlled
by sending simple commands to the serial port.

Interacting with the BeBoPr++ cape has been a mixed experiences. The limit
switches are very simple to interact with, as they are each connected to a given
set of pins on the BBB. Since this is the case, their values can be read
directly through the virtual file system making these pins available. It only
requires that the pins are activated.

But with the stepper motors, the interaction becomes a lot more complex. As far
as we have been able to figure out, the design of the BeBoPr++ cape means that
the stepper motors can only be controlled through the PRUSS microcontrollers on
the BBB. The BeBoPr++ cape comes with a piece of software, `Mendel`, which can
be used for controlling the peripherals of the cape. The cape is, however,
designed for controlling a RepRap Prusa Mendel *//TODO ref* printer, and the
software is written solely with this in mind. This means that the only way to
control the software is by sending G-code strings the standard input of the
process running it. As a further note, the stepper motors of the 3D printer have
different functions, and the `Mendel` applications therefore treats them
differently, but on the EvoBot, the motors must all be treated the same. To
solve this, we have made slight changes to the `Mendel` software (as it is Open
Source), making sure:

1. All the stepper motors are treated the same
2. The software does not check that the motors have stepped past their limits

What this means in practice is that communication with the cape consists of the
following steps:

1. When we run our application, we start as background process running the
`Mendel` software. This process reads from a socket file as standard input
1. We start by sending the G-code command `G91` to `Mendel`, making sure
it used relative positioning 
1. When we wish to reposition as set of axes, we send a move command such as `G1
X10 Y3`, telling `Mendel` to move stepper motor `X` 10 steps and stepper motor
`Y` 3 steps (negative values move the other way). In this case, the motors
controlling the X/Y axes are connected to the `X` and `Y` stepper motors ports
on the cape respectively.

This setup works but is far more complicated than what would be necessary could
we control the hardware directly from the BBB.

## Issues with the current design
During the course of the project, some limitations in the current design have
revealed themselves, some of which would require a complete revision of the
architecture of the robotic platform, if they are to be overcome.

One of the major limitations lie in the use of the limited number of
peripherals of the BeagleBone Black. With the BeBoPr++ cape attached, the
robotic platform supports up to four stepper motors with no way of adding
additional stepper motors, if they are to be controlled in the same way as the
existing four stepper motors. The issue has several causes:

- The BeBoPr++ cape is a very specialized cape for running 3D-printing hardware
  directly from the peripherals of the cape. The cape targets are specific
  printer (Mendel), making the hardware for which it is made very fixed in its
  nature. This means that the peripherals of the cape are limited to exactly
  what is needed on such a printer. And this is different from what is needed on
  EvoBot. Some existing inputs / outputs are not needed, while other needed
  inputs / outputs does not exist.
- As with the hardware, the software for interacting with the cape is equally
  targeted a specific 3D-printer, meaning that e.g. the logic for controlling
  each of the stepper motors various due to the different use of these motors in
  the 3D-printer setup. Even though we have been able to modify the software
  slightly for our needs, our own software still depends on the quite large and
  complicated piece of software, in which we only use a very small part. This
  further means, that if something does not work as expected in this software,
  it is very difficult for us debug the software, as it functions more or less
  as a black box in which we input G-code and expect the stepper motors to react
  accordingly.

This issue could be overcome by not using the peripherals of the BeagleBone
Black (or the BeBoPr++ cape) and instead using the USB port of the board. A good
example of this is the way in which we control RC servo motors. These motors
are controlled directly from a USB servo controller, of which more can be added,
if more RC servo motors are needed.

The use of the BeBoPr++ cape actually introduces a further complications due to
our asynchronous use of the Mendel software. The first thing is that the way we
simply write to the socket file, which at some point is read by the process
running the Mendel application (in the single-core processor environment). The
other thing is that the Mendel software controls the stepper motors by using one
of the PRUSS of the BeagleBone Black. It does so by enqueing a piece of assembler
code to be run on the PRUSS, which it the executes as some point. In the end,
the result is that it is very difficult for us to know exactly when stepper
motors are run. One of the places where this is visible is when homing a pair of
X/Y axes on EvoBot, which is achieved by sending a G-code command to the Mendel
software and sleeping for some time, during which we expect the motors to move,
after which we check if the limit switch is pressed.  In practice, this has
worked every single time, though it makes the homing process quite cumbersome to
the long total sleep time, but in theory, some special case of process scheduling
in the CPU could result in the motor not moving until after a new command has
been sent to the Mendel software. This issue can easily be forced by lowering
the time slept (currently 1 second), in which case it becomes apparent in
practice as well.

A final issue with the BeBoPr++ cape is the price. We currently use it only for
controlling 4 stepper motors (and for circuit protection), but the cost of it is
about twice the cost of the BeagleBone Black itself. And on top of the price,
the stepper motor drivers have to be bought separately. This is quite expensive
for controlling only the stepper motors.

Another limitation in the current design is in the somewhat complex process of
adding support for additional components in the software, in which case quite
the number of different files must be modified. This makes sense, if the module
added is very different from existing components, so the logic is completely
new. But it is difficult to justify the complexity, when e.g. a new module must
be added which simply is capable of controlling two RC servo motors in parallel,
when the logic of controlling a single RC servo motor is already implemented.
Furthermore, the current design until partially fulfills the requirement
concerning of the developer not risking to break the code of existing
components, since some files shared between the components must be edited.

In the following, we outline our recommendation of how modularity could be
designed into the EvoBot, overcoming the above limitations.

## Suggestion of a better design
\label{recommendation_of_a_better_design}
Working with the design as it currently looks, having to work with the
limitations inherent in the design decisions made, we have made a design of the
architecture which we believe would avoid the issues discussed above. We will
here briefly outline this design.

The architecture of the recommended design is achieved by splitting the
responsibility of the software controlling the hardware into to layers. This is
illustrated in figure \ref{fig:recommended_architecture_overview}. Rather than
controlling the hardware directly from the peripherals of the BeagleBone Black,
each module has a corresponding microcontroller which knows the logic of how to
control the hardware. Each microcontroller is also capable of registering itself
as a component with the BeagleBone Black. This can be achieved by some standard
interface, of the BeagleBone Black sending a predefined command to each attached
component, which in turn sends back meta data explaining how to control the
component. 

![Outline of the recommended architecture of EvoBot.\label{fig:recommended_architecture_overview}](images/todo.png)

The meta data must be designed in such a way that it can be understood by the
BeagleBone Black which can automatically generate a user interface for each
component. This could quite simply be achieved by the meta data containing a
definition of each action the module is capable of executing, including the
action number and number of arguments and a name of each of these, along with
the events emitted from the component and a similar definition of these.
Instructions could then be sent to component as strings over the serial port
similar to G-code strings. The flow of information between a microcontroller and
the BeagleBone Black is illustrated in figure
\ref{fig:recommended_software_flow}.

![The interaction between a microcontroller and the BeagleBone Black in the recommended architecture.\label{fig:recommended_software_flow}](images/todo.png)

//TODO should we have an example of such metadata and an instruction string?

As a result of the above, the current configuration file would not be needed, as
the components would now be capable of registering themselves at startup. This
would make the modification of the hardware setup more seamless.

In the recommended design, the camera would have to be considered as a special
kind of component, as the camera component does more than simply manipulation of
input and output ports. The question is where the image analysis and processing
is to take place. We have considered the following two options:

1.  The camera could be attached directly to the BeagleBone Black as currently is
    the case, and the board could take care of the image analysis and processing.
1.  The camera could be attached to a device capable of doing the image analysis
    and processing, which then registers itself as a component in the same way
    as the other components.

Our experiences with doing image analysis and processing on the BeagleBone Black
have shown performance issues (discussed in more detail in section
\ref{sec:standalone}. The board can at most use a single camera at a time, and
it is at the cost of most of the processing power. So from a performance
point of view, the second option is preferable. However, from a cost
perspective, having multiple boards with general purpose CPUs are likely to
increase the overall price of the robot. Still, the second option remains
our recommendation, as it is the most likely to result in the most stable
robotic platform, not suffering from sudden delays in the experiments run
due to spikes in the use of the CPU of the BeagleBone Black. //TODO we have
to try with more cameras before making this statement

Similar to the camera, the current setup consists of modules such as the
`Scanner`, that control no separate piece of hardware, but which rather is a
container of logic that has references to other components which through which
it manipulates hardware. Again, these components can either exist solely in the
logic of the BeagleBone Black, or they can be a separate controller. The
recommendation remains the same as with the camera that the processing should be
contained in a separate hardware unit. This adds are requirement that the
BeagleBone Black provides an interface to the components for both (1)
discovering each other, e.g. a `Scanner` component must be able to discover a
`Camera` and an `XYAxes` component, and (2) for sending instructions to each
other.

This new architecture has the advantages over the existing architecture that it
fulfills the requirements to the modularity in a stronger sense than the current
design, making it easier for users to alter the hardware setup, while also
moving the heavy processing between multiple components. But it is at the cost
of introducing a lot more controllers to EvoBot thereby increasing the overall
cost of the robotic platform.

One major disadvantage remains, and that it that it is entirely untested. This
new design is purely made from our thoughts, and actually implementing it is
likely to reveal a number of flaws currently undiscovered by us. It is a topic
we find is worth looking into, as the implementation of impacts most of the rest
of the EvoBot.

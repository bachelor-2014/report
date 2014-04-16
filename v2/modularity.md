# Achieving modularity in hardware and software
The EvoBot robot is very much under development and not a finished product.
The result of this is that the components of which it consists are rapidly
changing, which brings a need for a hardware and software architecture that
supports the addition and replacement of components without requiring major
alterations to the existing setup. This is one of the reason why modularity is
considered essential to the design of the robotic platform. Modularity is also
of importance from the point of view of the user in getting as much 'experiments
for the money' as possible. Modularity in the robotic platform can be a means of
reusing much of the same hardware for very different experiments, exchanging
as little as possible, rather than having to have a specialized robot for each
type of experiment to run.

In this chapter, we first outline the requirements concerning the modularity of the
platform in more details. We then describe what we have done to fulfill these
requirements, followed by a discussion of the experiences we have made during
the course of the project in this regard.

## The requirement
Modularity is a vague requirement to EvoBot if not considering the kind of
modularity desired. The modularity we are discussing is modularity in the
hardware components of the robot. Such hardware components can be added and
removed, and the various hardware setups are supported by the software
controlling the robot. The modularity must exist in several granularities. It
must both be possible to e.g. add an additional syringe or camera to the setup,
as well as removing all components but a single RC servo motor, altering the
setup completely.

In order for such modularity in hardware to exist, the software know how to
handle different kinds of components e.g. knowing how to step a stepper motor as
well as knowing what hardware components the setup consists of. Each of these
two can either be done automatically in the software, or it can require user
input. We have defined the requirement as the software having to know how to
handle a number of basic components such as stepper motors and RC servo motors,
while changing the hardware setup requires the user to inform the robot of the
changes made (which components the setup consists of and how it is connected to
the BeagleBone Black). Based on this information, the software provides an
interface to the user, allowing her to control the components.

In the case of the user wanting to use a component not supported by the software,
the software must be altered and recompiled. This introduces a requirement to
the software architecture of the robotic platform. In order to avoid the user /
developer (without meaning to do so) alters the implementation of support for
existing components, support for additional hardware components in the software
must be achievable by implementing a fixed software interface decoupled from the
implementations of the control of existing components.

Of course, an important point in the requirement of modularity is that it is
possible to construct the hardware setup that is the goal of this project with
top and bottom carriages movable along to axes and different components attached
to these.

Our goals concerning the modularity of the robotic platform can be summarized in
the following points:

- Both the hardware and the software must be constructed in such a way that it
  is possible to exchange an entire component such as adding or removing an RC
  servo motor, requiring only that the user informs the robot of the change,
  restarts the robot, and calibrates the component if necessary.
- The software implementation must contain implementations of the most basic
  components, which are X/Y axes driven by stepper motors, RC servo motors, and
  cameras.
- In the software implementation it must be possible to add support for
  additional types of components without making any changes to the existing
  implementation. A recompilation of the entire source code is allowed as the
  result of adding additional code.
- The modularity in software covers both the software controlling the hardware
  and the user interface.
- The design must support the setup of having a top and a bottom carriage moving
  separately along two axes with various other hardware components attached.

## The current design
The requirement of modularity has deep impact on the overall architecture of the
robotic platform, as the modularity must be reflected in everything, both
hardware and software parts. We will here give an overview of the architecture
and components, followed by a more detailed explanation of how the different
parts of the architecture are designed.

The architecture of EvoBot is outlined in figure \ref{fig:architecture_overview}
showing the interaction between the four main parts of the robotic platform. The
architecture is layered (the bottom layer is to the left in the figure); the
first two parts cover the hardware itself and the controlling of it, and the
next two parts are an attempt to create an environment in which the user
interface can be built.

![Outline of the architecture of SplotBot.\label{fig:architecture_overview}](images/architecture_overview.png)

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
  the below layer (the hardware) through GPIO manipulation. //TODO should we
  include the part about mendel.elf here?
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
above layers). But defining the coupling between hardware and software in a
configuration file from which the software (including the user interface) is
initialized, the first requirement is fulfilled, allowing hardware components to
be added and removed only requiring that the user updates this file.

The requirement that the robot must know a number of basic components is a
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

More such components can be added in the software as defined in the
requirements. The implementation of a component is done in the following steps:

- The settings of the component must be defined e.g. a syringe component which
  consists of two servo motors connected to the Servo Controller. The definition
  must be reflected in the configuration file. The definition must at the very
  least have a type name (e.g. Syringe), a name (unique for each component
  instance), and how it is connected to the peripherals of the BeagleBone Black.
- The component must be implemented, inherting from the `Component` C++ class
  and implementing the virtual methods.
- The `componentinitializer.cpp` file must be updated to know about this new
  type of component including how to initialize it from the configuration file.
- In the client, a corresponding GUI component must be implemented, and the
  service `configService` in the file `config.js` must be updated to know
  the number of actions registered by the new component.

The fulfillment of the last requirement is reflecting in the fact that the
current setup is functioning correctly. //TODO remove this line if it does not,
indeed, function correctly

### The structure of the configuration file
//TODO

### Modularity in the hardware
//TODO

### The use of BeagleBone Black peripherals
//TODO

## Issues with the current design
//TODO

- It could be easier to add new components in software by e.g. having a meta
  config file.
- Limitations in the peripherals of the BBB + BeBoPr
- The modules themselves could contain the logic

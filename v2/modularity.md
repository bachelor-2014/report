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

The case of the user wanting to use a component not supported by the software,
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
  is possible to exchange an entire component such as adding or replacing an RC
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

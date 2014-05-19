#Building the software to control EvoBot 
\label{sec:software}
In this chapter we first introduce software used to control Splotbot and compare
it with the software developed for EvoBot. Then we look at how the EvoBot core
software application is constructed. Finally we look at how the software
accesses the EvoBot hardware.

##The software used to control Splotbot
The software for controlling Splotbot is written in Python. It is based on the
Printrun application made for controlling 3D printers, which is also written in
Python. The hardware is controlled by sending G-Code instructions to the Arduino
microcontroller of Splotbot. The software runs in a personal computer connected
to the Arduino board through USB. The camera of the setup is connected directly
to the personal computer.

##From Splotbot to EvoBot
The software for controlling EvoBot is rewritten entirely from scratch. This is
due to some important factors. The electronics of the hardware setup has changed
much, replacing the Arduino board with the BeagleBone Black, as we seek to make
the robotic platform completely stand alone. This means that the software core
no longer runs on the personal computer of the user, but on the BeagleBone
Black. As the board is limited in computational power, we wanted to use a lower
level language with better performance to partially make up for this.

EvoBot also differs from Splotbot in that it has to be a platform for executing
many different types of experiments which might require other hardware to be
added to the system. We emphasise a software architecture that allows the
functionality to be extended with other types of hardware.

##Constructing the software core 
\label{sec:software_constructing}
The core of the software is written in C++ and is responsible for executing
experiment code, communicating with the hardware, logging data, emitting events
and in general it is the most extensive part of our code base with the main
responsibility for handling the platform. The software consists of a module
based system where modules are loaded at startup based on settings in a
configuration file. This allows for modularity in our design and for new
hardware to be added in the future.

The center of the software core is the `Splotbot` class, which was given the
name before the robot became EvoBot. The Splotbot class constructs all the
software components from the configuration file. All of the components are then
instructed to register their actions in the action list, a list of every
intruction that can be executed on the robot. The action list is later used to
call the different component actions. Currently the EvoBot has five available
components each with different functionality and hardware requirements:

![Simplified class diagram of the core EvoBot software. \label{fig:class_core}](images/class_core.png)

- **Camera** handles video recording, image grabbing, and droplet 
  tracking
- **XYAxes** is used to control a set of two axes on the robot. It has
  functionally to move the carriage to a specific position and for homing 
  the position of the carriage to its initial value 
- **RCServoMotor** is used for a single servo motor and has functionality to
  move it. In a more complete setup a component type such as a '`Syringe`'
  would probably be used instead of this component
- **CameraCalibrator** is used for calibrating the camera. This component has
  functionality to perform a camera calibration and for saving and
  loading such calibrations
- **Scanner** is used to scan large surface areas using image
  stitching techniques

An important part of the design of the software core has been to ensure that it
is kept modular with the intention of making it possible to extend it with more
hardware options in the future. Modularity is achieved by making components for
each feature of the robot encapsulate the functionality in a single place. A
component is then defined in the configuration file to signal to the software
that it should be available. Implementing a component can be done by using the
following steps:

- The settings of the component must be defined e.g. a syringe component which
  consists of two servo motors connected to the physical Servo Controller. The
  definition must be reflected in the configuration file. The definition must at
  the very least have a type name (e.g. Syringe), a name (unique for each
  component instance), and how it is connected to the peripherals of the
  BeagleBone Black.
- The component must be implemented, inheriting from the `Component` C++ class
  and implementing the virtual methods.
- The `componentinitializer.cpp` file must be updated to know about this new
  type of component including how to initialize it from the configuration file.

The configuration file is written in JSON. An example of a component in a
configuration file can be seen in figure \ref{fig:example_config}.  As a part
of the configuration every component needs to state its type, name and some
parameters that the C++ code of the component will use. The parameters are
often used to define on which ports some hardware can be accessed.

\begin{figure}
\begin{lstlisting}[language=json,firstnumber=1]
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
\end{lstlisting}
\caption{Example config}
\label{fig:example_config}
\end{figure}

## Controlling the hardware from software
EvoBot consists of multiple hardware components which are all accessed in
different ways. This section serves as a description for each of the hardware
components accessed and explains how they are controlled.

1. The stepper motors and limit switches are controlled through the BeBoPr++
cape on which the BeagleBone Black is attached. 
1. RC servo motors and cameras are controlled through USB, the cameras being
directly connected to the BBB, while the RC servo motors are connected to a USB
controlled servo controller, the Polulu Maestro Servo Controller, which is then
connected to the BeagleBone Black.

The servo controller can be controlled by sending simple commands to the serial
port. We based our implementation of this on the C program available on the
Pololu website [@pololucode].

The camera registers itself as a video device, which can be accessed through
OpenCV that uses the video4linux driver. But there are some issues regarding
video codes, as OpenCV depends on FFmpeg which in turn depends on the codecs
installed. While we found a codec that worked on the BeagleBone Black, it did
not always work on each of our development computers, making a common
configuration impossible.

The limit switches can be accessed through the file system to to a device tree
overlay on the BeBoPr++ cape. Each limit switch, of which there can be at most
six, has a folder with a 'value' file in it. By reading from this file, as you
would any other ordinary file, it is possible to see whether the switch is
pressed or not.

With the stepper motors, the interaction becomes a lot more complex. As far as
we have been able to figure out, the design of the BeBoPr++ cape means that the
stepper motors can only be controlled through the PRUSS microcontrollers on the
BeagleBone Black. The BeBoPr++ cape comes with a piece of software, `Mendel`,
which can be used for controlling the peripherals of the cape. The cape is,
however, designed for controlling a specific 3D printer, and the software is
written solely with this in mind. This means that the only way to control the
software is by sending G-Code strings the standard input of the process running
it. As a further note, the stepper motors of the 3D printer have different
functions, and the `Mendel` applications therefore treats them differently, but
on the EvoBot, the motors must all be treated the same. To solve this, we have
made slight changes to the `Mendel` software (as it is Open Source), making
sure:

1. All the stepper motors are treated the same
2. The software does not check that the motors have stepped past their limits

As a part of starting the EvoBot software, we:

1. Create or truncate a text file
2. Start the Mendel software
3. Open a continuous stream reading from the file and pipe it into the Mendel software
4. Pass the path to the file to the EvoBot software

This way, every time an instruction must be sent to the BeBoPr++ cape, we write
the G-Code to the text file which is then read by the Mendel application and
executed. 

During the course of the project, some limitations in the current design have
revealed themselves, some of which would require a complete revision of the
architecture of the robotic platform, if they are to be overcome.

This asynchronous use of the BeBoPr++ cape introduces complications. The first
thing is that the way we simply write to the socket file, which at some point
is read by the process running the Mendel application (in the single-core
processor environment). The other thing is that the Mendel software controls
the stepper motors by using one of the PRUSS of the BeagleBone Black. It does
so by enqueing a piece of assembler code to be run on the PRUSS, which it the
executes as some point. In the end, the result is that it is very difficult for
us to know exactly when stepper motors have moved. One of the places where this
is visible is when homing a pair of x and y axes on EvoBot, which is achieved
by sending a G-Code command to the Mendel software and sleeping for some time,
during which we expect the motors to move, after which we check if the limit
switch is pressed. In practice, this has worked every single time, though it
makes the homing process quite cumbersome because of the long total sleep time.
But in theory, some special case of process scheduling in the CPU could result
in the motor not moving until after a new command has been sent to the Mendel
software. This issue can easily be forced by lowering the time slept (currently
1 second), in which case it becomes apparent in practice as well.

##Summary
The software used to control Splotbot is written in Python and uses the Printrun
application, also written in Python, to send G-Code instructions to the Arduino
controller, which controls the hardware. EvoBot is inherently different in that
the Arduino board is replaced with the BeagleBone Black, as the robot must be
stand alone. This also means the software runs on the BeagleBone Black rather
than on the personal computer of the user. Also, the architecture of EvoBot
focuses on modularity. Due to this as well as performance considerations, the
software for controlling EvoBot was written from scratch in C++.

The core software was designed with modularity in mind, resulting in a class
structure with classes representing components, each encapsulating the logic of
controlling a corresponding hardware component. The components are instantiated
at startup based on a configuration file written in JSON.

Each of the hardware components are controlled differently from software. The
camera is registered as a video device. The RC servo motors are controlled by
writing strings to the serial port on which the servo controller is connected.
Whether or not the limit switches are pressed can be read from a virtual file in
the file system. The stepper motors prove difficult, as we had to modify the
open source software accompanying the BeBoPr++ cape as well running this
software as a separate process to which we write G-Code in order to control
them.

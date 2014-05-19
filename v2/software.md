#Building the software to control the EvoBot
\label{sec:software}
In this chapter we will first describe how the software in Splotbot is
implemented. We will then compare the software of the Splotbot with that
of the EvoBot. Then we will look at how the EvoBot core software application is
constructed. Finally we will look at how the core software accesses the
EvoBot hardware

##Description of the software running Splotbot
<!-- Controlling using GCode -->
The core of the software that is used to run Splotbot is the python based
software Printrun. Printrun is made for RepRap 3D printers. It takes G-code
instructions and translates them to motor movements etc. The Splotbot can be
controlled by writing a set of G-code instructions to move the hardware because
most of the common functionality, such as moving axes, is accessible by G-code.

<!-- Python code -->
A user can control Splotbot by using a piece of Python software built on top of
Printrun. This software generates G-code that is executed by Printrun resulting
in movement of Splotbot. The Splotbot software is structured much like a library
and contains code for doing camera calibration, droplet tracking, robot movement
and controlling the syringes. In combination these features can be used to
design experiments to be run on the Splotbot.

<!-- Experiments -->
Experiments for Splotbot are designed as Python scripts using the rest of the
Splotbot code to provide the needed functionality. Experiments previously run on
the Splotbot includes taking liquid from containers and injecting it into a petri
dish, tracking a droplet and reacting to the droplet speed.

##From Splotbot to EvoBot
<!-- Intro -->
The EvoBot software differs from the Splotbot software in many ways and is a
complete rewrite of most of the functionality available in the Splotbot while
also adding new features. The software is no longer Python based but is instead
written in C++ and JavaScript. The main objective of the software is now to be a
single application that is run on EvoBot at startup. EvoBot also differs from
Splotbot in that it has to be a platform for executing many different types of
experiments which might require other hardware to be added to the system.
EvoBot therefore puts emphasis on a software architecture that allows the
functionality to be extended with other types of hardware.

<!-- Software core -->
The software still supports features such as droplet tracking, moving the
carriage, and moving servo motors. But it has been extended with features such
as scanning and stitching a large area, a web interface and a programming
language. Focus has been put on making a standalone robot to which a user can
connect and control without installing anything on his own computer.

<!-- Features: Droplet tracking, moving camera, scanning, programming language,
web interface -->
Experiments are now run by using the EvoBot software rather than by writing a
Python script. Experiments can either be defined as low level instructions
similar to G-code or via a domain specific programming language (DSL) made for
the EvoBot. The EvoBot also supports the possibility of making experiments that
observes the status of the petri dish and reacts based on it, such as watching
changes in the speed of a moving droplet.

##Description of the software running EvoBot

![The software architecture. Note how the old naming of the 'splotbot' class 
is preserved for consistency \label{fig:architecture}](images/architecture_overview.png)

The software written for our prototype is structured in three main
parts:
A core, the web server and a client. The core handles the robot
features, the web server acts as a bridge between the core and the client. The
client allows the user to manipulate the robot real-time and also allows the
user to send experiment code to be executed on the EvoBot. Below is a brief description of the
software in its entirety. The source code is available in our
Github repository [@bachelor_code].

<!-- Core -->
- The core of the software is written in C++ and is responsible for executing
  experiment code, communicating with the hardware, logging data, emitting events
  and in general it is the most extensive part of our code base with the main
  responsibility for handling the platform. The software consists of a module
  based system where modules are loaded at startup based on settings in a
  configuration file. This allows for modularity in our design and for new
  hardware to be added in the future.
<!-- Rucola -->
- The EvoBot becomes programmable for a user through the use of a custom DSL
  language called Rucola. We designed this language to fit the needs for
  creating experiments. Rucola is available as a library, which the core
  application uses to compile and evaluate Rucola code.
<!-- Computer vision -->
- As part of our application we have a library of computer vision related tools
  that some of the components in the core application uses to provide features
  such as droplet detection and image scanning.
<!-- NodeJS Server -->
- The web server, written in NodeJS, wraps the core application providing access
  to it through a web socket and REST http interface. This means that
  EvoBot functions as a 
  web service that can be accessed through any application language that supports
  web sockets and http.
<!-- Client -->
- The client consist of a JavaScript based web client, that communicates with
  the server through web sockets and http requests. Like the core
  application, the client similar loads the configuration file and constructs 
  the GUI based on this.


##Constructing the software core 
\label{sec:software_constructing}

![Simplified class diagram of the core EvoBot software. \label{fig:class_core}](images/class_core.png)

<!-- (or how we support modularity) -->
The software core spawns from the Splotbot class, which was given the name
before the robot became EvoBot. The Splotbot class constructs all the software
components from the configuration file. All of the components are then
instructed to register all of their actions in the action list. The action list
is later used to call the different component actions. Currently the EvoBot has
five available components each with different functionality and hardware
requirements:

<!-- Current components -->
- **Camera** handles video recording, image grabbing, and droplet 
  tracking.
- **XYAxes** is used to control a set of two axes on the robot. The XYAxes has
  functionally such as moving to a specific position, and resetting the position
  of the carriage to its initial value with homing. 
- **RCServoMotor** is used for a single servo motor and has functionality to
  move it. In a more complete setup a class such as a 'syringe' would probably
  be used instead of this component.
- **CameraCalibrator** is used for calibrating the camera. This component has
  functionality to perform a camera calibration, and for saving and
  loading such calibrations.
- **Scanner** is used to scan large surface areas using image
  stitching techniques.

An important part of the design of the software core has been to ensure that it
is kept modular with the intention of making it possible to extend it with more
hardware options in the future. Modularity is achieved by making components for
each feature of the robot encapsulate the functionality in a single place. A
component is then defined in the configuration file to signal to the software
that it should be available. Implementing a component can be done by using the
following steps:

- The settings of the component must be defined e.g. a syringe component which
  consists of two servo motors connected to the physical Servo Controller. The definition
  must be reflected in the configuration file. The definition must at the very
  least have a type name (e.g. Syringe), a name (unique for each component
  instance), and how it is connected to the peripherals of the BeagleBone Black.
- The component must be implemented, inheriting from the `Component` C++ class
  and implementing the virtual methods.
- The `componentinitializer.cpp` file must be updated to know about this new
  type of component including how to initialize it from the configuration file.

The configuration file is written in JSON, an example component can be
seen in figure \ref{fig:example_config}.
As a part of the configuration every component needs to state its type,
name and some parameters that the C++ code of the component will use. The
parameters are often used to define on which ports some hardware can be
accessed.
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

## Communication within the software

The following attempts to outline how the described parts of the architecture
interact with one another and, importantly, how they interact with the
underlying hardware.

### Communication from the core to the hardware
EvoBot consists of multiple hardware components which are all accessed in
different ways. This section serves as a description for each of the hardware
components accessed and explains how they are controlled.

<!-- Camera, OpenCV -->
- The camera of the application are accessed through OpenCV which uses
  video4linux as its underlying driver. The camera is accessed via the
  VideoCapture class in OpenCV where every frame can be grabbed with a single
  method call.
<!-- Stepper motors, mend.elf -->
- The stepper motors are accessed through the BeBoPr++ 3D printer cape.  This
  cape comes with software, named Mendel after the 3D printer model it is 
  created for. Mendel is capable of executing G-code instructions,
  controlling the hardware.
<!-- Servo motors, C code -->
- The servo motors are connected via the Pololu Servo Controller and can be
  directly communicated to through writing to the USB device. We based our
  implementation on the C program available on the Pololu website
  [@pololucode].
- Limit switches are used to detect when the end of the axis has been reached.
  These are registered on the BeagleBone black as a device tree overlay,
  meaning that communication can be done through the file system. Each switch,
  of which there can be four total, has a folder with a 'value' file in it. By
  reading from this file, as you would any other ordinary file, it is possible
  to see whether the switch is pressed or not.

With the above three points, a few problems arose.

Regarding video, although video drivers are handled on the specific platform
and are not an issue for the software, OpenCV comes with more dependencies.
Namely codecs are defined with ffmpeg, which differs across platform, and the
configuration used on the code does not necessarily match that which is
installed. Members of the teams struggled with finding a common configuration,
so the board were to be considered the lowest common denominator, making it
each team members job to remember to change the configuration if he wanted to
run the software locally.

Regarding stepper motors, a few modification had to be done. Firstly, the software is
not build for our purposes, but rather specifically for controlling a 3D
printer. This means that the 4 axes do not have the same properties, as one of
them for instance is used as an extruder.We patched the software to remove
boundary restrictions and to fix some calculations to make sure each axis moves
at the same step size. The result is that we can successfully make our own
homing functionality on each axis.

Another obstacle with the stepper motors is communicating instructions to them.
The Mendel program that came with the BeBoPr++ cape, while open source, was not entirely
transparent in its design. It is not very well documented and changing it often resulted
in fatal errors. The implications of these difficulties was that we did not succeed in
incorporating it into our own software directly. Instead we opted for having it run as-is
(with our previous mentioned modification) and write to it from the outside. Specifically,
each time we start the EvoBot software we:

1. Write an empty string to the file, creating and truncating it as needed
2. Start the Mendel software
3. Open a continuous stream reading from the socket and pipe it into the Mendel executable
4. Pass the path to the socket to the EvoBot software

This way, every time the EvoBot needs to communicate with stepper motors, all that is 
needed is to write G-code to this socket. While this approach has proven to work throughout
the project, it does seem vulnerable to IO failures and delay. A later project might look
into improving on this method.

### Communication within the core

The core is the one part of the architecture that functions entirely without the
others. This means that it still works under the assumption that no other parts
of the architecture exists, and is only contacted from the outside in. It does,
however, need to be in sync with the other parts with regards to what is exposed
for calling. As mentioned, this is done through the shared configuration file.
This configuration file dictates which hardware components exists, coupled
with a knowledge about which actions these components can perform, each
action will be given and index and uniquely refer to a method on a component
instance. This knowledge of component actions is for now only stored in the
configuration, but it should be trivial to read it from a configuration
somewhere. For now we did not want to introduce complexity and maintenance
by having a new often-changing configuration file while the system was
developed, nor would we want to store this information in the current
configuration as it would require the information to be duplicated on all
components, or changing the structure of the file.

In addition to the exposed actions, the core, of course, can also call itself. This
is seen for instance with specialized functionality, such as computer vision,
where a separate library is created and used where needed within the core. Another
example is of course just methods that are not exposed on components.

### Exposing the core to the user

As mentioned, the user facing part of the EvoBot goes through a web server.
This makes it rather trivial to make the actual user facing part, as it only
consists of static files. Exposing this client application is only a matter of
having the web server already used for communication also host the client
software's folder.

The communication between the core and the web server is less trivial. The
two parts are written in different languages, which means that a wrapper is
required to have them communicate. The wrapper for doing this works mostly
out of the box, and allows the web server to call methods and pass parameters
to the core. We did however experience problems when the communication needs rose
to be more than the most basic. Namely callbacks, which is an advertised
functionality of the wrapper, proved to not work in our software. Speculation
revolves around that the culprit is memory management in relation to the way
we use threads in the core. Regardless of the underlying cause, we did not
succeed in fixing the native callback functionality, and instead chose another
way around the issue by doing the callback through http 
using the curl library. This works, but it is likely to be slower than having
a natively supported callback.

##Summary

The Splotbot is run on a piece of Python software based on a library
specifically used for controlling a 3D printer. The transition from
Splotbot to EvoBot is very much a rewrite, resulting in a C++ application
exposed through a web server, operated with a Javascript based web
client. The core of the EvoBot consists of different component working
as an abstraction on top of the corresponding hardware components.

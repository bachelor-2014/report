
# Stand alone platform (Porting to the beagle bone)
The Splotbot robot is currently run via an Arduino microcontroller which has
been wired up to the hardware. This allows the user to connect to the Arduino
via a normal computer and control the robot using the RepRap software. This
solution allows for easy prototyping, but poses problems for a user that does
not have experience with installing and using the Arduino and RepRap software.
\cite{gutierrez2012}

The final robot is to be used by personnel with no experience with the RepRap
software and hardware, so we will investigate the possibility of making a stand
alone platform. The platform should not require the user to setup our software
on their own computer, instead they should start the machine and be able to run
experiments with little to no setup.

##Requirements
Extending the platform to be more stand alone requires a new set of requirements
to define if the platform will support the end user's needs. But first we must
look at the current setup and software to see which issues must be handled to
make the platform standalone.

<!-- Section describing the current solution, should go where? -->
The current platform works using an Arduino microcontroller and a normal
computer. An experiment is defined as a set of Gcode instructions to control the
robot, these instructions are then fed to the Printrun software which will based
on the instructions, send a signal to the Ardunio to control the hardware. The
problem with this setup arises as a user them self have to setup the software on
their own computer and make it work with the Arduino. This will potentially get
more complicated as the platform matures and more hardware and software is
added.

<!-- Beagle bone -->
For our stand alone platform we will be using the BeagleBone Black (BBB), this
small ARM based micro computer with GPIO ports will potentially be capable of
replacing both the computer and the Arduino computer in the current setup. We
have chosen to investigate the possibility of using the BBB as the main control
unit, because of its low price points and its capability of communicating with
hardware directly, we will be examining whether this approach will be feasible.
The BBB is further supported by the current evobliss specification the robot's
control system will potentially be based around the BBB
\cite[p.14]{specification}. The BBB will potentially propose issues such as
performance and hardware support it is these issues that we will be
investigating and addressing in this chapter.

<!-- End Requirements -->
To make the platform more standalone and support the users needs we
propose the following requirements to the platform. We will be using these
requirements to determine if our solution will be able to support the needs of
the evobliss platform.

* The platform must be controlled by a single computer
* The platform should not require the user to install additional software on
  their own computer
* The platform must use the BeagleBone Black micro computer.
* The platform must be able to run atleast the same hardware as the Splotbot
* The platform must be able to support the same operations as the Splotbot


##Implementation
<!-- Overall -->
The implementation can be considered in 2 different major parts, there is the
hardware and the software. The hardware consists of firstly the main control
unit which runs the software and then the physical robot. The software consists
of our own software written from scratch and third party software and libraries.
Combined the hardware and software form the Evobot, in the following section we
will first discuss the hardware setup, followed by the software setup.

### The Hardware Setup
<!-- The Beaglone bone -->
![The Beaglone Bone Black \label{fig:beaglebonepic}](images/todo.png)
At the heart of our hardware setup we have the Beagle Bone Black (BBB)
microcomputer \cite{beagleboardblackweb}, it can be seen in figure
\ref{fig:beaglebonepic}. The BBB has 512Mb of RAM, a 1Ghz ARM processor, 1 USB,
Ethernet and 2x46 pins. The board comes with an embedded Linux distribution
called Ångström. Because of it being a Linux computer, the development and
deployment of code for the board, was as easy as connecting to the board and
compiling and running the code directly on the board. The GPIO ports and the USB
can be talked to as any device connected to the Linux kernel. After having tried
using a breadboard to connect the hardware to the BBB we decided to move to a
more safe environment and introduced the BeBoPr cape to our setup.

<!-- The cape -->
![The Beaglone Bone Black on the BeBoPr cape \label{fig:beboprpic}](images/todo.png)

<!-- The physical robot, motors, frame, etc. -->
![The Evobot \label{fig:evobotpic}](images/todo.png)

### The Software Setup
Making the platform standalone, required a drastic changed in the software
used to address the robot. Supporting the BBB, we chose to go with a solution
that both allowed us to program with a more direct connection to the hardware
and at the same time making it possible to connect to the Evobot using only a
browser on the users computer. This setup required us to have 3 different
software components, the core which consists of a C++ codebase that addresses
the hardware and runs experiments, the NodeJS wrapper which handles the
communication to and from clients and the client a JavaScript based web client
that allows the user to control the robot using a simple web interface.

<!-- The core c++ -->
At the heart of our software setup there is a core of C++ code. This code is
responsible for talking to the hardware, running experiments and saving
experiment data for later analysis. The code is written as C++11 and compiled
using the GCC C++ compiler. The code runs experiments by giving it a list of
instructions that needs to be run. Instructions for the experiments are simply a
list of integers, every instruction is address by a number that are determined
from which components are initialised in the system, arguments for the
instructions are directly following the instruction in the list and are also
simply integers. Any data that are to be logged or used in the application are
emitted as events in the system. The code starts by loading up all of the
different components, after this initial setup it waits for instructions. More
can be read about the architecture of the C++ core in section \ref{modularity}.
Feature wise the C++ core implements the same features as the original robot and
allows for:

* Moving the axes using the stepper motors
* Moving the servo motors
* Camera calibration
* Image stitching a new feature discussed in chapter \ref{stitching}
* Droplet detection
* Data logging

<!-- NodeJS -->
The NodeJS part of our code base, is mostly intended to make it easier for us to
communicate with client browser. The NodeJS application is responsible for
hosting the client application, receiving data from the clients, giving
instructions to the C++ core and sending data from the C++ core to the clients.
Hosting the client application, simply makes the process of running all software
easier, as generally it just requires the node application to be started for
client to be able to connect. Data received from the client are simply HTTP Post
requests containing a JSON list of instructions that can be converted and added
to the C++ instructions list, thereby making it possible for a client to send
and get the code to an experiment run. Sending data from the C++ application are
done continuous using web sockets, any event made in the C++ core are sent to
the client, this includes camera images, droplet speed etc. To make the
communication between the NodeJS and the C++ efficient and seamless, we have
wrapper the C++ application as a NodeJS module, with a bit of V8 addressing C++
code we can call a C++ function and parse arguments allowing us to take a
JavaScript integer list and add it to the instruction buffer.

<!-- Client -->
The web client is written as a single page application and is written in
JavaScript. The web client allows the user to both monitor and work with the
robot, having different GUI components for each physical component for easy
testing. The client takes translates any user interaction into integers codes
and directly sends them to the NodeJS for execution. Compared to the original
solution our custom client gives the user more capabilities of directly
manipulating the robot.

<!-- Third party software used -->
Our Software also consists of a few third party libraries and software. The C++
code have the following dependencies:

* OpenCV, this is used to support all of the different computer vision parts and
  communication with the camera. //TODO With what dependencies have we compiled
  OpenCV
* CVBlob, and extension library for OpenCV that makes it easier to do blob
  detection, we specifically use the for droplet detection. 
* The BeBoPr software created as a program for interpreting G code for 3D
  printing. We use this application to communicate with the stepper motors. 
* cJSON a c library for reading JSON files. Our software uses this to read our
  configuration file.
* Base64 encode and decode from
  [http://www.cplusplus.com/forum/beginner/51572/#msg280295](http://www.cplusplus.com/forum/beginner/51572/#msg280295)
* Curl, we use Curl to send HTTP requests from our C++ code. Specifically we
  use it to emit events to NodeJS which further emits them to the connected
  clients.

Our NodeJS application uses the following libraries:

* node-gyp, this tool allows us to build our NodeJS C++ module.
* Socket.io, websocket library used send data to and receive data from the
  client.
* Express, used to receive HTTP requests and host the client folder.

Our client application also uses some front end JavaScript libraries:

* AngularJS, framework for building single page JavaScript applications with
  features such as tempesting and data binding.
* Bootstrap, design framework to make our client not look like the run of the
  mill researchers homepage.

##Discussion

### Performance Issues
While developing the platform we experience the full capabilities of the BBB and
we are not that confident of the platforms performance. A glaring issue with our
platform is the fact that the BBB is single core, while we don't need amazing
performance for most tasks the single core often results in context switches on
the board making the entire process hold for up to multiple seconds.
Unfortunately the result is an experience where the robot often performs
multiple actions but then suddenly halts mid some action, where everything
including the web cam feed and data logging is halted and will first continue
when the OS switches back to our process.

General performance wise heavy calculation actions such as droplet detection
will be noticeable slow and often results in a very low frame rate produced by
the camera when active. The automatic image stitching using feature points also
is noticeably slow, where an image stitching on a normal laptop will take 1
second on the board it will take 1-1.5 minute. We think again that the
performance issues stems from both the low CPU power but also the lack of
multiple cores that the calculation could be spread on to.

An other issues that we faced with performance is compilation times, as these in
normal use would not be relevant it is not a big issue, but that being said we
experience that a full compilation of OpenCV took 8 hours on the board compared
to the 20 minutes on a laptop computer.

//TODO: Some recorded numbers and a discussion of those

In the specification for the future Evobot \ref{specification} the BBB is
expected to be the main board, while also introducing more features such as
interfacing with OCT scanners, while some solution might be possible the
performance of the BBB might end op being a problem for the final version of the
Evobot and we can hardly recommend it if the platform have the perform decently.
That being said the BBB is a cheap and nice solution for a hackable board that
allows for easy prototyping, it can still be part of the solution but the
majority of heavy calculation is better suited elsewhere.

### Platform difficulties
For us the combination of the BBB and the BeBoPr proposed a few problems as a
platform for development, while these issues have been manageable they might
become a bigger issue as the platform have to support more hardware and
features. 

Developing natively for an ARM based CPU rather than the usual x86 proposed some
difficulties and we found a few noticeable difference that only workarounds and
patches could solve. The following is a description with solution of each of the
major issues encountered:

* The C++11 standard introduced more functional concepts such as lambda
  expressions, with these the standard also introduced a new threading library
  running a lambda expression in a new thread. However this new threading
  library does not work at all, to work around this we introduced a wrapper of
  the old POSIX pthread C library that takes a lambda expression and spawns it
  in the new thread.
* To detect blobs we are using an extension library for OpenCV called CVBlob.
  While this library works perfectly well on an x86, it contains an infinite
  loop when compiled for the ARM CPU. This is due to the underlying differences
  between char on ARM and char on x86. The fix itself is rather trivial of
  changing the char to an unsigned char on the ARM version. A description of the
  fix we applying can be found here:
  [https://code.google.com/p/cvblob/issues/detail?id=23](https://code.google.com/p/cvblob/issues/detail?id=23)

When connecting hardware to the BBB we use the BeBoPr cape that is designed to
handle hardware for 3D printing. Most of the hardware can be addressed as usual,
through standard GPIOs on Linux. However the stepper motors only seem to be
accessible through the PRU micro-controllers, so to ease the access we chose to
communicate with the BeBoPr software. This proposed some specific challenges as
the software is designed for 3D printing, this made some of the stepper motors
act differently, it introduced boundry checking and therefor a new for homing in
however not all motors are designed to be home able in the software. So to fixes
these issues we chose to patch the BeBoPr software, removing boundary checks and
making all the motors act similar. With these changes we can handle homing in
our own application, while the process is slower in our solution it is capable
of performing the homing on all axes. The patched code can be found in our code
repository

<!-- Discussion of the platform -->

### Alternative solutions and improvements
<!-- Improvements -->
<!-- Return to Arduino -->
<!-- More BBBs? -->

<!-- Alternative -->
<!-- Cheap Computer -->
<!-- Other boards -->

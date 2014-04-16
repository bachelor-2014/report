
# Stand alone platform (Porting to the beagle bone)
The Splotbot robot is currently run via an Arduino microcontroller which has
been wired up to the hardware. This allows the user to connect to the Arduino
via a normal computer and control the robot using the RepRap software. This
solution allows for easy prototyping, but poses problems for a user that does
not have experience with installing and using the RepRap software.
\cite{gutierrez2012}

The final robot is to be used by personnel with no experience
with the RepRap software and hardware, so we will investigate the possibility of
making a stand alone platform. The should not require the user to setup our
software on their own computer, instead they should start the machine and be
able to run experiments with little to no setup.

##Requirements
Extending the platform to be more stand alone requires a new set of requirements
to define if the platform will support the end user's needs. But first we must
look at the current setup and software to see which issues must be handled to
really make the platform standalone.

<!-- Section describing the current solution, should go where? -->
The current platform works using an Arduino microcontroller and a
normal computer. An experiment is defined as a set of Gcode instructions to
control the robot, these instructions are then fed to the Printrun software
which will based on the instructions, send a signal to the Ardunio to control
the hardware. The problem with this setup arises as a user them self have to
setup the software on their own computer and make it work with the Arduino. This
will potentially get more complicated as the platform matures and more
hardware and software is added.

<!-- Beagle bone -->
For our stand alone platform we will be using the BeagleBone Black (BBB), this
small ARM based micro computer with GPIO ports will potentially be capable of
replacing both the computer and the Arduino computer in the current setup. We
have chosen to investigate the possibility of using the BBB as the main control
unit, because of it low price points and it capability of communicating with
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
* The platform must be able to run atleast the same hardware as the current
  Splotbot


##Implementation
Our implementation consists of a BeagleBone Black, hooked up to a Replicape
\cite{replicape} that are then connected with our hardware. On the BeableBone we
have our own custom software, that controls the everything. Further our software
relies on multiple external software and libraries that need to be setup
correctly for the software to function.
<!-- The ported and improved software -->
<!-- Third party software used -->
<!-- The Beagle Bone Hardware (cape etc.) -->

##Discussion
<!-- Performance Issues -->
<!-- Platform difficulties -->
<!-- Future Issues -->
<!-- Alternatives -->

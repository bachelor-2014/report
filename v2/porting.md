
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
Extending the platform to be more stand alone requires a new set of requirements to
define how this platform should be usable by the end user. But first we must
look at the current setup and software to see which issues must be handled to
really make the platform standalone.

<!-- Section describing the current solution, should go where? -->
The current platform works using an Arduino microcontroller and a
normal computer. An experiment is defined as a set of Gcode instructions to
control the robot, these instructions are then fed to the Printrun software
which will based on the instructions, send a signal to the Ardunio to control
the hardware. The problem with this setup arises as a user them self have to
setup the software on their own computer and make it work with the Arduino. This
will potentially create further complications as the platform matures and more
hardware and software is available, making the setup process potentially more
complicated.

To really make the platform more standalone we propose the following added
requirements to the hardware and software of the platform

* The platform must be controlled by a single computer
* The platform should not require the user to install additional software on
  their own computer

##Implementation
In the current specification for the
robot a potential control system will be based around a BeagleBone Black (BBB)
micro computer \cite[p.14]{specification}. With this in mind we have chosen to
investigate this particular board as our main control unit, it will run the
software and interact with the hardware.

##Discussion

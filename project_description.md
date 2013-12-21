# Project description: 'Title'

## Background and motivation

This bachelor project resides within the scope of the EVOBLISS project that
seeks to develop a robotic platform for supporting research on artificial,
technological evolution with the goal of evolving microbial fuels cells in terms
of robustness, longevity, or adaptability in order to improve wastewater
cleanup. The robotic platform is based on an open source 3D printer with
extended functionality for handling liquids and reaction vessels. The robot
focuses on real time reaction based on feedback from a series of sensors. The
main motivation for the EVOBLISS project is enhancing the understanding of
living technologies and to gain an insight in design of bio-hybrid systems.

This bachelor project is based on an existing liquid handling robot as described
above. This robot is similar to a 3D printer, but with the printer head being
replace by a syringe for handling liquid. Furthermore, it is extended with a
gripper for manipulating petri dished. The devices are controlled by an Arduino
unit, and the robot is controlled using software installed on a personal
computer connected to the Arduino.

The first part of the bachelor project focuses on modifying the setup by
removing the Arduino and the personal computer, replacing them with a
BeagleBoard. The board is to interact directly with the hardware of the robot
while also fulfilling the role of the personal computer running the software,
providing a high level user interface for interacting with the robot. The
motivation for this is the hope that making the robot a stand alone unit will
remove sources of error when using the robot, making it easier to use for people
with no IT background; users will not need to install any software on their own
computers, making it more accessible, and making it less likely that the
heterogeneity of computers introduce usage difficulties.

The second part of this bachelor project focuses on the use of camera as sensors
through the use of image analysis and manipulation. Having a stationary camera
as part of the robot has proven to not be sufficient, as the area to be scanned
of exceeds that which the camera can cover in a single image. We will therefore
attempt to create a setup, where the syringe is replaces by a camera, and where
large areas can be scanned by taking multiple images by the camera and combining
them. This also covers investigating the difficulties introduces by having a
moving camera such as the motion blur introduced by both the camera movement and
the rotations in the robot course by the motors. This second part is motivated
by an identified need of such a system, but where the sensor used is not
necessarily an ordinary camera but a similar device. The motivation is therefore
that a to some extend generic solution of the setup can be created, where the
camera can be replaced by another device such as a microscope or an OCT scanner
head for more wide applicability.


## Scope of the project

* Setup of operating system and application environment on Beagle board 
* Interaction with camera (sensor) through the use of OpenCV
* Write drivers for the different hardware parts of the platform
  (motors, sensors)
* Interface to motor operation for basic operations
* Create an easy-to-use API for the above. Wrapped in a library for easy
  installation
* Use a camera to scan large areas

## Time plan
//TODO



# Old draft
Recently EU has granted €2.8 million to a project for advancement of
artificial life. The project consists of several parts, one of which is located
at the IT University of Copenhagen. This is the context in which our bachelor
project takes place.

Our bachelor project will focus on a hardware platform being developed as part
of the project; a construction consisting of small electric motors and different
sensors capable of moving petri dishes and mixing liquids in these, using the
sensors to record the results of mixing the liquids in real time. The platform
will be refered to as Evolutionary Robotic Platform (ERP).

With our project we wish to achieve some or all the below
points

* Setup of operating system and application environment on Beagle board 
* Interaction with camera (sensor) through the use of OpenCV
* Write drivers for the different hardware parts of the platform
  (motors, sensors)
* Interface to motor operation for basic operations
* Create an easy-to-use API for the above. Wrapped in a library for easy
  installation
* (optionally) Create a domain specific language (DSL) on top of the above API

The largest part of the project will focus on the use of OpenCV to extract
relevant information from the images captured with the camera attached.

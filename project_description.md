# Project description: 'Stand-alone Evolutionary Robotic Platform'

## Background and motivation

This bachelor project resides within the scope of the EVOBLISS project that
seeks to develop a robotic platform for supporting research on artificial,
technological evolution with the goal of evolving microbial fuels cells in
terms of robustness, longevity, or adaptability in order to improve wastewater
cleanup. The robotic platform is based on an open source 3D printer with
extended functionality for handling liquids and reaction vessels. Focus is on
real time reaction based on feedback from a series of sensors. The main
motivation for the EVOBLISS project is enhancing the understanding of living
technologies and to gain an insight in the design of bio-hybrid systems.

This bachelor project is based on the existing liquid handling robot as
described above. This robot is similar to a 3D printer, but with the printer
head being replaced with a syringe for handling liquid. Furthermore, it is
extended with a gripper for manipulating petri dishes. The hardware is
controlled by an Arduino unit, and the robotic platform as a whole is
controlled using software installed on a personal computer connected to the
Arduino.

The first part of the bachelor project focuses on modifying the setup by
removing the Arduino and the personal computer, replacing them with a
BeagleBoard. The BeagleBoard is to interact directly with the hardware of the
robotic platform while also fulfilling the role of the personal computer
running the software, providing a high level user interface for interacting
with the robot. The motivation for this is the hope that making the robot a
stand alone unit will remove sources of error when using the robot, making it
easier to use for people with no IT background; users will not need to install
any software on their own computers, making it more accessible, and making it
less likely that the heterogeneity of computers introduce usage difficulties.

The second part of this bachelor project focuses on the use of a camera as as
sensor through the use of image analysis and manipulation. Having a stationary
camera as part of the robot has proven to not be sufficient, as the area to be
scanned often exceeds the area that can be covered in a single image. We will
therefore attempt to create a setup, where the syringe is replaced with a
camera, and where large areas can be scanned by taking multiple images with the
same camera and stitching them together. This also covers investigating the
difficulties introduced by having a moving camera such as the motion blur
introduced by both the camera movement and the vibrations in the robot caused
by the motors. This second part is motivated by an actual case where such a
platform is needed, but where the sensor used is not necessarily an ordinary
camera but a similar device. The hope is therefore that a to some extend
generic solution of the setup can be created, where the camera can be replaced
by another similar device such as a microscope or an OCT scanner head for wider
applicability.


## Scope of the project
The project consists of two parts: (1) Replacing the existing Arduino unit and
software with a BeagleBoard, and (2) creating a setup with a movable camera for
scanning large areas through use of image stitching. The following elaborates
on these parts:

### 1. Replacing the existing Arduino unit and software with a BeagleBoard

- Setup the operating system and application environment on the BeagleBoard. The
  board will be running a Linux distribution.
- Find/write drivers for the different hardware of the platform such as motors,
  camera, and other sensors. For the stepper motors, hardware drivers will be
  used for simplifying this task. Existing drivers will be used as far as this
  is possible.
- Interface with hardware from within the software running on the BeagleBoard.
  This includes low-level control of the stepper motors and the retrieval of
  data for the different sensors.
- Create an easy-to-use API on top of the hardware interfaces. This serves to
  simplify further interaction with the hardware. It will be based on our own
  estimations of requirements for such an API rather than actual requirements
  specification due to time limitations.

### 2. Creating a setup with a movable camera for scanning large areas through use of image stitching

- Create the actual hardware setup. It must support moving the camera along at
  least two axes.
- Implement image stitching. This will make use of existing implementations as
  far as possible.
- Experiment with moving the camera in order to find the method giving the best
  results. Examples of different methods are taking the images while moving the
  camera (without stopping) and taking the images while holding the camera
  still, moving it between taking the images (stopping between images).
- Create and easy-to-use API for interaction with the camera based scanner. As
  with the API on top of the hardware interfaces, this will be based on our own
  requirements estimations.


## Time plan
//TODO

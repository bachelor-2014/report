# Introduction
\label{sec:introduction}

## Background and motivation

The Evobot project resides within the scope of the EVOBLISS project
that seeks to develop a robotic platform for supporting research on
artificial, technological evolution with the goal of evolving microbial
fuels cells in terms of robustness, longevity, or adaptability in order
to improve wastewater cleanup. The main motivation for the EVOBLISS project is
enhancing the understanding of living technologies and to gain an
insight in the design of bio-hybrid systems.

The specific need for a robotic platform stems from a desire to achieve
efficiency when running experiments. Other wishes that directly impacts
this report in particular is an expressed wish for modularity and an
expressed wish for advanced feedback and autonomous features from the system.

## Scope of the project

This project is a product of past research, see \ref{sec:introduction_past_projects}. 
Even with this amount of past work to build on, the EVOBLISS project in its entirety is
all too large for inclusion in a single bachelor thesis. For the remainder of
this report we will refer to "the project" as being the work carried out in this
bachelor thesis. This projects seeks to be an investigative design
project with a proposed design in mind from the beginning. The two overall goals:

1. The feasibility of our proposed design
2. Feasibility of specific additions to the existing functionality

To assess both of these goals the same method will be used: Implementing the
design and assess the success of the implementation.

## End result

The following will be delivered at the end of the project:

- A report containing:
	- An investigative review of and conclusion on whether or not the
	proposed design is feasible
	- A thorough review of the findings and choices made over the course of
	the project
	- A proposal for an alternative design, if applicable
- A functional prototype, demonstrating the implemented design

The common goal of the above is to objectively inform people building upon the
work for the remainder of the EVOBLISS project about design choices made and
hopefully provide guidance useful in future iterations.

## Past projects
\label{sec:introduction_past_projects} This project is based on a previous
robotic platform named Splotbot. It was originally developed as a master's
thesis by Juan Manuel Parrilla Gutiérrez for his Master in Robotics at the
University of Southern Denmark, which was handed in in June 2012
[@gutierrez2012]. It was then improved in a project by Arwen Nicholson,
also at the University of Southern Denmark, working on stability in runner
further experiments on the robot, which was handed in in June 2013
[@nicholson2013].

Splotbot was based on a RepRap Prusa Mendel 3D printer, and open source 3D
printer focusing on the possibility of self-replication. This printer has five
stepper motors for moving along three axes as well for extruding plastic.
[@gutierrez2012, pp. 15-31]. For Splotbot, much of the hardware was reused, but
the frame was entirely new. It allowed movement along two axes, X and Y, and six
syringes had to be controlled, resulting in the need for twelve RC servo motors,
which were added. It was controlled through an Arduino Mega 2560 [@arduino_mega_2560]
board, which was connected to a personal computer through USB. The user of the
robot had to sent G-code [@gcode] instructions to the robot, which were sent by
use of the Printrun [@printrun] application made to control 3D printers. Only a
small subset of the G-code instructions were used [@gutierrez2012, pp. 33-48].

![A picture of Splotbot on which EvoBot is based.\label{fig:splotbot}](images/todo.png)

The functionality of Splotbot can be summarized in the following points.
Splotbot was capable of [@gutierrez2012, pp. 125-127]:

- moving a carriage with 6 syringes along two axes
- controlling each syringe, moving it up and down and pick up and drop liquids
- moving petri dishes around using a grip attached to the moving carriage
- obtaining live images from a stationary camera on which camera calibration is
  done (the camera calibration is done manually //TODO make sure this is
  correct)
- applying image processing techniques to detect droplets (single and multiple)
  and compute their centers and sizes. All the processing was done on the
  computer connected to Splotbot 
- reacting on the result of the image processing in real-time, modifying the
  experiment accordingly if necessary

With the improvements made by Arwen, Splotbot was capable of running
experiments making use of this for up to two hours without human interventions
[@nicholson2013, p. 26].

##Description of the prototype
\label{sec:introduction_description_of_the_prototype}
The prototype created for this project is meant as a combination of a
demonstration of new features of the robot and a feasibility study of an
implementation of the same features support by the past projects. Some parts
will therefor be more elaborate or completely new compared, while others will
not be as complete as earlier. The prototype consist of a new hardware setup and
a new rewritten software platform both rebuild from scratch but building upon
and to some part extending what was previously made in past projects. Following
is a description of the prototype's hardware and software.

###Prototype Hardware
TODO: picture.
The prototype is designed to be modular to allow for changing hardware
components dynamically, how we archived this is further discusses in chapter
\ref{sec:modularity}. Below is a description of the most important part of our
hardware setup. Some parts of our construction is 3D printed, the drawings are
available in our Github repository
[https://github.com/bachelor-2014/hardware](https://github.com/bachelor-2014/hardware)

- The prototype consists of two carriages, one above the plexiglass plate and
  one below. The top carriages similar to the Splotbot is to be used for mount
  syringes etc. The carriage below is mounted with a camera that allows it to
  move around and observe the petri dish(es) from below. 
- The frame of the prototype is made of aluminium rails similar to the Splotbot,
  however to increase stability the prototype uses larger rails than previously.
  The frame have also increased in this, this is mostly to accommodate for the
  larger rails, but also to allow for the additional camera carriage at the
  bottom.
- The prototype is now controlled using a Beagle Bone Black (BBB) micro
  computer. The BBB is setup to run our software and is connected to the
  rest of the hardware setup. The BBB allows us to create a more stand alone
  platform this is further elaborated in chapter \ref{sec:standalone}. 
- The BBB connects to the hardware through the BeBoPr cape, which allows for
  safe and easy connection of GPIO hardware. The BeBoPr however had some
  limitations on the possibilities towards additional hardware which adds some
  constraints to the modularity this is further discussed in chapter
  \ref{sec:modularity}
- We never got around to implementing the syringe modules in our prototype, we
  have however connected servo motors to our setup using the Polulo RC Servo
  controller and have showed they are controllable from our software, making it
  feasible to add them. The feasibility of completely reimplementing the
  Splotbot using our hardware setup and more standalone BBB based platform is
  discussed in chapter \ref{sec:standalone}

###Prototype Software
The software written for our prototype is structured in three main components,
the core, the NodeJS server code and the client. The core handles the robot
features, the NodeJS acts as a bridge between the core and the client and the
client allows the user to manipulate the robot real-time and via sending
experiment code. Below is a description of the most important features of our
software. The code for our implementation is available in our Github repository
[https://github.com/bachelor-2014/code](https://github.com/bachelor-2014/code)

- The core of the software is written in C++ and is responsible for executing
  experiments, communicating with the hardware, logging data, emitting events
  and in general it is the most extensive part of our code base with the main
  responsibility for handling the platform. The software consists of a module
  based system where modules can be loaded and runtime based on settings in a
  configuration file, this allows for modularity in our design, further explain
  in chapter \ref{sec:modularity}. 
- The core is not in itself coded to do experiments, rather it is structured
  around an instruction buffer that takes interger instructions and performs
  actions based on those instructions. The instructions can either be fed
  directly or be compile from our own experiment programming language called
  Rucolang. A core concept in our design is the event based model, where events
  are thrown and can be handled in Rucolang and the client. To read more about
  the instruction buffer design, the event based model and programmer ability of
  the prototype see chapter \ref{sec:programmability} //TODO: Rewrite thing
  about Rucolang if it does not happen. 
- An important part of our extended design in the prototype compared to the
  Splotbot is our computer vision utilities. Our library of components includes
  a component for pulling data from the camera including droplet detection, for
  an elaboration on this see chapter \ref{sec:computervision}.  With the
  extended possibility of moving the camera we have also added a component for
  taking multiple images and stitching them together allowing the user to get a
  complete overview, an elaboration on the image stitching can be found in
  chapter \ref{sec:stitching}
- The client consist of a JavaScript based web client, that communicates with
  the server through web sockets and http requests. The client similar to the
  server loads the configuration file and constructs the GUI based on the
  available components, further explanation of the modularity can be found in
  chapter \ref{sec:modularity}. 
- The client in itself allows the user to interact with each module with a GUI
  element specifically designed for it, the GUI element simply sends instruction
  integer code to the core. The GUI also allows the user to program an
  experiment either as instruction integer code directly or as Rucolang code,
  the user interaction is further elobrated in chapter \ref{sec:human}

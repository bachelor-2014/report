# Introduction
\label{sec:introduction}

## Background and motivation

Forefront of research
Investigation brought on by EU
Need for automation and efficiency

Expressed wish for modularity
Expressed wish for vision functionality

## Scope of the project

This project is a product of past research, see \ref{sec:introduction_past_projects}. 
Building on this past knowledge this projects seeks to be an investigative design
project aiming for two overall goals:

1. The feasibility of our proposed design
2. Feasibility of specific additions to the existing functionality

The feasibility will be measured by implementing the design and assess the success
of the implementation.


## End result

- An investigative report concluding whether or not the proposed design
is feasible accompanied by a functional prototype of the design.
- A proposal of an alternative design, if applicable
- A thorough review of the findings over the course of the project, aiming
to objectively inform people carrying on the project about design choices and 
whether they are good or bad.

## Past projects
\label{sec:introduction_past_projects}
This project is based on a previous robotic platform named Splotbot. It was
originally developed as a master's thesis by Juan Manuel Parrilla Gutiérrez for
his Master in Robotics at the University of Southern Denmark, which was handed
in in June 2012 [@gutierrez2012]. It was then improved in a project by Arwen
Nicholson, working on stability in runner further experiments on the robot,
which was handed in in June 2013 [@nicholson2013].

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

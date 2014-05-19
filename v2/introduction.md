# Introduction
\label{sec:introduction}
This bachelor project resides within the scope of the EVOBLISS project
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
This project is the continuation of past research, see section
\ref{sec:introduction_past_projects}. For the remainder of this report we
will refer to 'the project' as being the work carried out in this bachelor
project.

This projects seeks to be an investigative design project with a proposed
design in mind from the beginning. The two overall goals:

1. Assessment of the feasibility of our proposed design
2. Assessment of feasibility of specific additions to the existing functionality

To assess both of these goals the same method will be used, which is implementing the
design and assessing the success of the implementation. It is worth noting that
this approach has the consequence that none of the topics covered are
investigated completely in-depth.

## End result
The following will be delivered at the end of the project:

- A report containing:
	- An investigative review of and conclusion on whether or not the
	proposed design is feasible
	- A thorough review of the findings and choices made over the course of
	the project
	- A proposal for alternative design options where applicable
- A functional prototype demonstrating the implemented design

The common goal of the above is to objectively inform people building upon the
work for the remainder of the EVOBLISS project about design choices made and
hopefully provide guidance useful in future iterations of building the robotic
platform.

## Past projects
\label{sec:introduction_past_projects}
The work of this project is based on a previous robotic platform named Splotbot. It
was originally developed as a master's thesis by Juan Manuel Parrilla Gutiérrez
for his Master in Robotics at the University of Southern Denmark
[@gutierrez2012]. It was then improved in a project by Arwen Nicholson, also
at the University of Southern Denmark, working on stability and running
further experiments on the robot [@nicholson2013].

Splotbot is based on a RepRap Prusa Mendel 3D printer, an open source 3D
printer focusing on the possibility of self-replication. This printer has five
stepper motors for moving along three axes as well for extruding plastic
[@gutierrez2012, pp. 15-31]. For Splotbot, much of the hardware design was
reused, but the frame was entirely new. It allows movement along two axes, X
and Y. Six syringes had to be controlled, resulting in the need for twelve RC
servo motors, which were added. It is controlled through an Arduino Mega 2560
[@arduino_mega_2560] board, which is connected to a personal computer through
USB. The user has to write Python code and use a Splotbot Python library to
interact with the robot. The Splotbot library controls the robot by sending
G-code [@gcode] instructions to the Printrun [@printrun] application made to
control 3D printers. Only a small subset of the available G-code instructions
are used [@gutierrez2012, pp. 33-48].

The functionality of Splotbot can be summarized in the following points.
Splotbot is capable of [@gutierrez2012, pp. 125-127]:

- moving a carriage with 6 syringes along two axes
- controlling each syringe, moving it up and down as well as taking in and
  expelling liquids
- moving petri dishes around using a grip attached to the moving carriage
- obtaining live images from a stationary camera on which camera calibration is
  done manually.
- applying image processing techniques to detect droplets (single and multiple)
  and compute their centers and sizes. All the processing is done on the
  computer connected to Splotbot 
- reacting on the result of the image processing in real time, modifying the
  experiment accordingly if necessary

With the improvements made by Arwen Nicholson, Splotbot is capable of running
experiments for up to two hours without human intervention [@nicholson2013, p.
26].

##Acknowledgements
Several people have aided us during the course of the project, the help from
whom we are thankful:

- Lars Yndal has aided us in both finding out what hardware to buy in order to
    construct the EvoBot as well as in buying it
- Cathrine Siri Zebbelin Gyrn has helped us finding a suitable Plexiglas plate
    for the robot, and by allowing us to use workshop of the IxD Lab at the IT
    University of Copenhagen to work on the hardware construction
- Andrés Faína Rodríguez-Vila and Farzad Nejatimoharrami have helped by answering
    our hardware related technical questions as well as by ordering hardware parts

##Contents of the report
\label{sec:introduction_description_of_the_prototype}
The prototype created in this project, from here on named EvoBot, is meant as a
combination of a demonstration of new features and a feasibility study of an
implementation of the same features supported by the past projects on new
hardware. Some of the existing features are therefore not as complete on EvoBot
as they were on previous prototypes, as focus of the project is quite broad.
EvoBot consist of a new hardware setup and a new rewritten software platform.
Both are rebuilt from scratch, though based on what was made in past projects.

Each chapter of this report covers a topic of its own:

- **Chapter \ref{sec:hardware}** explains how the physical robotic platform was
    constructed
- **Chapter \ref{sec:software}** covers the software built in order to control
    the robot and support the wanted functionality
- **Chapter \ref{sec:calibration}** focuses entirely on the camera of the robot
    and how it is calibrated to get rid of radial distortion and to relate the
    pixels of images grabbed with physical movement in the robot
- **Chapter \ref{sec:tracking}** looks at how we use the camera to monitor
    experiments and gather data through tracking of colored droplets
- **Chapter \ref{sec:scanning}** focuses on the camera as well, but investigates 
    the problem of having to monitor experiments which cover a larger surface
    area than can be covered by a single image by grabbing multiple images and
    stitching them together
- **Chapter \ref{sec:experiment_interaction}** looks at the problem of making
    EvoBot capable of interacting with running experiments without human
    interaction by giving the user a way to program entire experiments
- **Chapter \ref{sec:logging}** discusses the problem of what to do with the
    data generated by the experiments
- **Chapter \ref{sec:human_interaction}** is about providing an interface
    through which the user can interact with EvoBot
- **Chapter \ref{sec:conclusion}** concludes on the results of the project

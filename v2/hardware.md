# Constructing the physical robot
\label{sec:hardware}
This chapter focuses on building the physical part of EvoBot (the hardware). We
start by briefly outlining the hardware of Splotbot, as EvoBot is very
much based on this construction. We then move on to explain the modifications
made from Splotbot to EvoBot, resulting in a description of the EvoBot setup
along with an explanation of the reasoning behind the design.

## The hardware of Splotbot
The basis of Splotbot is the metal frame. It is 25cm tall, 55cm long, and
35cm wide. In the center of the frame is a 3mm glass plate attached, on which
experiments are run. An overview of the robot is given in figure
\ref{fig:splotbot_overview}. The moving part of the robot is a top carriage
which can move along two axes. This carriage is driven by belts. In
order to move along the x axis, 3D printed pieces of hardware are
mounted near the top corners of the frame. These hold an 8mm linear
rail between them. On one side of the robot these pieces
hold stepper motors with a pulley, while the other side have pulleys on ball
bearings, allowing for driving a belt between them. This belt is then attached
to another 3D printed piece running on ball bearings on the linear rails.

In order to move along the y axis, a stepper motor is attached to one
of these pieces with the previously mentioned belt attached. A similar
construction allows for driving a belt along the y axis. Two 8mm
linear rails (one above the other) are held along the y axis on which
the movable carriage is mounted on ball bearings. This carriage has
six syringes mounted on it, each controlled by two RC servo motors.

Splotbot has a camera to monitor experiments. This camera is fixed to the bottom
of the robot as shown in figure \ref{fig:splotbot_camera}.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/splotbot_overview}
        \caption{Overview of Splotbot}
        \label{fig:splotbot_overview}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/splotbot_camera}
        \caption{The fixed camera of Splotbot}
        \label{fig:splotbot_camera}
    \end{subfigure}

    \caption{Images of Splotbot. Image (a) is from the thesis by Gutiérrez (2012). Image (b) is from the report by Nicholson (2013).}
    \label{fig:splotbot}
\end{figure}

Finally, Splotbot is controlled by an Arduino Mega 2560
[@arduino_mega_2560]. Instructions are sent from a personal computer connected
via USB.

## From Splotbot to EvoBot
There are several places where we found that the hardware of Splotbot was not
sufficient for what we wished to achieve with EvoBot:

- The frame was a bit shaky when running, so we wanted the frame to be more
    robust
- We needed the camera to be able to move along two axes similar to the top
    carriage, so we wanted to replicate the top carriage design in the bottom
    part of the robot
- In order to make room for a bottom carriage, and also to preserve the
    possibility of exchanging the camera with larger cameras or scanners, we
    wanted more space below the glass plate
- The carriage is very shaky due to the rails on which it is attached
    being placed only with a vertical distance between them, so we wanted to
    alter this to be a horizontal distance only
- In order to make EvoBot a standalone unit, we wanted to exchange the
    Arduino board with a more general purpose computer

The design with linear rails, belts, and stepper motors was proven to work on
Splotbot, and given the limited scope of the project and us having hardly any
knowledge about hardware, we decided not to spend time on trying to improve on
it.

Finally, due to the limitations in available time we decided not to spend time
on constructing syringe parts, though they are crucial to the functionality of
the final iteration of EvoBot. We do, however, include controlling RC servo
motors, so adding syringes similar to those on Splotbot should be possible to
accomplish in a later iteration. We also did not work on building a gripper arm
as the one on Splotbot, as this is currently being done in a separate project.

The following sections explain how we designed and built the hardware of EvoBot
to suit our needs.

## Making the frame
EvoBot has an aluminum frame similar to that of Splotbot. But the width of the
frame is increased, making it a lot more sturdy. Furthermore, the dimensions of the
frame have been increased to a height of 66.3cm, a length of 46.8cm, and a width
of 76cm.

Initially, EvoBot was constructed to be 66.3cm tall, 106cm long, and 76cm wide.
This was mainly due to us having help (very much appreciated) with buying the
hardware from a fellow student of ours, Lars Yndal, who in parallel with us were
building a version of EvoBot. His project needed a larger robot than ours,
and he was quick to finding the hardware he needed to build it. As we at that
point had no exact requirements or ideas as to what hardware we needed, we
agreed that it would be a good idea to follow his lead and pool our purchases
with his. This proved a successful strategy, as some parts had long delivery
times and/or a limited selection of suppliers.  However, as the work moved
along, we found that the dimensions were too big for our needs, resulting in us
only using about half of the length of the robot, as can be seen on the image of
EvoBot in figure \ref{fig:evobot}. We suggest that the frame is cut in half,
removing the unused part. We omitted the cutting due to time constraints.

\begin{figure}
    \centering
    \includegraphics[width=0.9\textwidth]{images/evobot_overview}
    \caption{EvoBot.}
    \label{fig:evobot}
\end{figure}

As on Splotbot, a transparent plate is attached to the frame on which the
experiments are run. On EvoBot, this is a 10mm Plexiglas plate.

As the frame dimensions were altered, the 3D printed parts of the robot had to
be redesigned to fit the change. This is covered in the next section.

## Designing and 3D printing the parts
EvoBot contains 5 unique 3D printed parts, all depicted in figure
\ref{fig:evobot_parts}:

- An x axis holder with a stepper motor (\ref{fig:evobot_parts_x_motor}, 4 pcs.)
- An x axis holder without a stepper motor but with a pulley instead
  (\ref{fig:evobot_parts_x_no_motor}, 4 pcs.)
- A y axis holder with a stepper motor (\ref{fig:evobot_parts_y_motor}, 2 pcs.)
- A y axis holder without a stepper motor but with a pulley instead (\ref{fig:evobot_parts_y_no_motor}, 2 pcs.)
- A carriage (\ref{fig:evobot_parts_carriage}, 2 pcs.)

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_x_axis_with_motor}
        \caption{X axis holder with motor}
        \label{fig:evobot_parts_x_motor}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_x_axis_without_motor}
        \caption{X axis holder without motor}
        \label{fig:evobot_parts_x_no_motor}
    \end{subfigure}
    
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_y_axis_with_motor}
        \caption{Y axis holder with motor}
        \label{fig:evobot_parts_y_motor}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_y_axis_without_motor}
        \caption{Y axis holder without motor}
        \label{fig:evobot_parts_y_no_motor}
    \end{subfigure}
    
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_carriage}
        \caption{Carriage}
        \label{fig:evobot_parts_carriage}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_camera_component}
        \caption{Camera component}
        \label{fig:evobot_parts_camera}
    \end{subfigure}

    \caption{The 3D printed parts of EvoBot.}
    \label{fig:evobot_parts}
\end{figure}

Each of the parts were designed and printed by us. As a disclaimer, none of us
has previously made such a 3D design. Once a part was printed, we always ended
up spending time sawing and drilling it to fit the robot. This was due to both
imprecision in the print and due to the designs being less than perfect. As the
printing of a part takes a long time (usually several hours), having many
iterations of designing and printing the parts seemed quite time consuming. We
therefore often deemed a print as being 'close enough' and then used tools to
alter it slightly.

The x axis holders are very much inspired by the ones on Splotbot, but with
modifications to make them fit the larger frame. They have also been increased
slightly in size, making them more thick and making sure they are fastened to
two sides of the frame rather than one.

The y axis holders are also similar to those on Splotbot, but with their width
increased so they run on two ball bearings rather than one, increasing the
stability between the two holders when moving along the x axis. Also, the holes
for the linear rails have been moved so the two rails are shifted only by a
horizontal distance rather than a vertical one.

We actually made two iterations of the design of the y axis holders, as the
belts controlling the two axes were touching each other on the first design as
shown in figure \ref{fig:evobot_belts_touching}. The second design shown in figure
\ref{fig:evobot_belts_apart} however introduced other issues, as the belts were
lowered to an extend where the distance from belt to carriage is so long that it
is difficult to attach the belt to the carriage. Currently, the first design is
represented in the bottom of the robot and the second design in the top.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_belts_touching}
        \caption{}
        \label{fig:evobot_belts_touching}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_belts_to_far_apart}
        \caption{}
        \label{fig:evobot_belts_apart}
    \end{subfigure}

    \caption{Issues with the design of the y axis holders.}
    \label{fig:evobot_belts}
\end{figure}

We have a quite practical issue with the y axis holders in the top, as we ran
out of ball bearings of the right size. We did not have time to order new, so
the holders are attached to the rails on ball bearings that are too small and
then raised with small pieces of paper so the plastic does not hit the rails
directly. The result is that the top x and y axes run very badly (when they run at
all). This should easily be overcome with the correct ball bearings, but since
the top carriage is not a necessity for what we wish to achieve in this project,
we decided to leave the top as is.

The carriage of EvoBot is designed entirely from scratch. There are several
reasons for this. The first is that the carriage had to be modified for running
on the horizontally shifted linear rails. Furthermore, where the carriage of
Splotbot is made solely to house 6 syringes, we wanted the carriage of
EvoBot to support various types of components. We consider a component as being
an individual piece of hardware which can be separated from and added to the
robot without interference with other parts of the setup. In order to allow such
attachment and removal of components, we designed the carriage as a block with
holes in it in which we insert wooden dowels. Any component to be added on the
carriage then have to have similar holes, so it can easily by added on top with
the dowels holding it in place.

The only such component we have currently made is the camera component shown in
figure \ref{fig:evobot_parts_camera}. It consists of two plates separated by nuts
and bolts, the bottom one having the holes allowing it to be attached to the
carriage. The nuts and bolts setup allows for all four corners of the top plate
being adjustable separately, so the camera frame plane can be aligned as close
as possible with the Plexiglas plate. On the picture, the component is not
fully attached to the carriage as the holes of the component are a bit too
small. But it is still very firmly attached.

## Electronics
In order to make the robotic platform actually do something, we need some kind
of electronics to control the stepper motors, limit switches, and RC servo
motors. As mentioned, an Arduino board as used in Splotbot is not sufficient, as
it is in the way of the robotic platform being completely standalone. This is
because the logic contained in the Arduino board is the execution of simple
instructions, whereas the needed image analysis and processing requires more
powerful hardware. This is why we for this project decided to use a BeagleBone
Black as the brain of the robot. Figure \ref{fig:evobot_electronics} shows a
picture of the electronics of EvoBot.

\begin{figure}
    \centering
    \includegraphics[width=0.6\textwidth]{images/hardware_electronics}
    \caption{The electronics of EvoBot.}
    \label{fig:evobot_electronics}
\end{figure}

The BeagleBone Black is a microcomputer with 512Mb of RAM, a 1Ghz ARM processor,
a single USB port, an ethernet port, and 2x46 GPIO ports. The board comes with
an embedded Linux distribution called Ångström [@beagleboneblack]. Because of it
running Linux, the development and deployment of code for the board
is as easy as connecting to the board and compiling and running the code
directly on the board. The GPIO ports can be accessed through a device three
overlay, and the USB connections are registered as a regular device connected to
the Linux system.

In addition to the BeagleBone Black in itself, we utilize two hardware
components in order to communicate with the moving parts of the platform. The
first is an expansion option called the BeBoPr++ cape [@bebopr], which has
connections for stepper motors and limit switches (along with other connections,
which we do not use). For the stepper motors, separate hardware stepper drivers
are used. The cape also provides surge protection. The servo motors are
controlled with a Polulo Servo Controller board, an USB device for controlling
servo motors [@poluloservocontroller]. In order to use multiple USB devices with
the BeagleBone Black, we use an USB hub.

The final piece of hardware on EvoBot is a small wireless router, which is
connected to the ethernet port of the BeagleBone Black. The BeagleBone Black is
set up with a static IP address in the router, which means than access to the
robot is as simple as connecting to the wireless network (wired connection is
also possible) and connecting to the board using the known IP address.

In order to have the electronics mounted on EvoBot, we have attached a wooden
plate to the bottom of the frame on which the electronics and power supplies are
fastened.

## Experiments
In order to assess the suitability of the hardware design, a simple experiment
was designed. The goal of this experiment is to measure the approximate
precision and consistency of a crucial part of the design, the motors and belts
moving the carriage. To do this, the following steps where performed:

1. A cross is drawn on a piece of paper with millimeter precision
lines
2. EvoBot's camera is placed in position (0,0)
3. The paper is placed on the Plexiglas plate above the camera so the cross is
visible, and an image is grabbed
4. EvoBot is given the instructions to fifty times move the camera the max
position and then return to (0,0) again
5. Another image is grabbed
6. The two images are compared to see how far off the cross is in the second
image compared to the first

Step six was done by overlaying the two images in image manipulation software
and measuring the difference. As it turns out, however, there was no visible
difference. The two images grabbed can be seen in figure
\ref{hardware_experiments_results}.

\begin{figure}[h]
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_experiment_start}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/hardware_experiment_end}
        \caption{}
    \end{subfigure}
    \caption{The resulting images of the movement precision experiment.}
    \label{hardware_experiments_results}
\end{figure}

## Summary
EvoBot draws almost all of its inspiration in terms of physical hardware design
from Splotbot. EvoBot does add both entirely new features, such as the bottom
carriage, and improves on the existing functionality, such as added stability to
the frame and carriages. The modification of the frame meant that all the 3D
printed parts of Splotbot had to be redesigned to some extend. There are also
parts of Splotbot which are not included in this iteration of EvoBot such as
syringes and the gripper arm for moving petri dishes.

In terms of electronics, the Arduino used for controlling Splotbot has in EvoBot
been replaced with a BeagleBone Black, a general purpose microcomputer, allowing
the robotic platform to be completely standalone. The BeagleBone Black is
accompanied both with special purpose hardware to drive motors, as well as
commodity hardware such as a web camera and a simple wireless router which
assures easy connectivity to the robot.

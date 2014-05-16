# Constructing the physical robot
This chapter focuses on building the physical part of the EvoBot (the hardware).
We start by briefly outlining the hardware of the Splotbot, as the EvoBot is very
much based on this construction. We then move on to explain the modifications
made from Splotbot to EvoBot, resulting in a description of the EvoBot setup
along with an explanation of the reasoning behind the design.

## The hardware of Splotbot
The basis of Splotbot is the ??cm metal frame. It is ??cm tall, ??cm long, and
??cm wide. In the center of the frame is a ??glass?? plate attached, on which
experiments are run. An overview of the robot is given in figure
\ref{fig:splotbot} (a).

The next part of the robot is a top carriage which can move along two axes. This
carriage is driven by belts. In order to move along the x axis, 3D printed
pieces of hardware are mounted near the top corners of the frame. These hold an
8mm linear rail between them. Furthermore, on one side of the robot these pieces
hold stepper motors with a pulley, while the other side have pulleys on ball
bearings, allowing for driving a belt between them. This belt is then attached
to another 3D printed piece running on ball bearings on the linear rails. This
setup is shown in figure \ref{fig:splotbot} (b).

In order to move along the y axis, a stepper motor is attached to one of these
pieces with the previously mentioned belted attached. A similar constructing
allows for driving a belt between along the y axis. Two 8mm linear rails (one
above the other) are held along the y axis on which the movable carriage is
mounted on ball bearings. This carriage has six syringes mounted on it, each
controlled by two RC servo motors. The y axis and carriage are shown in figure
\ref{fig:splotbot} (c).

The Splotbot has a camera to monitor experiments. This camera is fixed to the
bottom of the robot as shown in figure \ref{fig:splotbot} (d).

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}

    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}

    \caption{Images of Splotbot.}
    \label{fig:splotbot}
\end{figure}

Finally, the Splotbot is controlled by an Arduino Mega 2560
[@arduino_mega_2560]. Instructions are sent from a personal computer connected
via USB.

## From Splotbot to EvoBot
There are several places where we found that the hardware of Splotbot was not
sufficient for what we wished to achieve with Splotbot:

- The frame was a bit shaky when running, so we wanted the frame to be more
    robust
- We needed the camera to be able to move along two access similar to the top
    carriage, so we wanted to replicate the top carriage design in the bottom
    part of the robot
- In order to make room for a bottom carriage, and also to preserve the
    possibility of exchanging the camera with larger cameras or scanners, we
    wanted more space below the ??glass?? plate
- The carriage of is very shaky due to the rails on which it is attached being
    placed only with a vertical distance between them, so we wanted to alter
    this to be a horizontal distance only
- In order to make the EvoBot a stand alone unit, we wanted to exchange the
    Arduino board with a more general purpose computer

The carriage running on linear rails driven by belts and stepper motors seemed
to work well enough on Splotbot for us to not want to spend time trying to
improve them due to the limited scope of the project and due to us having hardly
any knowledge about hardware.

Finally, due to the limitations in available time we decided not to spend time
on constructing syringe parts, though they be nice to have on the EvoBot as
well. We do, however, include the control of RC servo motors in the scope of the
project, so adding syringes similar to those on Splotbot should be possible at a
later point in time.

The following sections explain how we designed and built the hardware of EvoBot
to suit our needs.

## Making the frame
The EvoBot has an aluminum frame similar to that of Splotbot. But the width of
the frame is 3cm, making it a lot more sturdy. Furthermore, the dimensions of
the frame have been increased to it being ??66cm?? tall, ??50cm?? long, and
??76cm?? wide.

Initially, the EvoBot was constructed to be 66cm tall, 106cm long, and 76cm
wide. This was mainly due to us having help (very much appreciated) with buying
the hardware from a fellow student of ours, Lars Yndal, who in parallel with us
were building a version of the EvoBot. His project needed a larger robot than
ours, and he was quick as finding out what hardware he needed to build it. As we
at that point had very little idea of what we needed, we agreed that it would be
a good idea to follow his lead and buy the materials needed for building his take
on the robot. However, as the work moved along, we found that the dimensions we
too big for our needs, resulting in us only using about half of the length of
the robot, as can be seen on the image of the EvoBot in figure \ref{fig:evobot}.
We suggest that the frame is cut in half, removing the unused part of the frame
as it is only in the way, but we did not get to doing this.

\begin{figure}
    \centering
    \includegraphics[width=0.6\textwidth]{images/todo}
    \caption{The EvoBot.}
    \label{fig:evobot}
\end{figure}

As on Splotbot, a transparent plate is attached to the frame on which the
experiments are run. On the EvoBot, this is a ??mm Plexiglass plate.

As the frame dimensions were altered, the 3D printed parts of the robot had to
be redesigned to fit the change. This is described in the next section.

## Designing and 3D printing the parts
The EvoBot contains 5 unique 3D printed parts, all depicted in figure
\ref{fig:evobot_parts}:

- An x axis holder with a stepper motor ((a), 4 pcs.)
- An x axis holder without a stepper motor but with a pulley instead ((b), 4 pcs.)
- A y axis holder with a stepper motor ((c), 2 pcs.)
- A y axis holder without a stepper motor but with a pulley instead ((d), 2 pcs.)
- A carriage ((e), 2 pcs.)

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}

    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}

    \caption{The 3D printed parts of the EvoBot.}
    \label{fig:evobot_parts}
\end{figure}

Each of the parts were designed and printed by us. As a disclaimer, neither of
us as previously made such a 3D design. Once a part was printed, we always ended
up spending time sawing and drilling it to fit the robot. This was due to both
imprecision in the print and due to the designs being less than perfect.  As the
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
shown in figure \ref{fig:evobot_belts} (a). The second design shown in figure
\ref{fig:evobot_belts} (b) however introduced other issues, as the belts were
lowered to an extend where the distance from belt to carriage is so long that it
is difficult to attach the belt to the carriage. Currently, the first design is
represented in the bottom of the robot and the second design in the top.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}

    \caption{The issues with the design of the y axis holders.}
    \label{fig:evobot_belts}
\end{figure}

We have a quite practical issue with the y axis holders in the top, as we ran
out of ball bearings of the right size. We did not have time to order new, so
the holders are attached to the rails on ball bearings that are too small and
then raised with small pieces of paper so the plastic does not hit the rails
directly. The result is that the top x/y axes run very badly (when they run at
all). This should easily be overcome with the correct ball bearings, but since
the top carriage is not a necessity for what we wish to achieve in this project,
we decided to leave the top as is.

The carriage of the EvoBot is designed entirely from scratch. There are several
reasons for this. The first is that the carriage had to be modified for running
on the horizontally shifted linear rails. Furthermore, where the carriage of
Splotbot is made solely to house 6 syringes, we wanted the carriage of the
EvoBot to support various types of components. We consider a component as being
an individual piece of hardware which can be separated from and added to the
robot without interference with other parts of the setup. In order to allow such
attachment and removal of components, we designed the carriage as a block with
holes in it in which we insert wooden dowels. Any component to be added on the
carriage then have to have similar holes, so it can easily by added on top with
the dowels holding it in place.

The only such component we have currently made is the camera component shown in
figure \ref{fig:evobot_parts} (f). It consists of two plates separated by nuts
and bolts, the bottom one having the holes allowing it to be attached to the
carriage. The nuts and bolts setup allows for all four corners of the top plate
being adjustable separately, so the camera frame plane can be aligned as close
as possible with the Plexiglass plate. On the picture, the component is not
fully attached to the carriage as the holes of the component are a bit too
small. But it is still very firmly attached.

The final part of the hardware are the electronics, which are described in the
next section.

## Electronics
In order to make the robotic platform actually do something, we need some kind
of electronics to control the stepper motors, limit switches, and RC servo
motors. As mentioned, an Arduino board as used in Splotbot is not sufficient, as
it is in the way of the robotic platform being completely stand alone. This is
because the logic contained in the Arduino board is the execution of simple
instructions, whereas the needed image analysis and processing requires more
powerful hardware. At the same time we need to keep the price of the robot low.
This is why we for this project decided to use a BeagleBone Black as the brain
of the robot. Figure \ref{fig:evobot_electronics} shows a picture of the
electronics of the EvoBot.

\begin{figure}
    \centering
    \includegraphics[width=0.6\textwidth]{images/todo}
    \caption{The electronics of the EvoBot.}
    \label{fig:evobot_electronics}
\end{figure}

The BeagleBone Black is a microcomputer with 512Mb of RAM, a 1Ghz ARM processor,
a single USB port, an ethernet port, and 2x46 GPIO ports. The board comes with
an embedded Linux distribution called Ångström [@beagleboneblack]. Because of it
being a Linux computer, the development and deployment of code for the board
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

The final piece of hardware on the EvoBot as a small wireless router, which is
connected to the ethernet port of the  BeagleBone Black. The BeagleBone Black is
set up with a static IP address in the router, which means than access to the
robot is as simple as connecting to the wireless network (wired connection is
also possible) and connecting to the board using the known IP address.

In order to have the electronics attached to the EvoBot, we have attached a
wooden plate to the bottom of the frame on which the electronics and
power supplies are fastened.

The BeagleBone Black is very limited in computational power. The suitability of
the board will be discussed in relation to the topics covered in the remaining
chapters.

## Summary
We first described the hardware of Splotbot, the robot on which the EvoBot is
based. We then gave an overview of the differences in hardware needs on the two
robots respectively, such as the EvoBot needing a bottom carriage for the camera
whereas the camera is fixed on Splotbot. Based on this we introduced our design
of the parts of the EvoBot which we have 3D printed, along with a discussion of
the parts of the design that did not work as well as hoped. Finally, we
explained the electronics used in EvoBot, being controlled by a BeagleBone Black
microcomputer with a BeBoPr++ cape extension, a separate servo controller
connected through USB, and an USB hub for attached several USB devices.

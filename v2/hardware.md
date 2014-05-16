# Constructing the physical robot
This chapter focuses on building the physical part of the EvoBot (the hardware).
We starti by briefly outlining the hardware of the Splotbot, as the EvoBot is very
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

In order to move along the y axis, as stepper motor is attached to one of these
pieces with the previously mentioned belted attached. A similar constructing
allows for driving a belt between along the y axis. Two 8mm linear rails (one
above the other) are held along the y axis on which the movable carriage is
mounted on ball bearings. This carriage has six syringes mounted on it, each
controlled by two RC servo motors.  The y axis and carriage are shown in figure
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

- The frame was a bit shaky when running, so we wanted a stronger one
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

Initially, the EvoBot was contructed to have be 66cm tall, 106cm long, and 76cm
wide. This was mainly due to us having help (very much appreciated) with buying
the hardware from a fellow student of ours, Lars Yndal, however parallel with us
were building a version of the EvoBot. His project needed a larger robot than
ours, and he was quick as finding out what hardware he needed to build it. As we
at that point had very little idea of what we needed, we agreed that it would be
a good idea to follow his lead and by the materials needed for building his take
on the robot. However, as the work moved along, we found that the dimensions we
too big for our needs, resulting in us only using about half of the length of
the robot, as can be seen on the image of the EvoBot in figure \ref{fig:evobot}.
We suggest that the frame is cut in half, removing the unused part of the frame
as it is only in the way, but we did not get to doing this.

\begin{figure}
    \centering
    \includegraphics[width=0.6\textwidth]{images/todo}
    \caption{Picture of the EvoBot.}
    \label{fig:evobot}
\end{figure}

As the frame dimensions were altered, the 3D printed parts of the robot had to
be redesigned to fit the change. This is described in the next section.

## Designing and 3D printing the parts


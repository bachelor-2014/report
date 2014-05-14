# Robot-camera calibration
The camera is a central part of the current EvoBot setup. This was the same for
the Splotbot setup. We also use the same PlayStation Eye camera with a 10x zoom
lense attached, meaning that the images grabbed suffer from the same radial
distortion as described by Juan Gutierrez [@gutierrez2012, pp. 59-65].
Furthermore, one of the image stitching algorithms described in chapter
\ref{sec:scanning} assumes prior knowledge about the relationship between the
images grabbed and the physical robot. These are the topics of this chapter.

## Goals
In terms of radial distortion we have the obvious goal that we want the robot to
**be able to undistort images from radial distortion**. We also want to **be
able to calibrate the camera in terms of its relationship to the movement of
the carriage on which it is mounted**, as this as a necessary precondition
for other functionality. In order to make the calibration as convenient as
possible for the user, we set forth the goal that **camera calibration has
to be done only once**. Of course, if the hardware setup changes, the camera
will have to be recalibrated. This also means that if the setup is made by a
technician, she can also calibrate the camera, and users will from there on
not have to recalibrate it. Finally, we see the two different calibrations,
for radial distortion and for the relationship with the physical movement,
as conceptually being a single calibration from the point of view of the
user, and we therefore want that **both calibrations are a single
calibration from the point of view of the user**. Hopefully, this limits the
number of required input from the user, before the robotic platform can be
put to use.

## Undistorting images
In order to undistort the images grabbed we use an approach similar to the one in
Splotbot [@gutierrez2012, pp. 61-65]. We grab 9 images of a chessboard pattern,
of which the corners can be detected by use of OpenCV. We then use OpenCV again
to estimate the intrinsic camera parameters, and again, we use OpenCV to use
these parameters to undistort the grabbed images.

What we do differently than in Splotbot is that we use use the fact that we can
move the camera along two axes to automatically grab all the images needed to do
the calibration. For this, we require the user to lay a 9x6 chessboard pattern
over the camera. The entrie chessboard pattern must be visible on the same image
in order for OpenCV to be able to detect it. If the camera is at position $(x,
y)$, then the camera is then moved to the positions
$$\left\{ (a, b) | a \in \left\{ x-1,x,x+1 \right\} \land b \in \left\{ y-1,y,y+1 \right\} \right\}$$
and an image is grabbed in each position. The chessboard pattern corners is detected in
each image, based on these corners the intrinsic camera parameters are
estimated. Each time an image is grabbed, it is checked whether the camera has
been calibrated. If it has, the image is undistorted. Figure
\ref{fig:calibration_undistortion} shows nine images used for a calibration and
the resulting undistortion of an image.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%

    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%

    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%

    \begin{subfigure}[t]{0.4\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}

    \caption{Calibration of the intrinsic camera parameters and undistortion of
        images. Images (a) - (i) show the images used for the calibration. Image
        (j) shows an undistorted image.}
    \label{fig:calibration_undistortion}
\end{figure}

We have experienced that the size of the chessboard pattern impacts the
resulting undistortion. Figure \ref{fig:calibration_chessboard_sizes} shows
three calibrations done with different size chessboards. We have found that the
larger an area of the image the chessboard pattern covers, the better is the
resulting calibration. But only to the extend that the corners of the chessboard
pattern must be visible in all of the images grabbed.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/todo}
        \caption{}
    \end{subfigure}%

    \caption{Calibration with three different sized chessboard patterns}
    \label{fig:calibration_chessboard_sizes}
\end{figure}

## The relationship between images and the physical robot

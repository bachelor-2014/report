# Robot-camera calibration
\label{sec:calibration}
EvoBot uses computer vision to obtain information about the experiment.  The
camera is therefore a central part of the current EvoBot setup.  This was also the
case for the Splotbot setup. We also use the same PlayStation Eye camera with a
10x zoom lense attached, meaning that the images grabbed suffer from the same
radial distortion as described by Juan Gutierrez [@gutierrez2012, pp.  59-65].
Furthermore, one of the image stitching algorithms described in chapter
\ref{sec:scanning} assumes prior knowledge about the relationship between the
images grabbed and the physical robot. These are the topics of this chapter.

## Goals
In terms of radial distortion we have the obvious goal that we want the robot to
**be able to undistort images from radial distortion**. We also want to **be
able to calibrate the camera in terms of its relationship to the movement of the
carriage on which it is mounted**, as this is a necessary precondition for other
functionality. In order to make the calibration as convenient as possible for
the user, we set forth the goal that **camera calibration has to be done only
once**. Of course, if the hardware setup changes, the camera will have to be
recalibrated. This also means that if the setup is made by a technician, she can
also calibrate the camera, and users will from there on not have to recalibrate
it. Finally, we want the two different calibrations, for radial
distortion and for the relationship with the physical movement, as **being
conceptually a single calibration from the point of view of the user**. This
limits the number of required input from the user, before the robotic platform
can be put to use.

## Undistorting images
In order to undistort the images grabbed we use an approach similar to the one in
Splotbot [@gutierrez2012, pp. 61-65]. We grab 9 images of a chessboard pattern,
of which the corners can be detected by use of OpenCV. We then use OpenCV again
to estimate the intrinsic camera parameters, and again, we use OpenCV to use
these parameters to undistort the grabbed images.

What we do differently than in Splotbot is that we use use the fact that we can
move the camera along two axes to automatically grab all the images needed to do
the calibration. For this, we require the user to lay a 9x6 chessboard pattern
over the camera. The entire chessboard pattern must be visible on the same image
in order for OpenCV to be able to detect it. If the camera is at position $(x,
y)$, then the camera is moved to the positions
$$\left\{ (a, b) | a \in \left\{ x-1,x,x+1 \right\} \land b \in \left\{ y-1,y,y+1 \right\} \right\}$$
and an image is grabbed in each position. The chessboard pattern corners are detected in
each image, and based on these corners the intrinsic camera parameters are
estimated.

When turning on the camera, each time an image is grabbed, it is checked
whether the camera has been calibrated. If it has, the image is undistorted.
Figure \ref{fig:calibration_undistortion} shows nine images used for a
calibration and the resulting undistortion of an image.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_1}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_2}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_3}
        \caption{}
    \end{subfigure}%

    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_4}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_5}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_6}
        \caption{}
    \end{subfigure}%

    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_7}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_8}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.2\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_input_9}
        \caption{}
    \end{subfigure}%

    \begin{subfigure}[t]{0.4\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_undistortion}
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
        \includegraphics[width=\textwidth]{images/calibration_result_small}
        \caption{Small pattern (1.9x1.3cm)}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_result_medium}
        \caption{Medium sized pattern (3.1x2.2cm)}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_result_large}
        \caption{Large pattern (5.6x3.9cm)}
    \end{subfigure}%

    \caption{Calibration with three different sized chessboard patterns.}
    \label{fig:calibration_chessboard_sizes}
\end{figure}

## The relationship between images and the physical robot
Each time the camera is moved a step in either the x or y direction, the
relationship between two images grabbed, one before and one after the movement,
is a simple translation. If we assume that the camera is aligned with the axes
of the robot and that the image plane is parallel to the Plexiglas plate. With
this assumption, we can estimate the exact translation for a step in either
direction respectively with the following steps:

1. Grab an image
1. Move a single step
1. Grab a new image
1. Estimate the translation based on an object recognizable in both images

This has to be done for a step in each direction separately. In order to avoid
errors having a large effect, we repeat this process multiple times in the
implementation and average the translations computed.

The first three steps are trivial. For our calibration we use the same 9x6
chessboard pattern as a recognizable object. This has the advantage that it is
easily detectable by OpenCV, and also that the calibration can be done in
extension with the previous calibration. When the previous camera calibration
finishes, the camera is already located below a detectable chessboard pattern,
which can then be used for this calibration. This also helps fulfilling the goal
of the user seeing the two actual calibrations as a single calibration.

Several consideration have been put into the final step. Our first attempt at
estimating the translation was based on the capabilities of OpenCV. When the
chessboard corners have been detected in both images, OpenCV provides a function
for estimating an affine transformation between the two images based on the
points. The result is a transformation matrix on the form [@paulsen2012, pp.
134-137]:

$$
\begin{bmatrix}
    a_1 & a_2 & a_3 \\
    b_1 & b_2 & b_2 \\
    0 & 0 & 1
\end{bmatrix}
$$

where $a_3$ is the translation in the x direction and $b_3$ is the translation
in the y direction. From this matrix we then pulled the translation values. But
when used in image stitching (chapter \ref{sec:scanning}), these values were not
very precise. The problem is that the affine transformation also encodes
scaling, rotation, and shearing [@paulsen2012, pp. 134-136], and when we simply
remove these, a part of the relationship between the position of the chessboard
on the two images are lost.

We therefore tried a different, more simple approach. When detecting the
chessboard corners in each of the images, we use the corners to compute the
center of the pattern by averaging the x and y values of all the points. The
result is that we have two points, $(x_1, y_1)$ in the first image and $(x_2,
y_2)$ in the second image. The translation in each direction is then found by
the simple calculation:

$$\Delta x = x_2 - x_1$$
$$\Delta y = y_2 - y_1$$

This second method provided much better results. The calculation is depicted in
figure \ref{fig:calibration_step_calibration}. It is this implementation that
is currently in use, and examples of application of the results of this
calibration are given in chapter \ref{sec:scanning}. But it is worth noting
that the method is very sensitive to the physical setup. If the camera is not
properly aligned, it might provide less than satisfying results. We have,
however, not experimented with this.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_translation_input_1}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_translation_input_1}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/calibration_translation}
        \caption{}
    \end{subfigure}%

    \caption{Calibration of the correspondence between physical steps and image pixels. Images (a) and (b) are the input images with the chessboard corners and center points detected. Image (c) shows the estimated translation vector illustrated by a black line.}
    \label{fig:calibration_step_calibration}
\end{figure}

Finally, we note that in order for the user not having the do these calibrations
multiple times, we store the calibration results in a file, which can then be
loaded at a later point if desired.

## Summary
In order to remove the radial distortion of the camera used in the setup, we
computed the intrinsic camera parameters by grabbing multiple images of a 9x6
chessboard pattern which were provided as input to an OpenCV function. The
resulting matrix was then used to undistort the images grabbed from there on.

The relationship between moving the camera a single step and the corresponding
transformation between two images grabbed before and after the move respectively
was estimated. By grabbing an image of the chessboard pattern, moving the camera
a single step, and grabbing a new image of the pattern, the vector from the
center point of the pattern on the second image to the center point of the pattern on
the first image provided a usable estimate of the translation.

The above calibrations were done entirely by EvoBot, requiring only from the
user that she put a chessboard pattern on the Plexiglas plate where it was
visible to the camera.

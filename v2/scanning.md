# Getting an overview of large surface areas
\label{sec:scanning}
In this section we look at an issue introduced, when the experiments to be
performed on the EvoBot have a large surface area e.g. when doing experiments
in a petri dish with a diameter of 14cm. This becomes a problem, when an area
must be observed which is larger than what can be captured in a single image by
the camera due to its limited field-of-view.

We first introduce our goals concerning the robotic platform regarding this. We
then account for how we have tried to achieve these goals, along with the end
results and a discussion of these.

## Goals
The goals of this chapter stem from two properties of some of the experiments
that the EvoBot must run:

1. Some experiments cover a large surface area
1. The experiments are usually slow moving

When we combine these with the fact that the camera of the current setup has a
very limited field-of-view due to the attached zoom lense as explained in
chapter \ref{sec:camera}, this introduces difficulties to overcome, but also
leaving room for them to be solved. The single camera is movable, so it is
possible to cover a larger surface area than can be captured in a single image
by moving the camera to different position, grabbing images, and combining the
images to a single image. And this is made possible due to the experiments
being slow moving, as this leaves time for the camera to be moved and for
grabbing the images, without the experiments changing much in the meantime,
which would cause the images grabbed being inconsistent.

These considerations can be summed up in two goals for the EvoBot. We wish to
combine the camera with the mobility of the bottom carriage of the robotic
platform to **automatically grab multiple images and stitch them together**,
forming a single image of a large surface area. Furthermore, we wish to achieve
this in **the shortest possible time**, in order to minimize the inconsistency
between the images while also allowing as quick as possible feedback to the
user.

It is worth noting that one stakeholder has shown interest in using other kinds
of cameras/scanners, such as an OCT scanner, which takes three-dimensional
images each covering a surface area of about 1 cm^3 [@wikioct]. Due to the
scope of this project, we will only work with two-dimensional images, and we
will use the camera also used in the Splotbot setup, as described in chapter
\ref{sec:camera}.

## Scanning pipeline
At this point in the development of the EvoBot, we already had separate
components for the camera and for the set of x/y axes controlling the bottom
carriage. We wished to reuse these as much as possible, avoiding doing the same
work multiple times. One possibility was to add the logic concerning the
scanning by image stitching to one of these components. But the responsibility
does not conceptually reside in any of these components alone. Instead, we
decided to introduce as `Scanner` component with references to the existing
`Camera` and `XYAxes` components, encapsulating this new scanning logic in a
separate component.

The scanning pipeline itself is quite simple. It consists of the following
steps:

1. Input is the start and end positions of the camera, the step size between
each image grabbed, the duration to sleep after each move of the camera
before grabbing the next image, and the stitching algorithm to use.
1. The camera is first moved to the start position, where the first image is
grabbed.
1. The camera is the moved to each position between the start and end positions
defined by a rectangular grid with the given step size between each point,
ending on the end position, grabbing an image at each point.
1. Each image is stored together with the location at which the image is
grabbed.
1. The images are stitched together.

The sleep time allows for making sure the camera is moved correctly before
grabbing the image. This is necessary due to the interactions with the stepper
motors being asynchronous as described in chapter \ref{sec:modularity}.

The following is an example of such a scanning:

1. The input provided is:
    - Start position: $(10, 10)$
    - End position: $(20, 25)$
    - Step size: $5$
    - Sleep time before grabbing images: $1000ms$
    - The algorithm is irrelevant in this case
1. The camera is moved to position $(10, 10)$, where the first image is grabbed.
1. The camera is then moved to the positions $(10, 15)$, $(10, 20)$, $(10, 25)$,
$(15, 10)$, $(15, 15)$, $(15, 20)$, $(15, 25)$, $(20, 10)$, $(20, 15)$, $(20,
20)$, $(20, 25)$, where the rest of the images are grabbed.
1. Each image is stored with the corresponding location, so the first image is
stored with $(10, 10)$, the next with $(10, 15)$, and so on.
1. The images get stitched together.

For this project we have considered three different algorithms for doing the
actual stitching of the images:

1. Stitching based on image features
1. Stitching based on the position at which each of the images are grabbed
1. A combination of the first two, stitching based on both image features and
position

We have implemented the first two algorithms on the EvoBot, and played around
with implementing the third without finding time to complete the
implementation. In the following sections we explain our implementations of each
of these algorithms. For each of the algorithms described, we assume that the
camera is calibrated an the images grabbed have been corrected for radial
distortion as explained in chapter \ref{sec:calibration}.

## Stitching images based on image features
Stitching based on image features is in itself a pipeline consisting of many
steps. A simple example of such a pipeline could be [@solem2012, pp. 91-100]:

1. Input is a list of the images to stitch together
1. For each of the input images, find a number of features of interest. Such
features are areas on each image that are easy to recognize
1. Compare the interest points of each image with the interest points of the
other images, finding points that occur in multiple images
1. Use the points detected in multiple images to estimate how these images
relate to each other in terms of position such as one image being slightly
translated in the x direction compared to another image
1. Based on the obtained knowledge of the relationship between the images,
transform all the images into a larger combined image which is the final result

In our case we decided to use an existing image stitching implementation found
in OpenCV. This implements some version of the pipeline outlined above along
with several other improvements such as image scaling, exposure correction, and
blending of the images [@opencvstitchingpipeline]. Being part of OpenCV, we
expect the implementation to be robust and tested.

There are also downsides to using a generic image stitching implementation. The
first issue is concerning the performance of the algorithm. Every image is
compared with every other image (though the use of algorithms such as RANSAC
improves on this problem [@solem2012, pp. 92-98]), which in practice means that
for every extra image to stitch together, the result is a large increase in the
runtime of the algorithm.

The reason for this complexity is that the algorithm assumes no prior knowledge
about the images given as input. But we know for each image the position at
which the image was grabbed, and from the camera calibration (chapter
\ref{sec:camera}) we know how these positions correspond to translations in the
images. We use this knowledge in the stitching algorithm described in the next
section.

## Stitching images based on position
For the stitching algorithm based on image position we make a number of
assumptions:

- When moving the camera in the x direction, this corresponds to a simple image
    translation in the x direction. The same applies to the y direction. This
    means that there is not rotation or scaling involved with the
    transformation. This imposes the requirement on the physical camera setup
    that the camera is aligned with the axes of the robotic platform.
- We know from the camera calibration the image translations corresponding to a
    step with the stepper motors in each direction.
- Each step with the stepper motors result in the same distance travelled.
- All images have the same size.

Based on these assumptions, we put forth the following stitching pipeline:

1. Input are the images to stitch, the positions at which they were grabbed,
and the camera calibration linking camera movement with pixel translations
1. Search through all the positions, finding the min and max values of both the
x and y coordinates
1. Get the width and height of the images
1. Based on this information, compute the size of the resulting image and
create a black image of this size
1. For each image, compute the transformation matrix defining the transformation
from the image to the resulting image
1. Use the transformation matrices to warp each image onto the resulting image

Several of these steps concern some kind of computation. The following provides
an example of the stitching pipeline applied, also showing the calculations
involved:

1. Input is four images grabbed at the positions $(10, 10)$, $(10, 15)$, $(15,
10)$, and $(15, 15)$, and the calibration results that a step in the x direction
results in a translation of 20 pixels in the x direction and that a step in the
y direction results in a translation of 20 pixels in the y direction:
$$\Delta x = 20$$
$$\Delta y = 20$$
1. The min and max values are computed: 
$$minX = 10$$
$$minY = 10$$
$$maxX = 15$$
$$maxY = 15$$
1. The width and height of the images are retrieved:
$$width = 320$$
$$height = 240$$
1. The size of the resulting image is computed:
$$resultWidth = width + (maxX - minX) * \Delta x = 320 + (15 - 10) * 20
     = 420$$
$$resultHeight = height + (maxY - minY) * \Delta y = 240 + (15 - 10) * 20
     = 340$$
1. The transformation matrix for each image is computed. These matrices have
the following form, where $t_x$ and $t_y$ are the translations in the x and y
directions respectively [@paulsen2012, pp. 134-137]:
$$
\begin{bmatrix}
    1 & 1 & t_x \\
    1 & 1 & t_y \\
    0 & 0 & 1
\end{bmatrix}
$$
For the image at position $(x, y)$, we have that:
$$t_x = (x - min_x) * \Delta x$$
$$t_y = (y - min_y) * \Delta y$$
(This calculation actually depends on whether the translations are positive or
negative, but for this example the above is sufficient).
For this specific example, the result is the following values:
    - $(10, 10)$: $t_x = 0$, $t_y = 0$
    - $(10, 15)$: $t_x = 0$, $t_y = 100$
    - $(15, 10)$: $t_x = 100$, $t_y = 0$
    - $(15, 15)$: $t_x = 100$, $t_y = 100$
1. These transformation matrices are used to warp each image onto the resulting
image.

In order to achieve the warping in the final step, we do the following:

1. We warp the image onto a temporary, black image of the same size as the
    resulting image.
1. We then threshold the image with a threshold of 1. A thresholding results in a 
    binary image with all values below the given threshold being black and the
    remaining pixels being white [@paulsen2012, pp. 51-52].
1. We then use this binary image as a mask of the area to which we are to apply
    the image to the resulting image.

As we have experienced that the edge of each image did not look very nice when
warped using this approach, we apply a morphological dilation on the mask before
we use it, resulting in a bit of the image being warped being removed. The
entire warping process is illustrated in figure
\ref{fig:stitching_position_warping}.

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_position_result_before}
        \caption{The resulting image with two images already warped to it}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_position_image}
        \caption{The image to warp}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_position_temp}
        \caption{The image is warped onto a temporary black image}
    \end{subfigure}

    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_position_mask_morph}
        \caption{A mask for combining the images is computed}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_position_result_removed_mask}
        \caption{The mask is used to blacken a part of the resulting image}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.3\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_position_temp_removed_mask}
        \caption{The mask is applied to the temporary image}
    \end{subfigure}

    \begin{subfigure}[t]{0.9\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_position_result_after}
        \caption{The resulting and temporary images are added}
    \end{subfigure}

    \caption{The process of warping an image onto the resulting image.}
    \label{fig:stitching_position_warping}
\end{figure}

The advantage of this stitching algorithm is that adding an image extra to
stitch results in a constant number of added operations, making the runtime
linear. The major disadvantage is the dependency upon the correctness of the
assumptions. If the camera calibration is not precise, the stitching is equally
imprecise. The error is accumulating, as the error is repeated for each step the
camera is moved. This, however, is not visible in the image, as the error is
constant between the images next to each other. Furthermore, if the camera is
not aligned with the axes of the robotic platform, the algorithm does not
produce a correct result.

In order to remove this sensitivity to calibration precision, we have considered
a third algorithm described in the following section.

## Stitching images based on both image features and position
We have considered adding an algorithm combining the advantages of the above two
algorithms by stitching the images based on both image features and the position
at which the images were grabbed, but we have not found the time to make a
complete implementation.

This algorithm is best seen as an extension on the algorithm based solely on
image features. But rather than the interest points of each image being compared
with the interest points of every other image, we use the fact that we know
which images are next to each other to only compare each image with its
neighbours. In theory this reduces the complexity of the algorithm, due to
fewer comparisons having to be made for each image to be stitched.

Our idea was to to compute these regions of interest based on the same warping
calculations done in the position based image stitching algorithm. These could
to the accuracy of the position based stitching algorithm provide the areas in
which the images overlap. But we found that this approach had the inherent
difficulties that when images are stitched together using the OpenCV image
stitching implementation, the resulting image is sometimes scaled, sheared, or
something else, resulting in the relationship between the resulting image and
the positions at which the images are grabbed becoming unknown.

We played with the thought about implementing our own features based stitching
algorithm which could take these things into account, but due to the limited
scope of the project we did not find the time. We are certain that improvements
to both the image stitching results and the runtime can be achieved, and it
would therefore be interesting for another project to pick up this challenge.

In the following section, we compare the two implemented image stitching
algorithms in terms of both results and performance.

## Comparing the image stitching algorithms
We have compared the two implemented image stitching algorithms in terms of the
quality of the resulting images and the performance. The comparison is aided by
the running of a series of experiments providing simple benchmarks. For each
experiment, we do the following:

- Load the images to stitch
- Get the current time
- Stitch the images together, storing the resulting image
- Get the current time again
- Compute the runtime of the algorithm based on the times saved

Each image is run both on the BeagleBone Black on EvoBot and on a reference
laptop computer, allowing us to assess the feasibility of the algorithm being
used both in the current setup and in a setup with a more powerful computer.

### Resulting images
For the experiments we have two different scenes of which we have grabbed a
number of images, which we then stitch together. The first is a printed image of
a close up view of biofilm [@wikibiofilm]. The second as a large petridish with regular kitchen
oil, droplets from food colour, and a white background. For the sake of brevity
we have selected a few resulting images highlighting the differences between the
algorithms.

The first images are the result of stitching 20 images of the biofilm print
together with the two implemented algorithms respectively. These are shown in
figure \ref{fig:stitching_biofilm5_20}.

\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_biofilm_step5_20_features}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_biofilm_step5_20_position}
        \caption{}
    \end{subfigure}

    \caption{The resulting images of stitching together 20 images of the
        biofilm print using (a) the features based algorithm and (b) the
        position based algorithm.}
    \label{fig:stitching_biofilm5_20}
\end{figure}

We consider both of these images good results, as both combine the input images
in a realistic manner. The features based algorithm appears to include some of
the black edges in the images in some locations, while other locations are
blended extremely nicely, making the transition almost invisible. The position
based algorithm stitches very evenly throughout, with the same slight lack of
precision at each transition between images.

We next consider the case of stitching together only the first two of the
previous 20 images. The results are depicted in figure
\ref{fig:stitching_biofilm5_2}.

\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_biofilm_step5_2_features}
        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\textwidth]{images/stitching_biofilm_step5_2_position}
        \caption{}
    \end{subfigure}

    \caption{The resulting images of stitching together two images of the
        biofilm print using (a) the features based algorithm and (b) the
        position based algorithm.}
    \label{fig:stitching_biofilm5_2}
\end{figure}

The position based algorithm has stitched these images together in exactly the
same manner as with the 20 images. But the features based algorithm has altered
the shape of the image, resulting in a less realistic depiction of the actual
scene.

Finally, we consider the other scene of the petri dish with colored droplets. We
only successfully stitched together the image with the position based algorithm,
as the feature based algorithm is not capable of finding enough similar interest
points on the images to produce a result. The resulting image from the position
based algorithm is shown in figure \ref{fig:stitching_droplet10_full}.

\begin{figure}
    \centering
    \includegraphics[width=\textwidth]{images/stitching_droplet_step10_full_position}

    \caption{The resulting images of stitching together nine images of a petri
        dish with colored droplets using the position based algorithm.}
    \label{fig:stitching_droplet10_full}
\end{figure}

Based on these results we conclude that even though the features based stitching
algorithm is capable of creating the most invisible transitions between the
images in some cases, the fact the it it other cases creates unwanted results or
even is not capable of producing a result make the position based stitching
algorithm seem most suitable for the application.

### Performance
For testing the performance of the two algorithms we have done a number of image
stitchings of the print of biofilm. We have grabbed 45 images with a step size
of five between them, which can be stitched together to a full image. We have
then run each of the algorithms on subsets of these images of different
lengths (2, 4, 9, 12, and so on), making sure the subset can be stitched
together. For each run, we note the time. We repeat each stitching three
times. The results are shown in figure \ref{fig:stitching_performance}.

\begin{figure}
    \centering

    \begin{subfigure}[t]{0.5\textwidth}
        \begin{tikzpicture}
            \begin{axis}[
                legend style={at={(0.5,-0.25)}, anchor=north},
                scatter/classes={
                    a={mark=*,blue},
                    b={mark=*,green}
                },
                axis lines=middle,
                axis line style={->},
                x label style={at={(axis description cs:0.5,-0.1)},anchor=north},
                y label style={at={(axis description cs:-0.25,.5)},rotate=90,anchor=south},
                xlabel={Number of images},
                ylabel={Time in seconds}
                ]

                \addplot[scatter,only marks,
                    scatter src=explicit symbolic]
                    coordinates {
                        (2,29.741) [a]
                        (2,38.771) [a]
                        (2,115.291) [a]
                        (4,248.449) [a]
                        (4,252.813) [a]
                        (4,246.171) [a]
                        (9,1892.521) [a]
                        (9,1628.228) [a]
                        (9,1577.569) [a]

                        (2,0.671) [b]
                        (2,0.334) [b]
                        (2,0.560) [b]
                        (4,2.476) [b]
                        (4,2.464) [b]
                        (4,2.495) [b]
                        (9,15.850) [b]
                        (9,11.716) [b]
                        (9,15.703) [b]
                        (12,33.115) [b]
                        (12,32.985) [b]
                        (12,32.031) [b]
                        (16,99.856) [b]
                        (16,98.749) [b]
                        (16,98.173) [b]
                        (20,155.604) [b]
                        (20,157.668) [b]
                        (20,154.758) [b]
                        (25,197.944) [b]
                        (25,199.054) [b]
                        (25,196.226) [b]
                    };

                \legend{BeagleBone Black, Reference computer}
            \end{axis}
        \end{tikzpicture}

        \caption{}
    \end{subfigure}%
    ~
    \begin{subfigure}[t]{0.5\textwidth}
        \begin{tikzpicture}
            \begin{axis}[
                legend style={at={(0.5,-0.25)}, anchor=north},
                scatter/classes={
                    a={mark=*,blue},
                    b={mark=*,green}
                },
                axis lines=middle,
                axis line style={->},
                x label style={at={(axis description cs:0.5,-0.1)},anchor=north},
                y label style={at={(axis description cs:-0.13,.5)},rotate=90,anchor=south},
                xlabel={Number of images},
                ylabel={Time in seconds}
                ]

                \addplot[scatter,only marks,
                    scatter src=explicit symbolic]
                    coordinates {
                        (2,0.306) [a]
                        (2,0.301) [a]
                        (2,0.303) [a]
                        (4,0.791) [a]
                        (4,0.788) [a]
                        (4,0.791) [a]
                        (9,3.117) [a]
                        (9,2.820) [a]
                        (9,2.819) [a]
                        (12,4.754) [a]
                        (12,4.595) [a]
                        (12,4.597) [a]
                        (16,7.269) [a]
                        (16,7.274) [a]
                        (16,7.277) [a]
                        (20,10.760) [a]
                        (20,10.757) [a]
                        (20,10.772) [a]
                        (25,15.585) [a]
                        (25,15.593) [a]
                        (25,15.587) [a]
                        (30,21.693) [a]
                        (30,21.274) [a]
                        (30,21.682) [a]
                        (35,27.818) [a]
                        (35,27.813) [a]
                        (35,27.800) [a]
                        (40,35.141) [a]
                        (40,35.130) [a]
                        (40,35.145) [a]
                        (45,43.457) [a]
                        (45,43.440) [a]
                        (45,43.447) [a]

                        (2,0.004) [b]
                        (2,0.004) [b]
                        (2,0.004) [b]
                        (4,0.010) [b]
                        (4,0.010) [b]
                        (4,0.008) [b]
                        (9,0.028) [b]
                        (9,0.027) [b]
                        (9,0.027) [b]
                        (12,0.041) [b]
                        (12,0.039) [b]
                        (12,0.039) [b]
                        (16,0.075) [b]
                        (16,0.074) [b]
                        (16,0.077) [b]
                        (20,0.105) [b]
                        (20,0.103) [b]
                        (20,0.101) [b]
                        (25,0.152) [b]
                        (25,0.150) [b]
                        (25,0.150) [b]
                        (30,0.198) [b]
                        (30,0.191) [b]
                        (30,0.189) [b]
                        (35,0.281) [b]
                        (35,0.278) [b]
                        (35,0.284) [b]
                        (40,0.346) [b]
                        (40,0.346) [b]
                        (40,0.346) [b]
                        (45,0.419) [b]
                        (45,0.419) [b]
                        (45,0.414) [b]
                    };

                \legend{BeagleBone Black, Reference computer}
            \end{axis}
        \end{tikzpicture}

        \caption{}
    \end{subfigure}%

    \caption{The run times of the stitching algortihms: (a) features based (b)
        position based}
    \label{fig:stitching_performance}
\end{figure}

## Summary 
//TODO

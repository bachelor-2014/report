# Getting an overview of large surface areas
\label{sec:scanning}
In this section we look at an issue introduced, when the experiments to be
performed on the EvoBot have a large surface area e.g. when doing experiments in
a petri dish with a diameter of ?? *TODO insert diameter*. This becomes a
problem, when an area must be observed which is larger than what can be captured
in a single image by the camera due to its limited field-of-view.

We first introduce our goals concerning the robotic platform regarding this. We
then account for how we have tried to achieve these goals, along with the end
results and a discussion of these.

## Goals
The goals of this chapter stem from two properties of some of the experiments
that the EvoBot must run:

1. Some experiments cover a large surface area, such as ?? *//TODO*
1. The experiments are usually slow moving

When we combine these with the fact that the camera of the current setup has a
very limited field-of-view as explained in chapter \ref{sec:camera}, this
introduces difficulties to overcome, but also leaving room for them to be solved.
The single camera is movable, so it is possible to cover a larger surface area
than can be captured in a single image by moving the camera to different
position, grabbing images, and combining the images to a single image. And this
is made possible due to the experiments being slow moving, as this leaves time
for the camera to be moved and for grabbing the images, without the experiments
changing much in the meantime, which would cause the images grabbed being
inconsistent.

These considerations can be summed up in two goals for the EvoBot. We wish to
combine the camera with the mobility of the bottom carriage of the robotic
platform to **automatically grab multiple images and stitch them together**,
forming a single image of a large surface area. Furthermore, we wish to achieve
this in **the shortest possible time**, in order to minimize the inconsistency
between the images while also allowing as quick as possible feedback to the
user.

It is worth noting that one stakeholder has shown interest in using other kinds
of cameras/scanners, such as an OCT scanner, which takes 3-dimensional images
each covering a surface area of about 1 cm^3 [@oct]. Due to the scope of this
project, we will only work with two-dimensional images, and we will use the
camera also used in the Splotbot setup, as described in chapter
\ref{sec:camera}.

## Scanning pipeline
At this point in the development of the EvoBot, we already have separate
components for the camera and for the set of x/y axes controlling the bottom
carriage. We wish to reuse these as much as possible, avoiding doing the same
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
1. The camera is first move to the start position, where the first image is
grabbed.
1. The camera is the moved to each position between the start and end positions
defined by a rectangular grid with the given step size between each point,
ending on the end position, grabbing an image at each point.
1. Each image is stored together with the location at which the image is
grabbed.
1. The images are finally stitched together.

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
distortion as explained in chapter \ref{sec:camera}.

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

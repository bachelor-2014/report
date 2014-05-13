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

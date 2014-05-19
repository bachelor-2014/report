#Conclusion
\label{sec:conclusion}
Based on the previous work on the robotic platform Splotbot, we have managed to
build a new prototype named EvoBot, which has both overlapping and new
functionality, while some functionality of the previous platform has not been
implemented. The prototype is used for assessing a number of design decisions,
providing guidance in future iterations of building the robotic platform.

All the hardware and software have been built from scratch, continuously
focusing on modularity. As a result of this, EvoBot consists of a number of
components in both hardware and software. Based on a configuration file, the
relationship between these is established at startup.

A major change in the new prototype is that it has a moving camera. By first
calibrating the camera, removing radial distortion and estimating the
relationship between images and physical movement, we were able to make use of
this for both droplet detection and scanning. Droplet detection was based on the
corresponding feature in Splotbot, however with some modifications and
limitations, and with extra considerations to the application of image filters.
Scanning was something entirely new, for which a pipeline was developed where
the moving camera is used to grab several images which are then stitched
together to form a single larger image covering a large surface area.

In order to allow for programming of experiments on EvoBot, an instruction
execution architecture was built. The concept of events was added, allowing for
the robot not only executing instructions but also emitting data.  On top of
this we implemented a domain specific language named Rucola, supporting integer
arithmetics, variables, control flow mechanisms, execution of instructions on
components, and binding to events. This meant that complex, autonomous
experiments could be programmed and run directly on the robotic platform.

As experiments have the purpose of producing data for later analysis, data
logging was added to the prototype. It is capable of logging videos, images, and
textual data. The data is stored in a structured format, but we lack input from
the actual users about both what data they need and how it is to be used
afterwards.

Finally, we have build a web based graphical user interface for controlling the
robot. That it is web based means that using the robot requires no installation
of software on the computer of the user. The user only needs an internet
browser, as well as the ability to connect to the robotic platform. Connection
can be either wired or wireless through a router mounted on it.

The graphical user interface has separate controls for each of the component as
defined in the configuration file read at startup. Furthermore, it provides a
simple text editor with syntax highlighting for programming experiments, as well
as access to all the logged data, giving the user access to all implemented
functionality of EvoBot.

For this project we have build working prototype of a vision based liquid
handling robot for automation of chemical experiments. The design decisions made
for each step in the development have been discussed and documented. Some of the
design decisions made proved to have inherent issues, while others proved
suitable for the application. Hopefully the report will be used for guidance in
later iterations of building the robotic platform.

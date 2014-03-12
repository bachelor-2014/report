
#Goals and requirements
As outlined in the project description, there are certain goals for the
capabilities and properties for the enhanced version of SplotBot being developed
as the subject of this project. The goals are contained in the following
categories, which are described in more detail below:

- Modularity
- Programmability
- Usability

##Modularity
The SplotBot robot is very much under development and not a finished product;
the result of this is that the components of which it consists are rapidly
changing, which brings a need for a hardware and software architecture that
supports the addition and replacement of components without requiring major
alterations to the existing setup.

Our goals concerning the modularity of the robotic platform can be summarized in
the following points:

- Both the hardware and the software must be constructed in such a way that it
  is possible to exchange an entire component such as replacing a small syringe
  with a large syringe, requiring only that the user informs the robot of the
  change, restarts the robot, and calibrates the component if necessary.
- The software implementation must contain implementations of the most basic
  components, which are X/Y axis driven by stepper motors, RC servo motors, and
  syringes.
- In the software implementation it must be possible to add support for
  additional types of components without making any changes to the existing
  implementation. A recompilation of the entire source code is allowed as the
  result of adding additional code.
- In the software implementation, this modularity covers both the software
  controlling the hardware and the user interface.
- Where only there top carriage is movable on the existing robot, the new
  version must also include a movable carriage below the plate on which the
  experiments are performed. For this project we mainly wish to use it for
  containing a camera (or a similar component), but it must be extensible with
  components similar to how it is done with the top carriage. 

##Programmability
The main goal of the SplotBot robot is that it is capable of running experiments
for a long period of time without requiring any human interaction. This poses
quite a number of requirements on the programmability of the robot; it must be
possible for the user of the robot to define an experiment which the robot can
run. A such experiment includes, among other things, the movement of the motors
and syringes, the reaction on sensor data such as droplet properties based on
image analysis, and the conditions leading to termination of the experiment.

An example of such an experiment is the one performed by the current version of
SplotBot where a droplet of a certain oil is dropped into a liquid, coursing it
to move. The droplet is then tracked with the camera, and action on what to do
(including termination of the experiment) is done based on the properties of the
droplet as acquired through use of computer vision techniques.

As an extension on the programmability, it is considered a goal to allow for
evolutionary experiments where the results of one experiment determines the next
experiment(s), and where multiple such experiments must be performed by the
robot without requirement human interaction in between the experiments.

Our goals concerning the programmability of the robotic platform can be summarized in
the following points:

- The robot must support a programming language (Rucola) which allows for
  programming single experiments as well as multiple experiments performed in a
  row where the results of one experiment can be used to determined the next.
- The programming language must support directly controlling of components (such
  as moving the top carriage) as well as reactions upon certain events (such as
  what to de when the size of a droplet is below a certain threshold).
- A program written in Rocula must be executable directly on the SplotBot robot.
- Rucola must be fully documented, allowing users who have never worked with it
  before getting acquainted with the language without acquiring the assistance of
  other users.

##Usability
One of the major limitations of the current version of the SplotBot robot is the
ease-of-use. The problem arises at several steps of the usage of the robot; when
first connecting to the robot, the user must install the Pronterface application
which happens through use of Git and Pip which the average user (biologists,
chemists) are not able to do without assistance. And when interacting with the
robot 

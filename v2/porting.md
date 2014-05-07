
# Stand alone platform (Porting to the beagle bone)
\label{sec:standalone}
The Splotbot robot is currently run via an Arduino microcontroller which has
been wired up to the hardware. This allows the user to connect to the Arduino
via a normal computer and control the robot using the RepRap software. This
solution allows for easy prototyping, but poses problems for a user that does
not have experience with installing and using the Arduino and RepRap software
[@gutierrez2012].

The final robot is to be used by personnel with no experience with the RepRap
software and hardware, so we will investigate the possibility of making a stand
alone platform. The platform should not require the user to setup our software
on their own computer, instead they should start the machine and be able to run
experiments with little to no setup.

##Goals
When extending the platform to be more stand alone, we must first define which
goals we will strive to achieve. First we need to look at the issues with the
Splotbot's hardware and software which can be handled to make a standalone robot
and use it to define the goals we must strive to meet in our design. In the
following text, goals are displayed in **bold**

<!-- Section describing the current solution, should go where? -->
The Splotbot works using an Arduino microcontroller by connecting it to a users
normal computer, while this solution allows for easy prototyping we strive to
improve it by **not requiring the user to attach his/her own computer to
hardware**. Splotbot allows the user to define an experiment as a set of Gcode
instructions, these intructions are used to control the hardware of the Splotbot
via the Printrun software, to ensure that the user is not required to install
software needed to create, handle and send gcode we want to improve our platform
to **not require the user to install software on their own computer**. If
looking past the fact that the Splotbot requires a user to provide their own
computer, the platform is cheap to build, we want our solution to **still be as
cheap as possible to manifacture** while getting the benefits of a standalone
platform. Lastly the platform should still **be capable of performing the same
operations as the splotbot** including running experiments and tracking
droplets.

##Implementation
<!-- Overall -->
The implementation can be considered in 2 different major parts, there is the
hardware and the software. The hardware consists of firstly the main control
unit which runs the software and then the physical robot. The software consists
of our own software written from scratch and third party software and libraries.
Combined the hardware and software form the Evobot, in the following section we
will first discuss the hardware setup, followed by the software setup.

### The Hardware Setup
<!-- The Beaglone bone -->
![The Beaglone Bone Black \label{fig:beaglebonepic}](images/todo.png)
At the heart of our hardware setup we have the Beagle Bone Black (BBB)
microcomputer, it can be seen in figure \ref{fig:beaglebonepic}. The BBB has
512Mb of RAM, a 1Ghz ARM processor, 1 USB, Ethernet and 2x46 pins. The board
comes with an embedded Linux distribution called Ångström [@beagleboneblack].
Because of it being a Linux computer, the development and deployment of code for
the board, was as easy as connecting to the board and compiling and running the
code directly on the board. The GPIO ports and the USB can be talked to as any
device connected to the Linux kernel. After having tried using a breadboard to
connect the hardware to the BBB we decided to move to a more safe environment
and introduced the BeBoPr cape as our connector to the stepper motors and the
end stop contacts [@bebopr]. The servo motors are accessed via a Polulo Servo
Controller board [@poluloservocontroller]. 

In our hardware setup we have now introduced two set of movable axis and we
still have the camera for computer vision. While we did not completely replicate
the top carriage of the original Splotbot, we have tested the use of servos and
can conclude that it should be possible to completely rebuild the syringe
modules. All of the hardware options are thereby still a possibility with the
BBB and the BeBoPr, making the capabilities of the Splotbot completely replicate
able with this setup. 

### The Software Setup
Making the platform standalone, required a drastic changed in the software
used to address the robot. Supporting the BBB, we chose to go with a solution
that both allowed us to program with a more direct connection to the hardware
and at the same time making it possible to connect to the Evobot using only a
browser on the users computer. This setup required us to have 3 different
software components, the core which consists of a C++ codebase that addresses
the hardware and runs experiments, the NodeJS wrapper which handles the
communication to and from clients and the client a JavaScript based web client
that allows the user to control the robot using a simple web interface.

The software setup have improved many of the usabilities, capabilities and added
additional features to the Splotbot, but importantly to this chapter it is still
capable of performing the same tasks as the original Splotbot. Droplet detection
is still possible and viewable via the web interface. The hardware can now be
controlled via buttons in an interface, or via a low level instruction language
similar to gcode or even via a small programming language allowing the user to
still be able to define and experiment and having it run on the Splotbot.

<!-- Third party software used 
Our Software also consists of a few third party libraries and software. The C++
code have the following dependencies:

* OpenCV, this is used to support all of the different computer vision parts and
  communication with the camera. //TODO With what dependencies have we compiled
  OpenCV
* CVBlob, and extension library for OpenCV that makes it easier to do blob
  detection, we specifically use the for droplet detection. 
* The BeBoPr software created as a program for interpreting G code for 3D
  printing. We use this application to communicate with the stepper motors. 
* cJSON a c library for reading JSON files. Our software uses this to read our
  configuration file.
* Base64 encode and decode from
  [http://www.cplusplus.com/forum/beginner/51572/#msg280295](http://www.cplusplus.com/forum/beginner/51572/#msg280295)
* Curl, we use Curl to send HTTP requests from our C++ code. Specifically we
  use it to emit events to NodeJS which further emits them to the connected
  clients.

Our NodeJS application uses the following libraries:

* node-gyp, this tool allows us to build our NodeJS C++ module.
* Socket.io, websocket library used send data to and receive data from the
  client.
* Express, used to receive HTTP requests and host the client folder.

Our client application also uses some front end JavaScript libraries:

* AngularJS, framework for building single page JavaScript applications with
  features such as tempesting and data binding.
* Bootstrap, design framework to make our client not look like the run of the
  mill researchers homepage.
-->

##Discussion
In the following section we will discuss our solution to making the platform
standalone, the issues with it, the issues we faced making it, which
improvements can be made to the platform and some ideas to other possible
solutions. 

Looking back on our original goals with making the platform standalone, we have
achieved most of them. The BBB mini computer allowed us to move the
responsibility of talking to the hardware completely away from the users
computer, giving the platform the capabilities of running the hardware in
itself. With the introduction of a web based interface accessible over the local
network, we have also removed the need for installing new software on the users
computer. The BBB introduces new expenses to the platform, but we feel that the
extra $45 USD for the BBB and the $?? of the BeBoPr cape still makes the
platform possible at an accessible price range. The construction have however
not been without its issues and compromises must be made to allow for the
ability of being standalone while maintaining a low price.

### Performance Issues
While developing the platform we experience the full capabilities of the BBB and
we are not that confident of the platforms performance. A glaring issue with our
platform is the fact that the BBB is single core, while we don't need amazing
performance for most tasks the single core often results in context switches on
the board making the entire process hold for up to multiple seconds.
Unfortunately the result is an experience where the robot often performs
multiple actions but then suddenly halts mid some action, where everything
including the web cam feed and data logging is halted and will first continue
when the OS switches back to our process.

General performance wise heavy calculation actions such as droplet detection
will be noticeable slow and often results in a very low frame rate produced by
the camera when active. The automatic image stitching using feature points also
is noticeably slow, where an image stitching on a normal laptop will take 1
second on the board it will take 1-1.5 minute. We think again that the
performance issues stems from both the low CPU power but also the lack of
multiple cores that the calculation could be spread on to.

An other issues that we faced with performance is compilation times, as these in
normal use would not be relevant it is not a big issue, but that being said we
experience that a full compilation of OpenCV took 8 hours on the board compared
to the 20 minutes on a laptop computer.

//TODO: Some recorded numbers and a discussion of those

In the specification for the future Evobot [@evobotspec] the BBB is
expected to be the main board, while also introducing more features such as
interfacing with OCT scanners, while some solution might be possible the
performance of the BBB might end op being a problem for the final version of the
Evobot and we can hardly recommend it if the platform have the perform decently.
That being said the BBB is a cheap and nice solution for a hackable board that
allows for easy prototyping, it can still be part of the solution but the
majority of heavy calculation is better suited elsewhere.

### Platform difficulties
For us the combination of the BBB and the BeBoPr proposed a few problems as a
platform for development, while these issues have been manageable they might
become a bigger issue as the platform have to support more hardware and
features. 

Developing natively for an ARM based CPU rather than the usual x86 proposed some
difficulties and we found a few noticeable difference that only workarounds and
patches could solve. The following is a description with solution of each of the
major issues encountered:

* The C++11 standard introduced more functional concepts such as lambda
  expressions, with these the standard also introduced a new threading library
  running a lambda expression in a new thread. However this new threading
  library does not work at all, to work around this we introduced a wrapper of
  the old POSIX pthread C library that takes a lambda expression and spawns it
  in the new thread.
* To detect blobs we are using an extension library for OpenCV called CVBlob
  [@cvblob].  While this library works perfectly well on an x86, it contains an
  infinite loop when compiled for the ARM CPU. This is due to the underlying
  differences between char on ARM and char on x86. The fix itself is rather
  trivial of changing the char to an unsigned char on the ARM version. A
  description of the fix we applying can be found here on the CVBlob issue
  tracker [@cvblob_arm_fix]

When connecting hardware to the BBB we use the BeBoPr cape that is designed to
handle hardware for 3D printing. Most of the hardware can be addressed as usual,
through standard GPIOs on Linux. However the stepper motors only seem to be
accessible through the PRU micro-controllers, so to ease the access we chose to
communicate with the BeBoPr software. This proposed some specific challenges as
the software is designed for 3D printing, this made some of the stepper motors
act differently, it introduced boundry checking and therefor a new for homing in
however not all motors are designed to be home able in the software. So to fixes
these issues we chose to patch the BeBoPr software, removing boundary checks and
making all the motors act similar. With these changes we can handle homing in
our own application, while the process is slower in our solution it is capable
of performing the homing on all axes. The patched code can be found in our code
repository

### Alternative solutions and improvements
For an improved or alternative solution we propose two areas of interest to look
into. The first is the performance issues in our platform, while they are
acceptable for a solution that is to perform the work of the Splotbot they might
become a larger issue if further computational heavy tasks gets introduced. The
second improvement area would be to look for a solution that makes it even
easier for a user to interact with the robot, possibly by removing the need for
a user to have their own computer, the challenges here lies in still keeping the
cost low. Below are a list of some of the alternative solutions we can imaging
would fixes some of the issues faced in our solution:

* A new approach to performing heavy calculations could be to do something
  similar to the old Splotbot and have the user's computer perform the heavy
  calculations. While this would lift some of the heavy duties off of the BBB it
  would be at the cost of having experiments run entirely by the BBB, requiring
  the user to be connected until the experiments completion. It would introduce
  additional complexities in the architecture.
* One BBB might not be enough for doing all of the calculations, so a solution
  could be to introduce more. A cluster of BBBs would allow for distribution in
  the calculation, one BBB could handle the camera and computer vision part, an
  other could control the motors and so on. This solution would also add further
  complexities to the architecture, it would however still maintain the ability
  of the platform to be completely standalone. The expenses would increase with
  each new BBB introduced, but only one of them would be required to have the
  BeBoPr cape.
* To improve on the standalone capabilities of the platform we could introduce a
  touch display to the hardware setup. This touch display could be used to
  display a graphical user interface that allows the users to interact with the
  platform and start experiments. It would however require a further
  investigation of how to make it possible to program experiments using touch
  input rather than our current text based input.


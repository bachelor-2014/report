#Logging experiment data
\label{sec:logging}
<!-- Introduction -->
An important part of creating a platform for running experiments is to ensure
that the user can understand the outcome of the experiment after it has
been run. This chapter deals with the challenge and the implementation of a
logging system for EvoBot, making sure that the user is provided
the needed data in the aftermath of an experiment.

We first introduce the goals of the logging system. We then look at exactly
what experiment data is and how we log it. Then we look at how we structure the
data for future analysis. Finally we discuss the issues faced with the limited
hard disk space on EvoBot.

##Goals
<!-- Logging data, structuring it, storing it, making it available -->
Biological experiments usually involve designing, running, and analysing the
result data of experiments. We set forth the goal of supporting every aspect of
running an experiment. Running an experiment must produce data which can be
analysed at a later point, making gathering data an important feature of EvoBot.
We therefore want that **all data produced by an experiment is
persisted**. In order
to make it easier to analyse the data afterwards, we want to make sure that
**the data is structured in a way that makes it possible to analysise it**, and
following on this that **the data is stored in formats that the user can load
into software that can help with the analysis process**.

Making a tool for supporting the analysis process is another issue which is not
in scope of this project, but the logging of data is core to the EvoBot so we
found it necessary to build it into the prototype.

##What is experiment data
An important part of creating the logging system is to determine exactly what
data and information to log. We look specifically at logging as much data as
possible.  Not only experiment data but also data about the state of EvoBot in
general.  We have broken the different types of data into four categories, all
important to get a total view of an experiment:

- Visible image data such as single images and video
- Data gathered through use of computer vision techniques
- Physical behaviour on the robot, such as movement of carriages and servo
  motors.
- Software metadata, such as component initialization etc. This data is useful
  for debugging the robot at a later point.

A lot of the data gathered is image and video data. Logging of such
types of data must therefore also be supported. This makes it possible
to recall exactly what occurred during the experiment.

##Logging the data
<!-- Explain the logging structure, class diagram -->
Logging all the experiment data in EvoBot required us to alter the core
C++ program. We want the model to support the different target formats that we
use now, and also support the possibilities of extending it in the future.
Therefore it was natural to build the logging framework as a class structure,
as shown in figure \ref{fig:logging_class}. We create an instance of
the loggers needed for every component, allowing it to save the data that it
uses to a supported format. A logger therefore is created with a specific
component type and component name. The entry class is then used to create a new
entry for saving and is parameterised with the specific type of data that needs
to be saved. A logger takes a parameterised entry and persists it.

![Class diagram of the classes responsible for logging data.
\label{fig:logging_class}](images/logging_class.png)

<!-- Videologger, Imagelogger, filelogger-->
In the current implementation we support three different logger types
supporting logging of video, images, and textual data respectively.
Each of the loggers have different target formats and treats the
data differently.

The video logger continuously takes and writes entries with OpenCV images to
a video file from the time it is created until it is closed. The creation of a
new instance of the `VideoLogger` class results in the creation of a new video
file.
The image logger creates a new image file from each entry
given. Both the image logger and video logger store component type,
component name, and activity type in the file name. The file logger is slightly
different as it uses a single CSV file for writing every string entry it receives.
The CSV file format was chosen because of its ease of implementation and
support in programs such as Microsoft Excel [@excel].

<!-- Improvements -->
In the current implementation, the logging is not as extensively used as we
would like, and improvements can be made to include logging more widely in the
program. If the time was available, we would like to ask actual users of the
robotic platform for their logging needs, as we, because of our lack of domain
knowledge, can only guess about both what data to log and how the data is to be
used afterwards.

##Structuring the logged data
<!-- How it is saved, time stamp, csv, video file, images etc. -->
An important part of presenting data to the user is how it is stored and
structured. It is important to make the data as easy to analyse as possible, so
it needs to be structured in such a way that filtering the data to the users
needs are possible. We save four main pieces of metadata useful for filtering:

* **A time stamp**. Every entry in the CSV file, every video file, and every image
  starts with a time stamp. This is useful to distinguish data and in which
  order things have occurred.
* **The component type** which allows the user to filter information by a specific
  component type to get an overview of what the kind of component that have been
  logged.
* **The component name**, as this allows the user to look at data produced by a
  specific component throughout the experiment.
* **An activity type**, allowing the user to filter on specific activity types
  defined by each component. An activity is e.g. 'error', 'data', and 'info'.

The data is saved to a single folder in the file system in multiple files. All
of the video and image files contains the metadata in the name so they can be
filtered accordingly. The entries in the CSV file also contains all of the meta
data as well as the data as a string. We also considered using an embedded
database, but determined that a simple CSV file would be sufficient for the
current version of EvoBot. It could however be a subject for investigation in a
future version.

The current model allows for easy access to all the files in a single folder. It
could however be argued that the structure becomes a problem if multiple
experiments are run without cleaning up the folder. A suggestion for
improvements could be to save data for each individual experiment in a new
folder, it would then be up to the user to say when an experiment ends and when
it starts. We have not looked further into this because of limitations in time.

##Use of limited hard disk space
<!-- The problem -->
The BeagleBone Black on which the EvoBot system runs on only has 16GB
of hard disk space (SD card) available. This limitation 
will potentially be an issue over time, when the logging is expanded or when
more data heavy components are introduced.  While we have not addressed this
issue in our current solution we will in this section document our solution
ideas with potential for future implementation.

<!-- Compression solution -->
Introducing compression and archiving into our current solution will potentially
make the solution more sustainable to future changes. It will not change the fact
that at some point the SD card will run out of space, but it will potentially
accommodate issues with logging more data in an experiment. The solution could
also be combined with a way to move the data to a different storage unit to save
the time needed for transferring the data.

<!-- Off site storage -->
This leads us to the possible introduction of another storage media. This could
e.g. be:

* Using an USB storage medium, such as a hard drive. Here there are potential
  for swapping hard drives when one is filled with data. The biggest downside is
  the physical maintenance this solution would require. A feature of this
  solution would be that getting all the data move elsewhere would be as easy as
  unplugging the hard drive.
* Using cloud storage. Here the idea would be that the EvoBot should be
  connected to the internet via a high speed connection. This would allow the
  EvoBot to gradually move the data from the BeagleBone Black to a remote cloud storage. The
  problem here is the dependency on the speed of the internet connection, the
  upside is however the mobility and availability of the data world wide.

A notable thing is that both solutions have an added cost to the entire
solution. Picking a solution would be a decision to be made based on further
investigation of the needs of the laboratories in question.

##Summary
In order to make it possible for EvoBot to save data created during an
experiment we introduced a logging system. The system had to be capable of
saving all the needed data from an experiment in a structured way and storing it
in formats that allows the user to analyse it at a later stage.

First we established that there are four categories of data in EvoBot:
Image/video data, computer vision data, physical behaviour data and software
metadata. To support all of the different data we introduced a logger class
structure that include three different kind of loggers for video, image and file
logging. Data is then structured using files in the file system and metadata.
The metadata includes a time stamp, component type, component name, and an
activity type.

Finally we discussed the issues faced with limited hard disk space on EvoBot. We
suggested the possibility of compressing the data and then moving it off the
board, to either an external hard drive or a remote server.

The current implementation is in many ways crude and must be improved
in order for the logging system to be production ready.

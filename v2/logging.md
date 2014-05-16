#Logging experiment data
<!-- Introduction -->
An important part of creating a platform for running experiments is to ensure
that the user can understand the experiment's outcome after the experiment have
been run. This chapter deals with the challenge and the implementation of a
logging system for the EvoBot. Making sure that the EvoBot will provide the user
with the wanted data in the aftermath of an experiment.

In this chapter we first introduce the goals of the logging system. We then look
at exactly what experiment data is and how we log it. Then we look at how we
structure the data for future analysis and finally we discuss the issues faced
with the limited space on the EvoBot.

##The goal
<!-- Logging data, structuring it, storing it, making it available -->
Biological experiments usually involves making experiments and analysing the
experiment and the results. EvoBot's goal is to support every aspect of running
automated experiments and therefor gathering data to understand the experiment
and result is an important feature of the EvoBot. For the initial logging system
of the EvoBot we looked at the basic goals EvoBot have to atleast fulfill to
support the analysis of experiments: 

* All the data needed from an experiment is saved.
* That the data is structured in a way that makes it possible to analyse it.
* That the data is stored in formats that the user can load into software that
  can help with the analysis process.

Making a tool for supporting the analysis process is an other issue and will not
be discussed in this chapter, but the logging of data is core to the EvoBot so we
wanted to build it into our solution.

##What is experiment data
An important part of our logging system is to determine exactly what data and
information to log. We look specifically at logging as much data as possible.
Not only experiment data but also data about the state of EvoBot in general.  We
have broken the different types of data into four categories, all important to
get a total view of an experiment:

- Visible image data such as single images and video
- Computer vision related data, droplet speed etc.
- Physical behaviour on the robot, such as movement of the xy axis and servo
  motors.
- Software meta data, such as component initialization etc. This data is useful
  for debugging the robot at a later point.

An important part of our view of data in the EvoBot software is that we want to
split data up on component type and component, so each component creates it's
own entries which we can later filter from the overall data set to focus on what
exactly a component is doing. While also being able to filter on a specific
component type.

Image and video data is especially essential to our logging system as even with
computer vision our software will not be able to obtain every detail of what is
happening in the image. We therefor want to ensure that at any time camera data
is available it will be saved. That is not to say that textual based data isn't
just as valuable, being able to create statistic from number is a powerful tool.

##Logging the data
<!-- Explain the logging structure, class diagram -->
Logging all the experiment data in EvoBot required us to build it into the core
C++ program. We want the model to support the different target formats that we
use now, and also support the possibilities of extending it in the future.
Therefor it was natural to build the logging framework as a class structure as
shown in figure \ref{fig:loggin_class}. In our system we create an instance of
the loggers needed for every component, allowing it to save the data that it
uses to a supported format. A logger therefor is created with a specific component
type and component name. The entry class is then used to create a new entry for
saving and is parameterised with the specific type of data that needs to be
saved, a logger will take a specific kind of entry and persists it.

![Class diagram for logging structure
\label{fig:logging_class}](images/logging_class.png)

<!-- Videologger, Imagelogger, filelogger-->
In our current implementation we support three different kind of formats video,
images and files. Each of the loggers have different target formats and will
treat the data differently. The video logger will continuously take and write
entries with OpenCV images to a video file from the time it is created until it
is closed, making a new video logger will yield a new video file. An image
logger will create a new image file from each entry given.  Both the image
logger and video logger will store component type, component name and activity
type in the file name. The file logger is slightly different as it will use a
CSV file for writing every string entry it receives. The CSV file format was
chosen because of it's ease of implementation and support in programs such as
Microsoft Excel [@excel].

<!-- Improvements -->
Currently in EvoBot the logging is integrated into multiple components and we
log data such as videos, scanned images and some data. The logging is however
not as extensively used as we would like and improvements can be made to include
logging more widely in the program. We would also like to have more options for
the user to decide how data should be logged, requiring different kind of
loggers, possibly allowing the user to pick options such as databases etc.

##Structuring the logged data
<!-- How it is saved, time stamp, csv, video file, images etc. --> An important
part of presenting data to the user is how it is stored and structured. It is
important to make the data as easy to analysis as possible, so it needs to be
structured in a such as way that filtering the data to the users needs are
possible. We save four main pieces of meta data useful for filtering:

* A time stamp. Every entry in the CSV file, every video file and every image
  starts with a time stamp. This will be useful to distinguish data and in which
  order things have occurred.
* The component type which allows the user to filter information by a specific
  component type to get an overview of what the kind of component have logged.
* The component name, this will allow the user to look at data produced by a
  specific component throughout the experiment.
* An activity type, allowing the user to filter on specific activity types
  defined by each component.

The data is saved to the disc in multiple files. The structure of these are a
single folder in which every file gets stored. All of the video and image files
contains the meta data in the name so they can be filtered accordantly. The
entries in the CSV file also contains all of the meta data as well as the data
as a string.

The current model allows for easy access to all the files in a single folder, it
could however be argued that the structure becomes a problem if multiple
experiments are run without cleaning up the folder. A suggestion for
improvements could be to save data for each individual experiment in a new
folder, it would then be up to the user to say when an experiment ends and when
it starts.

##Use of limited hard disk space
<!-- The problem -->
The Beagle Bone Black (BBB) on which the EvoBot system runs, there is only 16GB
of hard disc (SD Card) space available currently. This limited hard disc space
will potentially be an issue over time, when the logging is expanded or when
more data heavy components are introduced.  While we have not addressed this
issue in our current solution we will in this section document our solution
ideas with potential for future implementation.

<!-- Compression solution -->
Introducing compression and archiving into our current solution will potentially
make the solution more sustainable to future changes. I won't change the fact
that at some point the SD will run out of space, but it will potentially
accommodate issues with logging more data in an experiment. The solution could
also be combined with a way to move the data to a different storage unit to save
the time needed for transferring the data.

<!-- Off site storage -->
This leads us to introducing an other storage place.  An important part of any
storage scheme would be to first store the data locally on the BBB and then move
it to some place else, ensuring that data is not lost in the transfer. We see
two options available.

* Using an USB storage medium, such as a hard drive. Here there are potential
  for swapping hard drives when one is filled with data. The biggest downside is
      the physical maintenance this solution would require. A feature of this
      solution would be that getting all the data move elsewhere would be as
      easy as unplugging the hard drive.
* Using cloud storage. Here the idea would be that the EvoBot should be
  connected to the internet via a high speed connection. This would allow the
  EvoBot to gradually move the data from the BBB to a remote cloud storage. The
  problem here is the dependency on the speed of the internet connection, the
  upside is however the mobility and availability of the data world wide.

A notable thing is also that both solutions have an added cost to the entire
solution. Picking a solution would be a decision to be made based on further
investigation of the needs of the laboratories in question.

##Summary
Making it possible for the EvoBot to save data created during an experiment we
introduced a logging system. The system had to be capable of saving all the
needed data from an experiment in a structured way and storing it in formats
that allows the user to analyse it at a later stage.

First we established that there are four categories of data in the EvoBot
image/video data, computer vision data, physical behaviour data and software
meta data. To support all of the different data we introduced a logger class
structure that include three different kind of loggers for video, image and file
logging. Data is then structured using files in the file system and meta data.
The meta data includes a time stamp, component type, component name and an
activity type.

Finally we discussed the issues faced with limited hard disk space on the
EvoBot. We suggested the possibility of compressing the data and then moving it
off the board, to either an external hard drive or a remote server.

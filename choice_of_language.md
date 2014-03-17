
#Choice of programming language to run on the BeagleBone Black
At the core of our setup lies a piece of software that must interact directly
with the robot, this software should be written in a language that allows us to
interact directly with hardware such as motor, as well as analyse images and
generally do the computations needed to smoothly execute experiments. 

##The Problem
To figure out which programming language will suite our application best we must
first define a few key features that weigh in when choosing the language.
Following are a list of the most important features that we have identified:

* **BeagleBone Support**
* **OpenCV Support**
* **Performance**
* **Language Abstractions**
* **Prior Experience**
* **Integration possabilities**

To properly asses a programming language and environment, each of the above
features can be judge. Having BeagleBone and OpenCV support are the must crucial
and any language that do not have those cannot be used. The rest of the list
consists mostly of features that can be assessed and compared, to find the most
optimal solution.

##Choosing the programming language

* Python
* C
* C++
* Mono (C\#, F\#)
* JVM (Java, Scala etc.)
* BoneScript

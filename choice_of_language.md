
#Choice of programming language to run on the BeagleBone Black
At the core of the setup lies a piece of software that must interact directly
with the robot, this software needs be written in a language that allows
interaction directly with hardware such as motor, analyse images and generally
do the computations needed to smoothly execute experiments. 

##The Problem
When choosing a programming language it is not just about the language it self,
it is more about the entire platform and support surrounding the language. Which
programming language is best suited for core application?  To answer this
question we must first define a few key features that weigh in when choosing the
language.  Following are a list of the most important features identified:

* **BeagleBone Support** is essential to the application as this is the platform
  we are going to run it on. The BeagleBone is running an ARM processor and the
  Ängstrom Linux, any language that is not support under these conditions will
  not be suitable.
* **OpenCV Support** is crucial for the computer vision part of the application.
  It is important that any language chosen can work with OpenCV.
* **Performance** will be an important factor. The application will be running
  in an environment with a low amount of RAM (512mb) and a small CPU (1.2Ghz
  ARM), making any extra overhead created by the language a possible issue.
* **Integration possabilities**
* **Language Abstractions** are not the most important factor, but having some
  high level abstractions in the language could make it easier to structure and
  express the problems at hand.
* **Prior Experience**

To properly asses a programming language and environment, each of the above
features can be judged. Having BeagleBone and OpenCV support are the most
crucial and any language that do not fulfill those cannot be used. The rest of
the list consists mostly of features that can be assessed and compared, to find
the most optimal solution.

##Choosing the programming language

* Python
* C
* C++
* Mono (C\#, F\#)
* JVM (Java, Scala etc.)
* BoneScript

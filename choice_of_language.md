
#Choice of programming language to run on the BeagleBone Black
At the core of the setup lies a piece of software that must interact directly
with the robot, this software needs be written in a language that allows
interaction directly with hardware, analyse images and generally do the
computations needed to smoothly execute experiments. 

##The Problem
When choosing a programming language it is not just about the language it self,
it is more about the entire platform and support surrounding the language. Which
programming language is best suited for core application?  To answer this
question we must first define a few key features that weigh in when choosing the
language.  Following are a list of the most important features identified:

* **BeagleBone support** is essential to the application as this is the platform
  we are going to run it on. The BeagleBone is running an ARM processor and the
  Ångström Linux, any language that is not support under these conditions will
  not be suitable.
* **Communicating with hardware** //TODO explain
* **OpenCV support** is crucial for the computer vision part of the application.
  It is important that any language chosen can work with OpenCV.
* **Performance** will be an important factor. The application will be running
  in an environment with a low amount of RAM (512MB) and a small CPU (1.2Ghz
  ARM), making any extra overhead created by the language a possible issue.
  //TODO: Check specs
* **Language abstractions** are not the most important factor, but having some
  high level abstractions in the language could make it easier to structure and
  express the problems at hand.

To properly asses a programming language and environment, each of the above
features must be judged. Having BeagleBone and OpenCV support are the most
crucial and any language that do not fulfill those cannot be used. The rest of
the list consists mostly of features that can be assessed and compared, to
determine the most optimal solution.

##Choosing the programming language
When deciding which programming languages to asses we must first limit our scope
to a few possible candidates, as looking into every possible programming
language out there would be infeasibly. Following is the list of programming
languages we have chosen to asses, they were mostly selected with OpenCV support
in mind.

* Python, a high level scripting language. The Python runtime comes with almost
  any Linux distribution, this is also the case with Ångström. Python is often
  used in software related to 3D printers, which makes it likely that we can use
  it to control hardware. The support for OpenCV in Python is done officially by
  the OpenCV project, but most of the libraries are automatically generated, the
  documentation are therefor often sub-par. As a scripting language using JIT
  compilation Python's performance is sub-par and memory usage high. The
  language itself provides a high level of abstraction with both object
  orientated and functional features, the lag of type checking before execution
  can at times create issues if one is not careful.

* C, a low level native compiled language. C can be compiled and run on almost,
  in our case we would use the GCC ARM based compiler available to the Ångström
  Linux distribution, it should also be possible to connect with hardware as
  most drivers are written in C/C++. The C bindings for OpenCV are only available
  for OpenCV version 1 features and is deprecated and only supported for
      backward compatibility. C is a very low level language with manual memory
      management, allowing for extreme optimisation in speed and memory usage,
      this however comes with the downside that the language is much harder to
      keep safe and memory leaks can easily be introduced.

* C++, a natively compiled object orientated language. C++ as with C is
  available on most platforms and can be compile using GCC ARM compiler. OpenCV
  is written in C++ making the support and documentation for C++ far superior
  than with any other language. The C++ compiler are often very effective at
  optimising for speed and with no garbage collection has less overhead but
  somewhat manual memory management, C++ code will mostly perform like C code,
  it can however be harder to reason about the runtime speed than with C code.
  C++ is an object orientated language and in C++11 it also contains functional
  features. 
  
* Mono (C\#, F\#) a garbage collect virtual machine with compilers such as C\#
  and F\#. //TODO: Explain

* JVM (Java, Scala etc.) //TODO: Explain

* BoneScript, is the JavaScript based language for the BeagleBone with an
  extended library for interacting withe the BeagleBones hardware. There seem to
  be no official binding from BoneScript to OpenCV, it is however possible with
  unofficial binding for NodeJS to communicate with OpenCV which might be an
  option. Performance wise BoneScript/JavaScript is a scripting language and
  like Python has bad performance and general memory overhead.

It can argued than any of the above language would make it feasibly to implement
our robot, so choosing the language mostly comes down to weighing the ups and
downs of each. C can mostly be excluded due to the lack of OpenCV support,
Python is slow and could make it hard to do real time computations, Mono and JVM
also have an overhead and no official OpenCV support. The choice then lands on
C++, with the best OpenCV support, possibilities of good performance and similar
hardware capabilities to C with a higher abstraction level.

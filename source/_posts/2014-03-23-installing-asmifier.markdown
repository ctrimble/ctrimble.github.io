---
layout: post
title: "Installing ASMifier"
date: 2014-03-23 08:13:57 -0700
comments: true
categories: [bytecode, Java 8, ASM, Signal]
---
With the release of Java 8, it is time to figure out the impact of the new language features on some of
my projects.  To get a better idea of what is going on in the bytecode, I have been transforming some compiled classes
into ASM class visitors, using ASMifier.  I will be sharing those in some later posts, but I thought I would 
get started with some instruction on how to install and use ASMifier to look at bytecode.

## So, what is ASM and ASMifier

For those not familure with [ASM](http://asm.ow2.org/), it is a bytecode processing library.  It is
lower level than other bytecode inspection/generation tools I have used, but it gives you a lot of control over what is
going on in class files that you generate.  It is great for transforming existing bytecode or generating bytecode
from scratch.

ASMifier is a tool that transforms a class file into the source code that would generate that class using ASM's APIs.
This is really convienent for building class transforms, since you can easily see the class calls that are
going to be made by visiting a particular class file.  When I am creating class transforms, my workflow usually looks 
like this:

1. create an example of the transform's input and output in java
2. compile and run asmifier on both classes
3. create a transform that maps the input example to the output example.

This process has worked well for me and lends itself to a generalized JUnit test class.  Perhaps we can cover that in
a future post.

## Getting ASMifier Installed

ASMifier is located in the asm-util.jar file and requires the asm.jar file to operate.  ASM provides an all jar,
so an easy way to get ASMifier running is to get the all jar on the path, prepended a shell script to it,
and mark it as executable.  Assuming that `~/bin` is on your path, these commands will add an `asmifier` command
to your shell.

    printf '#!/bin/sh\n\nexec java -classpath "$0" org.objectweb.asm.util.ASMifier "$@"\n\n' > ~/bin/asmifier
    curl 'http://central.maven.org/maven2/org/ow2/asm/asm-all/5.0.1/asm-all-5.0.1.jar' >> ~/bin/asmifier
    chmod +x ~/bin/asmifier

Now, we can get some usage information by typing `asmifier` in the terminal.

    asmifier
    Prints the ASM code to generate the given class.
    Usage: ASMifier [-debug] <fully qualified class name or class file name>

## Using ASMifier

Now that we have ASMifier installed, let's run a quick transform on a simple "Hello World!" class file.  To begin, we
will need some compiled source.  Write this class file into a file called HelloWorld.java.

{% include_code HelloWorld.java lang:java asm/HelloWorld.java %}

Then compile it with javac, creating HelloWorld.class.

    javac HelloWorld.java

Now we can run asmifier on this class file, and see the method calls that will be made when visiting it.

    asmifier HelloWorld.class > HelloWorldDump.java

{% include_code HelloWorldDump.java lang:java asm/HelloWorldDump.java %}

**Note:** Unfortunately, package `org.objectweb.asm.attrs` was removed in ASM 5.0, but this was not reflected in the ASMifier tool, so you will
need to remove that import if you want to compile this generated file.

That is it for this post.  In some future articles, we will look at the way lambdas and method references are represented in
ASM class visitors.  Stay tuned.

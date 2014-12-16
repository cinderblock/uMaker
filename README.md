# uMaker - Makefile and tools for embeded C/C++ projects

This set of makefiles is intended to be used by all embeded projects. Each file is inteded to be included from a main Makefile when its features are needed while providing as many defaults as possible.

## Conventions

These tools have very strict naming requirements. Things will break if you forget a /.

### Variable names

All variables that are used almost exclusively by certain tools have a namespace prefix to keep things separate. There are a couple explicit exceptions to this for variables we expect the make Makefile to set. (CFILES, CPPFILES, ...)

### Paths

All paths to directories must end with a '/'.

### Variable defaults

Most variables have sane defaults set. If you need to ovveride them or set extras, you can do so directly in your main Makefile. Nearly all assignments in make-tools are done with ?=, which allows you to define your own versions instead. Many variables also have an xxxxx\_EXTRA variable that they already include and you just need to set.

## Recommended Reading

You should be able to get by just copying and editing the `Makefile.sample`. However, if you are interesting in understanding what is going on, keep reading.

### GCC Build Conventions

In general, you should understand the standard chain of gcc commands, input and output files, and includes directories.

Some points to remember:

 - GCC preprocessor handles all the #directives and basically creates one temporary C/C++ file that has no #directives
 - You don't need to use `.` as an include dir (`-I.`)
 - GCC doesn't make folders that it would need to be there for build to succeed

file1.c		-> file1.c.o
file2.cpp	-> file2.cpp.o
lib.c		-> lib.c.o
lib.c.o		-> lib.a

file1.c.o + file2.cpp.o + lib.a -> out.elf

### Make Features

You should be aware of how makefiles work. However, a few features that I use in particular are:

 - Conditional assignment operators
 - Filename functions (`$(dir ...)`)
 - Substring functions (`$(VAR:find=replace)`)
 - Implicit Rules
 - Automatic Variables

Points to remember:

 - Variables are just strings that get text replaced when they are used
 - Variables are expanded at the time they are used
 - Variables are "used" in only certain places. Especially:
     - Explicit expansion: `:=`
     - Target [dependency] declaration - This is why variables are usually before targets
     - `include` directives

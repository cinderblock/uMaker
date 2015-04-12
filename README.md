# µMaker  - Tools for embedded C/C++ projects in Makefiles

This set of makefiles is intended to be used by all embedded projects. Each file in `tools/` is intended to be included from a main Makefile in your project. Each loads a particular set of features. You should include the ones you want, and not the ones you done.

Some sample Makefiles are provided for a couple systems.

# Important

This is still a Work In Progress.

I'm still flushing out the main interfaces and project standards.

This readme may not be quite up to date. See comments for most accurate documentation.

## Getting Started

 - Copy one of the sample Makefiles to your project dir and rename it to `Makefile`
 - Set the var `UMAKER` to the uMaker directory, so that the includes work
 - Set the `C` and/or `CPP` vars in your new `Makefile`
 - Select which uMaker tools are included by including the files you want

## Conventions

Some guidelines to follow using the tools.

### Variable names

All variables should have a namespace prefix to keep things separate. There are a couple exceptions to this in the current tools where appropriate.

Most makefiles use uppercase variable names. This is how I've started this project's development, but I'm not seeing a good reason to continue using only uppercase variable names. I'm going to start converting them to CamelCase to ease readability and writeability.

### Paths

All paths to directories must end with a '/'.

*Exception: for cleanliness, includes that are passed to gcc do not need them*

### Variable defaults

Most variables have sane defaults set. If you need to override them or set extras, you can do so directly in your main Makefile. Nearly all assignments in make-tools are done with ?=, which allows you to define your own versions instead. Many variables also have an xxxxx\_EXTRA variable that they already include and you just need to set.

## Recommended Reading

You should be able to get by just copying and editing the `Makefile.xxxxx.sample` files. However, if you are interesting in understanding what is going on, keep reading.

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

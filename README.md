# µMaker  - Tools for embedded C/C++ projects in Makefiles

This set of makefiles is intended to be used by all embedded projects. Each file in `tools/` is intended to be included from a main Makefile in your project. Each loads a particular set of features. You should include the ones you want, and not the ones you done.

Some sample Makefiles are provided for a couple systems.

# Important

This is still a ***Work In Progress***.

I'm still flushing out the main interfaces and project standards.

This readme may not be quite up to date. See comments for most accurate documentation.

## Getting Started

 - Copy one of the sample Makefiles to your project dir and rename it to `Makefile`
 - Set the var `uMakerPath` to the uMaker directory, so that the includes work
 - Set the `C` and/or `CPP` vars in your new `Makefile` to compile your C/C++ files
 - Select which uMaker tools are included (only include the ones you use)

## Modules *aka: tools*

Descriptions of modules and how to use them

### FreeRTOS

Add support for FreeRTOS to your project. This module enables compilation of their
sources and automatically copies the `portmacro.h` and `port.c` files to your
project.

Set `FREERTOS_BASEPORT` to one of the folder names in `FreeRTOS\FreeRTOS\Source\portable\GCC`.
This module will copy both `port.c` and `portmacro.h` to your project. `port.c`
will be renamed and placed according to `FREERTOS_PORTDEFS_FILE`. `portmacro.h`
will keep its filename but be put into the folder `FREERTOS_PORTINC`.

You will also need to create a file named `FreeRTOSConfig.h` and put that in the
`FREERTOS_PORTINC` folder. Samples of `FreeRTOSConfig.h` are in the FreeRTOS demo
folders.

### Arduino

Add support for an Arduino core. By default, only works with the AVR core.

Does **not** handle Arduino Libraries. To use Arduino Libraries, copy them into
your project's source folder and add them to the list of CPP files to build. This
is required because Arduino's library "standard" is poorly defined and too
inconsistent. Therefore, instead of trying to write a crazy uMaker module to
support all of the possible libraries, we're forcing users to copy code and take
ownership of the libraries they use.

### mkdir

This module reads the variable `AUTO_GENERATED_FILES` and makes sure each
generated file depends on a target builds the destination folder when needed.

### makeflags

This module sets some useful default make command line arguments. In particular,
it disables verbosity. It may also run multiple parallel jobs.

### build

This is a core module that does the main compilation of your C/C++ source files.
It also links object files into the final output `.elf` and `.hex` files.

### assembly

This module basically runs the same commands as `build` but only until intermediate
assembly `.asm` files are built. The intention is to allow inspection of compiled
source files to check for low level issues.

## Conventions

Some guidelines to follow using the tools.

### Variable names

All variables should have a namespace prefix to keep things separate. There are a couple exceptions to this in the current tools where appropriate.

Most makefiles use uppercase variable names. This is how I've started this project's development, but I'm not seeing a good reason to continue using only uppercase variable names. I'm going to start converting them to CamelCase to ease readability and writeability.

### Paths

Variables that end in `Path` must end with a `/` or be empty.

Variables that end in `Dir` must not end with a `/` nor be empty.

### Variable defaults

Most variables have sane defaults set. If you need to override them or set extras, you can do so directly in your main Makefile. Nearly all assignments in make-tools are done with ?=, which allows you to define your own versions instead.

Many variables also incorporate the same variable but with `Extra` suffixed so that values can be trivially added

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

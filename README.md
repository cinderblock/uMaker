# Make Tools - Standard tools for embeded C/C++ projects

This set of makefiles is intended to be used by all embeded projects. Each file is inteded to be included from a main Makefile when its features are needed while providing as many defaults as possible. It will even support building and linking in external libraries.

## Conventions

These tools have very strict naming requirements. Things will break if you forget a /.

### Variable names

All variables that are used almost exclusively by certain tools have a namespace prefix to keep things separate. There are a couple explicit exceptions to this for variables we expect the make Makefile to set. (CFILES, CPPFILES, ...)

### Paths

All paths to directories must end with a '/'.

### Variable defaults

Most variables have sane defaults set. If you need to ovveride them or set extras, you can do so directly in your main Makefile. Nearly all assignments in make-tools are done with ?=, which allows you to define your own versions instead. Many variables also have an xxxxx\_EXTRA variable that they already include and you just need to set.

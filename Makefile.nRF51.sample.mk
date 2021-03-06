## Creator: Cameron Tacklind
##
## This is the main Makefile for building uC projects. It should only be edited
## to add generic and project specific features. Ideally, there are no real targets
## here. Just variables, or overrides, that the included helper makefiles will use.

# List of c file basenames to build
cNames =

# List of cpp file basenames to build
cppNames = main Board test/Test

all: build #run

run: nrfjprog-flash

uMakerPath = uMaker/

# Load local settings
-include local.$(shell hostname).mk

include $(uMakerPath)tools/paths.mk

# Generate list of source files from basenames
include $(uMakerPath)tools/source.mk

# Force setting certain make flags
#include $(uMakerPath)tools/makeflags.mk

# Optional configuration testing for development
include $(uMakerPath)tools/checks.mk

# Defs for our setup
include $(uMakerPath)vars/nRF51.mk

# Include some common nRF51 SDK tools
include $(uMakerPath)tools/nRF51SDK/toolchain.mk
include $(uMakerPath)tools/nRF51SDK/includes.mk

# Library targets
#include $(uMakerPath)tools/FreeRTOS.mk

# Build targets
include $(uMakerPath)tools/build.mk

# Programmer targets
#include $(uMakerPath)tools/dfu.mk
include $(uMakerPath)tools/nrfjprog.mk

# Directory creation targets
include $(uMakerPath)tools/mkdir.mk

.PHONY: all run

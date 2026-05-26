# Minimal uMaker AVR project used as a build-system smoke test in CI.
# Lives at tests/avr-min/ inside the uMaker repo itself.

cppNames = main

F_CPU  = 16000000UL
MCU    = atmega32u4
TARGET = avr-min

all: build

# Find uMaker two directories up (we are at tests/avr-min/).
uMakerPath = ../../

include $(uMakerPath)tools/paths.mk
include $(uMakerPath)tools/source.mk
include $(uMakerPath)tools/checks.mk
include $(uMakerPath)vars/AVR.mk
include $(uMakerPath)tools/build.mk
include $(uMakerPath)tools/mkdir.mk

.PHONY: all

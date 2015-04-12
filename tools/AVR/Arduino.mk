# This makefile allows you to use Arduino's main features from a conventional C/C++
# project. This does not use the standard Arduino Makefile and thus might have some
# minor issues, but I will do my best to make all the features work. This instead
# enables MUCH faster builds and more portable configurations.

# If you'd like to use the Arduino Libraries like EEPROM and SoftwareSerial, see
# the file ArduinoLibraries.mk

# Location of main Arduino folder.
Arduino_BaseDir ?= C:/Arduino/

Arduino_CoreDir ?= $(Arduino_BaseDir)hardware/arduino/avr/cores/arduino/


Arduino_Auto_cppSources = main Print Stream Tone WMath WString

# C++ helpers
Arduino_Auto_cppSources += abi new

# Sources for USB
Arduino_Auto_cppSources += USBCore CDC HID

# Other sources
Arduino_Auto_cppSources += IPAddress

# HardwareSerial sources
Arduino_Auto_cppSources += HardwareSerial.cpp
Arduino_Auto_cppSources += HardwareSerial0.cpp
Arduino_Auto_cppSources += HardwareSerial1.cpp
Arduino_Auto_cppSources += HardwareSerial2.cpp
Arduino_Auto_cppSources += HardwareSerial3.cpp

# Source file names to build
Arduino_cppSources ?= $(Arduino_Auto_cppSources)

# Some of Arduino's sources are in plain old C
Arduino_Auto_cSources = hooks WInterrupts wiring wiring_analog wiring_digital wiring_pulse wiring_shift

# The real list of cSource names to build
Arduino_cSources ?= $(Arduino_Auto_cSources)

# List of source files to build with complete paths
Arduino_Files ?= $(Arduino_cppSources:%=$(Arduino_CoreDir)%.cpp) $(Arduino_cSources:%=$(Arduino_CoreDir)%.c)

# Name to give certain files/dirs while building
Arduino_BuildName ?= Arduino

# Output filename, missing path
Arduino_ArchiveFilename ?= $(Arduino_BuildName).a

Arduino_ArchiveFilenameFull ?= $(BLD_LIBDIR)$(Arduino_ArchiveFilename)

Arduino_BuildDir ?= $(BLD_DIR)$(Arduino_BuildName)/

Arduino_ObjectFiles ?= $(Arduino_Files:$(Arduino_CoreDir)%=$(Arduino_BuildDir)%.o)

AUTO_LIB += $(Arduino_ArchiveFilenameFull)

Arduino_makeTarget ?= $(Arduino_BuildName)

AUTO_INC += $(Arduino_CoreDir)

Arduino_GCC_BuildFlags_Final ?= $(BLD_GCCFLAGS_FINAL)

Arduino_GXX_BuildFlags_Final ?= $(BLD_GXXFLAGS_FINAL)

##### Targets

$(BLD_DIR)%.c.o: $(Arduino_BaseDir)%.c
	$(ECO) "Arduino C	$@"
	$(BLD_GCC) $< -o $@ -c $(Arduino_GCC_BuildFlags_Final)

	$(BLD_DIR)%.cpp.o: $(Arduino_BaseDir)%.cpp
		$(ECO) "Arduino C++	$@"
		$(BLD_GXX) $< -o $@ -c $(Arduino_GXX_BuildFlags_Final)

$(Arduino_ArchiveFilenameFull): $(Arduino_ObjectFiles)
	$(ECO) "Arduino AR	$@"
	$(BLD_ARR) $@ $(Arduino_ObjectFiles)

$(Arduino_ArchiveFilenameFull) $(Arduino_ObjectFiles) : $(MAKEFILE_LIST)

$(Arduino_makeTarget): $(Arduino_ArchiveFilenameFull)

.PHONY: $(Arduino_makeTarget)
.PRECIOUS: $(Arduino_ObjectFiles)
.SECONDARY: $(Arduino_ArchiveFilenameFull)

# Explicitly include all our build dep files
Arduino_depFiles ?= $(Arduino_ObjectFiles:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(Arduino_depFiles)

AUTO_GENERATED_FILES += $(Arduino_ArchiveFilenameFull) $(Arduino_ObjectFiles) $(Arduino_depFiles)

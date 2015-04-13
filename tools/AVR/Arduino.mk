# This makefile allows you to use Arduino's main features from a conventional C/C++
# project. This does not use the standard Arduino Makefile and thus might have some
# minor issues, but I will do my best to make all the features work. This instead
# enables MUCH faster builds and more portable configurations.

# If you'd like to use the Arduino Libraries like EEPROM and SoftwareSerial, see
# the file ArduinoLibraries.mk

# Location of main Arduino folder.
Arduino_BaseDir ?= C:/Arduino

# The main arduino directory thta contains all of the source files and includes
Arduino_CoreDir ?= $(Arduino_BaseDir)/hardware/arduino/avr/cores/arduino

# Change to include the correct variant directory
Arduino_Variant ?= mega

# Extra needed included for `pins_arduino.h`
Arduino_VariantsDir ?= $(Arduino_BaseDir)/hardware/arduino/avr/variants/$(Arduino_Variant)

# The standard Arduino base source files
Arduino_Auto_cppSources = main Print Stream Tone WMath WString

# C++ helpers
Arduino_Auto_cppSources += abi new

# Sources for USB
Arduino_Auto_cppSources += USBCore CDC HID

# Other sources
Arduino_Auto_cppSources += IPAddress

# HardwareSerial sources
Arduino_Auto_cppSources += HardwareSerial
Arduino_Auto_cppSources += HardwareSerial0
Arduino_Auto_cppSources += HardwareSerial1
Arduino_Auto_cppSources += HardwareSerial2
Arduino_Auto_cppSources += HardwareSerial3

# Source file names to build
Arduino_cppSources ?= $(Arduino_Auto_cppSources)

# Some of Arduino's sources are in plain old C
Arduino_Auto_cSources = hooks WInterrupts wiring wiring_analog wiring_digital wiring_pulse wiring_shift

# The real list of cSource names to build
Arduino_cSources ?= $(Arduino_Auto_cSources)

# List of source files to build with complete paths
Arduino_Files ?= $(Arduino_cppSources:%=$(Arduino_CoreDir)/%.cpp) $(Arduino_cSources:%=$(Arduino_CoreDir)/%.c)

# Name to give certain files/dirs while building
Arduino_BuildName ?= Arduino

# Output filename, missing path
Arduino_ArchiveFilename ?= $(Arduino_BuildName).a

# Output filename, with path
Arduino_ArchiveFilenameFull ?= $(BLD_LIBDIR)$(Arduino_ArchiveFilename)

# Directory the .o files will be saved to
Arduino_BuildDir ?= $(BLD_DIR)$(Arduino_BuildName)

# List of all object files to build
Arduino_ObjectFiles ?= $(Arduino_Files:$(Arduino_CoreDir)/%=$(Arduino_BuildDir)/%.o)

# Add our output archive to the list of automatically included libs
AUTO_LIB += $(Arduino_ArchiveFilenameFull)

# Target to use at the command line to run this module
Arduino_makeTarget ?= $(Arduino_BuildName)

# Add Arduino's includes to the include path
AUTO_INC += $(Arduino_CoreDir) $(Arduino_VariantsDir)

# All of the flags used to build the C source files, nearly
Arduino_GCC_BuildFlags_Final ?= $(BLD_GCCFLAGS_FINAL)

# All of the flags used to build the C++ source files, nearly
Arduino_GXX_BuildFlags_Final ?= $(BLD_GXXFLAGS_FINAL)

##### Targets

$(BLD_DIR)%.c.o: $(Arduino_BaseDir)/%.c
	$(ECO) "Arduino C	$@"
	$(BLD_GCC) $< -o $@ -c $(Arduino_GCC_BuildFlags_Final)

$(BLD_DIR)%.cpp.o: $(Arduino_BaseDir)/%.cpp
	$(ECO) "Arduino C++	$@"
	$(BLD_GXX) $< -o $@ -c $(Arduino_GXX_BuildFlags_Final)

# Target to build the final output archive of this module
$(Arduino_ArchiveFilenameFull): $(Arduino_ObjectFiles)
	$(ECO) "Arduino AR	$@"
	$(BLD_ARR) $@ $(Arduino_ObjectFiles)

# Make all of our output files depend on all of the loaded "make" files
$(Arduino_ArchiveFilenameFull) $(Arduino_ObjectFiles) : $(MAKEFILE_LIST)

# Create an easy target to call from the command line
$(Arduino_makeTarget): $(Arduino_ArchiveFilenameFull)

# Mark the targets that don't create output files
.PHONY: $(Arduino_makeTarget)

	# Intermediate build files
.PRECIOUS: $(Arduino_ObjectFiles)

	# Final build files
.SECONDARY: $(Arduino_ArchiveFilenameFull)

# Explicitly include all our build dep files
Arduino_depFiles ?= $(Arduino_ObjectFiles:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(Arduino_depFiles)

AUTO_GENERATED_FILES += $(Arduino_ArchiveFilenameFull) $(Arduino_ObjectFiles) $(Arduino_depFiles)

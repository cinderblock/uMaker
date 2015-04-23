# This makefile allows you to use Arduino Libraries. It requires the Aruino.mk file
# to have been included previously.

# List of directories containing Arduino Libraries. We will
ArduinoLibraries_Dirs ?= $(Arduino_BaseDir)hardware/arduino/avr/libraries $(ArduinoLibraries_ExtraDirs)

# Libraries to build
ArduinoLibraries_Names ?= EEPROM

# Find one dirirectory for each named library, checking in ArduinoLibraries_Dirs
ArduinoLibraries_FullDirs = $(foreach lib,$(ArduinoLibraries_Names),$(firstword $(foreach dir,$(ArduinoLibraries_Dirs),$(wildcard $(dir)/$(lib)))))

# The real list of cSource names to build
ArduinoLibraries_cFiles ?= $(foreach dir,$(ArduinoLibraries_FullDirs),$(shell find $(dir) -name '*.c'))

# The real list of cppSource names to build
ArduinoLibraries_cppFiles ?= $(foreach dir,$(ArduinoLibraries_FullDirs),$(shell find $(dir) -name '*.cpp'))

# List of source files to build with complete paths
ArduinoLibraries_Files ?= $(ArduinoLibraries_cFiles) $(ArduinoLibraries_cppFiles)

# Name to give certain files/dirs while building
ArduinoLibraries_BuildName ?= ArduinoLibraries

# Output filename, missing path
ArduinoLibraries_ArchiveFilename ?= $(ArduinoLibraries_BuildName).a

ArduinoLibraries_ArchiveFilenameFull ?= $(BLD_LIBDIR)$(ArduinoLibraries_ArchiveFilename)

ArduinoLibraries_BuildDir ?= $(BLD_DIR)$(ArduinoLibraries_BuildName)/

ArduinoLibraries_ObjectFiles ?= $(ArduinoLibraries_Files:$(ArduinoLibraries_Dirs)%=$(ArduinoLibraries_BuildDir)%.o)

AUTO_LIB += $(ArduinoLibraries_ArchiveFilenameFull)

ArduinoLibraries_makeTarget ?= $(ArduinoLibraries_BuildName)

AUTO_INC += $(ArduinoLibraries_Dirs)

ArduinoLibraries_GCC_BuildFlags_Final ?= $(BLD_GCCFLAGS_FINAL)

ArduinoLibraries_GXX_BuildFlags_Final ?= $(BLD_GXXFLAGS_FINAL)

##### Targets

$(BLD_DIR)%.c.o: $(ArduinoLibraries_BaseDir)%.c
	$(ECO) "Arduino C	$@"
	$(BLD_GCC) $< -o $@ -c $(ArduinoLibraries_GCC_BuildFlags_Final)

	$(BLD_DIR)%.cpp.o: $(ArduinoLibraries_BaseDir)%.cpp
		$(ECO) "Arduino C++	$@"
		$(BLD_GXX) $< -o $@ -c $(ArduinoLibraries_GXX_BuildFlags_Final)

$(ArduinoLibraries_ArchiveFilenameFull): $(ArduinoLibraries_ObjectFiles)
	$(ECO) "Arduino AR	$@"
	$(BLD_ARR) $@ $(ArduinoLibraries_ObjectFiles)

$(ArduinoLibraries_ArchiveFilenameFull) $(ArduinoLibraries_ObjectFiles) : $(MAKEFILE_LIST)

$(ArduinoLibraries_makeTarget): $(ArduinoLibraries_ArchiveFilenameFull)

.PHONY: $(ArduinoLibraries_makeTarget)
.PRECIOUS: $(ArduinoLibraries_ObjectFiles)
.SECONDARY: $(ArduinoLibraries_ArchiveFilenameFull)

# Explicitly include all our build dep files
ArduinoLibraries_depFiles ?= $(ArduinoLibraries_ObjectFiles:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(ArduinoLibraries_depFiles)

AUTO_GENERATED_FILES += $(ArduinoLibraries_ArchiveFilenameFull) $(ArduinoLibraries_ObjectFiles) $(ArduinoLibraries_depFiles)
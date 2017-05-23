# This makefile allows you to use Arduino Libraries. It requires the Aruino.mk file
# to have been included previously.

# List of directories containing Arduino Libraries. We will
ArduinoLibraries_Dirs ?= $(Arduino_BaseDir)hardware/arduino/avr/libraries $(ArduinoLibraries_ExtraDirs)

# Libraries to build
ArduinoLibraries_Names ?= EEPROM

# Find one dirirectory for each named library, checking in ArduinoLibraries_Dirs
ArduinoLibraries_FullDirs = $(foreach lib,$(ArduinoLibraries_Names),$(firstword $(foreach dir,$(ArduinoLibraries_Dirs),$(wildcard $(dir)/$(lib)))))

# The real list of cSource names to build
ArduinoLibraries_cFiles ?= $(foreach dir,$(ArduinoLibraries_FullDirs),$(shell find $(dir) -name '*.'$(Arduino_Build_ExtentionC)))

# The real list of cppSource names to build
ArduinoLibraries_cppFiles ?= $(foreach dir,$(ArduinoLibraries_FullDirs),$(shell find $(dir) -name '*.'$(Arduino_Build_ExtentionCpp)))

# List of source files to build with complete paths
ArduinoLibraries_Files ?= $(ArduinoLibraries_cFiles) $(ArduinoLibraries_cppFiles)

# Name to give certain files/dirs while building
ArduinoLibraries_BuildName ?= ArduinoLibraries

# Output filename, missing path
ArduinoLibraries_ArchiveFilename ?= $(ArduinoLibraries_BuildName).$(Arduino_Build_ExtentionLibrary)

ArduinoLibraries_ArchiveFilenameFull ?= $(Build_LibPath)$(ArduinoLibraries_ArchiveFilename)

ArduinoLibraries_BuildDir ?= $(Build_Path)$(ArduinoLibraries_BuildName)/

ArduinoLibraries_ObjectFiles ?= $(ArduinoLibraries_Files:$(ArduinoLibraries_Dirs)%=$(ArduinoLibraries_BuildDir)%.$(Arduino_Build_ExtentionObject))

AUTO_LIB += $(ArduinoLibraries_ArchiveFilenameFull)

ArduinoLibraries_makeTarget ?= $(ArduinoLibraries_BuildName)

AUTO_INC += $(ArduinoLibraries_Dirs)

ArduinoLibraries_GCC_BuildFlags_Final ?= $(Build_Flags_GCC_Final)

ArduinoLibraries_GXX_BuildFlags_Final ?= $(Build_Flags_GXX_Final)

##### Targets

$(Build_Path)%.$(Arduino_Build_ExtentionC).$(Arduino_Build_ExtentionObject): $(ArduinoLibraries_BaseDir)%.$(Arduino_Build_ExtentionC)
	$(ECO) "Arduino C	$@"
	$(BLD_GCC) $< -o $@ -c $(ArduinoLibraries_GCC_BuildFlags_Final)

	$(Build_Path)%.$(Arduino_Build_ExtentionCpp).$(Arduino_Build_ExtentionObject): $(ArduinoLibraries_BaseDir)%.$(Arduino_Build_ExtentionCpp)
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
ArduinoLibraries_depFiles ?= $(ArduinoLibraries_ObjectFiles:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(ArduinoLibraries_depFiles)

AUTO_GENERATED_FILES += $(ArduinoLibraries_ArchiveFilenameFull) $(ArduinoLibraries_ObjectFiles) $(ArduinoLibraries_depFiles)

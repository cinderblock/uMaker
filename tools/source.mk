
# Filnames, without extentions, with path relative to Source_*Path
# Define these in your Makefile
cNames ?=
cppNames ?=
asmNames ?=
libNames ?=

# Or the full paths passed to gcc
Source_cFilenames ?= $(cNames:%=$(cSource_Path)%.$(Build_ExtentionC))
Source_cppFilenames ?= $(cppNames:%=$(cppSource_Path)%.$(Build_ExtentionCpp))
Source_asmFilenames ?= $(asmNames:%=$(asmSource_Path)%.$(Build_ExtentionAssembly))
Source_libFilenames ?= $(libNames:%=$(libSource_Path)%.$(Build_ExtentionLibrary))

# Final lists of sources to build
Source_cFilesFinal ?= $(AUTO_GCC) $(Source_cFilenames)
Source_cppFilesFinal ?= $(AUTO_GXX) $(Source_cppFilenames)
Source_asmFilesFinal ?= $(AUTO_ASM) $(Source_asmFilenames)
Source_libFilesFinal ?= $(AUTO_LIB) $(Source_libFilenames)

# Directories that src files are in. ie: Source_Path = src/
# These are used to build full filenames for user sources.
# They are also used by the build tools to keep paths clean.
Source_cPath ?= $(Source_Path)
Source_cppPath ?= $(Source_Path)
Source_asmPath ?= $(Source_Path)
Source_libPath ?= $(Source_Path)
Source_Path ?=

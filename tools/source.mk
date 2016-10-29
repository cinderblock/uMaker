

# Define these in your Makefile
GCCFILES ?= $(AUTO_GCC) $(C:%=$(Source_Path)%.$(Build_ExtentionC))
GXXFILES ?= $(AUTO_GXX) $(CPP:%=$(Source_Path)%.$(Build_ExtentionCpp))
ASMFILES ?= $(AUTO_ASM) $(ASM:%=$(Source_Path)%.$(Build_ExtentionAssembly))
LIBFILES ?= $(AUTO_LIB) $(LIB:%=$(Source_Path)%.$(Build_ExtentionLibrary))

# Directory that src files are in. ie: Source_Path = src/
Source_Path ?=

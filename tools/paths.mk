
# Base output file name
TARGET ?= setTARGETinYourMakefile

# Temporary directories to build into
Build_Path    ?= .bld/
Build_DepPath ?= $(Build_Path).dep/

# Only for libs that we build. Not for ones you're including that are pre-built
Build_LibPath ?= $(Build_Path)libs/

# Directory for compiled output files
Build_OutputPath ?= out/


Build_ExtentionC ?= c
Build_ExtentionCpp ?= cpp
Build_ExtentionAssembly ?= S
Build_ExtentionObject ?= o
Build_ExtentionLibrary ?= a

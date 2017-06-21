
XMCLib_BASEDIR ?= $(XMC_Peripheral_Library_Path)XMCLib

XMCLib_SrcDir ?= $(XMCLib_BASEDIR)/src

XMCLib_BuildPath ?= $(Build_Path)XMCLib/

# base source names to build
XMCLib_SRC ?=

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
XMCLib_Build_ExtentionC ?= c
XMCLib_Build_ExtentionCpp ?= cpp
XMCLib_Build_ExtentionAssembly ?= S
XMCLib_Build_ExtentionObject ?= $(Build_ExtentionObject)
XMCLib_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

XMCLib_FILES ?= $(XMCLib_SRC:%=$(XMCLib_SrcDir)/%.$(XMCLib_Build_ExtentionC))

XMCLib_AR ?= XMCLib.$(XMCLib_Build_ExtentionLibrary)

XMCLib_OBJS ?= $(XMCLib_FILES:$(XMCLib_SrcDir)/%=$(XMCLib_BuildPath)%.$(XMCLib_Build_ExtentionObject))

XMCLib_OUT ?= $(Build_LibPath)$(XMCLib_AR)

AUTO_LIB += $(XMCLib_OUT)

XMCLib_TARGET ?= XMCLib

XMCLib_IncDir ?= $(XMCLib_BASEDIR)/inc

AUTO_INC += $(XMCLib_IncDir)

XMCLib_Device ?= XMC1202_T016x0032

AUTO_DEF += $(XMCLib_Device)

# XMCLib expects this symbol to be defined. Use this hack for now. TODO: Cleanup
XMCLib_Build_Flags_GCC_Final ?= $(Build_Flags_GCC_Final)

##### Targets

$(XMCLib_BuildPath)%.$(XMCLib_Build_ExtentionC).$(XMCLib_Build_ExtentionObject): $(XMCLib_SrcDir)/%.$(XMCLib_Build_ExtentionC)
	$(ECO) "XMCLib		$@" $(XMCLib_DEPFILES)
	$(BLD_GCC) $< -o $@ -c $(XMCLib_Build_Flags_GCC_Final)

$(XMCLib_OUT): $(XMCLib_OBJS)
	$(ECO) "XMCLib AR	$@"
	$(BLD_ARR) $@ $(XMCLib_OBJS)

$(XMCLib_OUT) $(XMCLib_OBJS) : $(MAKEFILE_LIST)

$(XMCLib_TARGET): $(XMCLib_OUT)

.PHONY: $(XMCLib_TARGET)
.PRECIOUS: $(XMCLib_OBJS)
.SECONDARY: $(XMCLib_OUT)

# TODO: Compute DepPath smarter...
XMCLib_Build_DepPath ?= $(Build_DepPath)XMCLib/

# Explicitly include all our build dep files
XMCLib_DEPFILES ?= $(XMCLib_OBJS:$(XMCLib_BuildPath)%=$(XMCLib_Build_DepPath)%.d)
-include $(XMCLib_DEPFILES)

AUTO_GENERATED_FILES += $(XMCLib_OUT) $(XMCLib_OBJS) $(XMCLib_DEPFILES)

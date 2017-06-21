
XMCnewlib_BASEDIR ?= $(XMC_Peripheral_Library_Path)ThirdPartyLibraries/Newlib

XMCnewlib_SrcPath ?= $(XMCnewlib_BASEDIR)/

XMCnewlib_BuildPath ?= $(Build_Path)XMCnewlib/

# base source names to build
XMCnewlib_SRC ?= syscalls

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
XMCnewlib_Build_ExtentionC ?= c
XMCnewlib_Build_ExtentionCpp ?= cpp
XMCnewlib_Build_ExtentionAssembly ?= S
XMCnewlib_Build_ExtentionObject ?= $(Build_ExtentionObject)
XMCnewlib_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

XMCnewlib_FILES ?= $(XMCnewlib_SRC:%=$(XMCnewlib_SrcPath)%.$(XMCnewlib_Build_ExtentionC))

XMCnewlib_AR ?= XMCnewlib.$(XMCnewlib_Build_ExtentionLibrary)

XMCnewlib_OBJS ?= $(XMCnewlib_FILES:$(XMCnewlib_SrcPath)%=$(XMCnewlib_BuildPath)%.$(XMCnewlib_Build_ExtentionObject))

XMCnewlib_OUT ?= $(Build_LibPath)$(XMCnewlib_AR)

# TODO: figure out why if we use an archive that compilation fails:
#AUTO_LIB += $(XMCnewlib_OUT)
AUTO_OBJ += $(XMCnewlib_OBJS)

XMCnewlib_TARGET ?= XMC/Newlib

##### Targets

$(XMCnewlib_BuildPath)%.$(XMCnewlib_Build_ExtentionC).$(XMCnewlib_Build_ExtentionObject): $(XMCnewlib_SrcPath)%.$(XMCnewlib_Build_ExtentionC)
	$(ECO) "XMCnewlib		$@"
	$(BLD_GCC) $< -o $@ -c $(Build_Flags_GCC_Final)

$(XMCnewlib_OUT): $(XMCnewlib_OBJS)
	$(ECO) "XMCnewlib AR	$@"
	$(BLD_ARR) $@ $(XMCnewlib_OBJS)

$(XMCnewlib_OUT) $(XMCnewlib_OBJS) : $(MAKEFILE_LIST)

$(XMCnewlib_TARGET): $(XMCnewlib_OUT)

.PHONY: $(XMCnewlib_TARGET)
.PRECIOUS: $(XMCnewlib_OBJS)
.SECONDARY: $(XMCnewlib_OUT)

# TODO: Compute DepPath smarter...
XMCnewlib_Build_DepPath ?= $(Build_DepPath)XMCnewlib/

# Explicitly include all our build dep files
XMCnewlib_DEPFILES ?= $(XMCnewlib_OBJS:$(XMCnewlib_BuildPath)%=$(XMCnewlib_Build_DepPath)%.d)
-include $(XMCnewlib_DEPFILES)

AUTO_GENERATED_FILES += $(XMCnewlib_OUT) $(XMCnewlib_OBJS) $(XMCnewlib_DEPFILES)

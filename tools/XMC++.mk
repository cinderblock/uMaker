
# Location of XMC++ library. There should be a folder 'XMC++' inside this one
XMCpp_BASEDIR ?= XMC++

# base source names to build
XMCpp_SRC ?= 

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
XMCpp_Build_ExtentionC ?= c
XMCpp_Build_ExtentionCpp ?= cpp
XMCpp_Build_ExtentionAssembly ?= S
XMCpp_Build_ExtentionObject ?= $(Build_ExtentionObject)
XMCpp_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

# Relative to XMCpp_BASEDIR
XMCpp_FILES ?= $(XMCpp_SRC:%=$(XMCpp_BASEDIR)/%.$(XMCpp_Build_ExtentionCpp))

XMCpp_AR ?= XMC++.$(XMCpp_Build_ExtentionLibrary)

XMCpp_OBJS ?= $(XMCpp_FILES:%=$(Build_Path)%.$(XMCpp_Build_ExtentionObject))

XMCpp_OUT ?= $(Build_LibPath)$(XMCpp_AR)

AUTO_LIB += $(XMCpp_OUT)

XMCpp_TARGET ?= XMC++

AUTO_INC += $(XMCpp_BASEDIR)

##### Targets

$(Build_Path)%.$(XMCpp_Build_ExtentionCpp).$(XMCpp_Build_ExtentionObject): $(XMCpp_BASEDIR)%.$(XMCpp_Build_ExtentionCpp)
	$(ECO) "XMC++		$@"
	$(BLD_GXX) $< -o $@ -c $(Build_Flags_GXX_Final)

$(XMCpp_OUT): $(XMCpp_OBJS)
	$(ECO) "XMC++ AR	$@"
	$(BLD_ARR) $@ $(XMCpp_OBJS)

$(XMCpp_OUT) $(XMCpp_OBJS) : $(MAKEFILE_LIST)

$(XMCpp_TARGET): $(XMCpp_OUT)

.PHONY: $(XMCpp_TARGET)
.PRECIOUS: $(XMCpp_OBJS)
.SECONDARY: $(XMCpp_OUT)

# Explicitly include all our build dep files
XMCpp_DEPFILES ?= $(XMCpp_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(XMCpp_DEPFILES)

AUTO_GENERATED_FILES += $(XMCpp_OUT) $(XMCpp_OBJS) $(XMCpp_DEPFILES)

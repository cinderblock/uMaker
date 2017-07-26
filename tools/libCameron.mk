
# Location of libCameron library. There should be a folder 'src' inside this one
libCameron_BASEDIR ?= libCameron

# base source names to build
libCameron_SRC ?=

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
libCameron_Build_ExtentionC ?= c
libCameron_Build_ExtentionCpp ?= cpp
libCameron_Build_ExtentionAssembly ?= S
libCameron_Build_ExtentionObject ?= $(Build_ExtentionObject)
libCameron_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

libCameron_SourcePath ?= $(libCameron_BASEDIR)/src/

libCameron_FILES ?= $(libCameron_SRC:%=$(libCameron_SourcePath)%.$(libCameron_Build_ExtentionCpp))

libCameron_AR ?= libCameron.$(libCameron_Build_ExtentionLibrary)

libCameron_Build_Path ?= $(Build_Path)libCameron/

libCameron_OBJS ?= $(libCameron_SRC:%=$(libCameron_Build_Path)%.$(libCameron_Build_ExtentionCpp).$(libCameron_Build_ExtentionObject))

libCameron_OUT ?= $(Build_LibPath)$(libCameron_AR)

AUTO_LIB += $(libCameron_OUT)

libCameron_TARGET ?= libCameron

AUTO_INC += $(libCameron_BASEDIR)/src

##### Targets

$(libCameron_Build_Path)%.$(libCameron_Build_ExtentionCpp).$(libCameron_Build_ExtentionObject): $(libCameron_SourcePath)%.$(libCameron_Build_ExtentionCpp)
	$(ECO) "libCameron		$@"
	$(BLD_GXX) $< -o $@ -c $(Build_Flags_GXX_Final)

$(libCameron_OUT): $(libCameron_OBJS)
	$(ECO) "libCameron AR	$@"
	$(BLD_ARR) $@ $(libCameron_OBJS)

$(libCameron_OUT) $(libCameron_OBJS) : $(MAKEFILE_LIST)

$(libCameron_TARGET): $(libCameron_OUT)

.PHONY: $(libCameron_TARGET)
.PRECIOUS: $(libCameron_OBJS)
.SECONDARY: $(libCameron_OUT)

# Explicitly include all our build dep files
libCameron_DEPFILES ?= $(libCameron_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(libCameron_DEPFILES)

AUTO_GENERATED_FILES += $(libCameron_OUT) $(libCameron_OBJS) $(libCameron_DEPFILES)

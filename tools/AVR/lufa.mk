

LUFA_BASEDIR ?= ../LUFA/

ARCH ?= AVR8
LUFA_PATH ?= LUFA
include $(LUFA_BASEDIR)LUFA/Build/lufa_sources.mk

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
LUFA_Build_ExtentionC ?= c
LUFA_Build_ExtentionCpp ?= cpp
LUFA_Build_ExtentionAssembly ?= S
LUFA_Build_ExtentionObject ?= $(Build_ExtentionObject)
LUFA_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

# Relative to LUFA_BASEDIR
LUFA_SRC ?= $(LUFA_SRC_USB) $(LUFA_SRC_USBCLASS) $(LUFA_SRC_PLATFORM)

LUFA_AR ?= LUFA.$(LUFA_Build_ExtentionLibrary)

LUFA_OBJS ?= $(LUFA_SRC:%=$(Build_Path)%.$(LUFA_Build_ExtentionObject))

LUFA_OUT ?= $(BLD_LIBDIR)$(LUFA_AR)

F_USB ?= $(F_CPU)

AUTO_DEF += ARCH=ARCH_$(ARCH) F_USB=$(F_USB)

AUTO_LIB += $(LUFA_OUT)

LUFA_TARGET ?= LUFA

##### Targets

$(Build_Path)%.$(LUFA_Build_ExtentionC).$(LUFA_Build_ExtentionObject): $(LUFA_BASEDIR)%.$(LUFA_Build_ExtentionC)
	$(ECO) "LUFA	$@"
	$(BLD_GCC) $< -o $@ -c $(BLD_GCCFLAGS_FINAL)

$(LUFA_OUT): $(LUFA_OBJS)
	$(ECO) "AR	$@"
	$(BLD_ARR) $@ $(LUFA_OBJS)

$(LUFA_OUT) $(LUFA_OBJS): $(MAKEFILE_LIST)

$(LUFA_TARGET): $(LUFA_OUT)

.PHONY: $(LUFA_TARGET)
.PRECIOUS: $(LUFA_OBJS)
.SECONDARY: $(LUFA_OUT)

# Explicitly include all our build dep files
LUFA_DEPFILES ?= $(LUFA_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(LUFA_DEPFILES)

AUTO_GENERATED_FILES += $(LUFA_OUT) $(LUFA_OBJS) $(LUFA_DEPFILES)



LUFA_BaseDir ?= lufa
LUFA_BasePath ?= $(LUFA_BaseDir)/

# Variables required by LUFA
ARCH ?= AVR8
LUFA_PATH ?= $(LUFA_BasePath)LUFA
include $(LUFA_BasePath)LUFA/Build/lufa_sources.mk


LUFA_SrcBasePath ?= $(LUFA_PATH)/Drivers/

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
LUFA_Build_ExtentionC ?= c
LUFA_Build_ExtentionAssembly ?= S
LUFA_Build_ExtentionObject ?= $(Build_ExtentionObject)
LUFA_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

LUFA_Build_Path ?= $(Build_Path)LUFA/

# Relative to LUFA_BasePath
LUFA_SRC ?= $(LUFA_SRC_ALL_FILES)

LUFA_AR ?= LUFA.$(LUFA_Build_ExtentionLibrary)

LUFA_OBJS ?= $(LUFA_SRC:$(LUFA_SrcBasePath)%=$(LUFA_Build_Path)%.$(LUFA_Build_ExtentionObject))

LUFA_OUT ?= $(Build_LibPath)$(LUFA_AR)

F_USB ?= $(F_CPU)

AUTO_DEF += ARCH=ARCH_$(ARCH) F_USB=$(F_USB)

AUTO_LIB += $(LUFA_OUT)

LUFA_TARGET ?= LUFA

##### Targets

$(LUFA_Build_Path)%.$(LUFA_Build_ExtentionC).$(LUFA_Build_ExtentionObject): $(LUFA_SrcBasePath)%.$(LUFA_Build_ExtentionC)
	$(ECO) "LUFA	$@"
	$(BLD_GCC) $< -o $@ -c $(Build_Flags_GCC_Final)

$(LUFA_OUT): $(LUFA_OBJS)
	$(ECO) "LUFA AR	$@"
	$(BLD_ARR) $@ $(LUFA_OBJS)

$(LUFA_OUT) $(LUFA_OBJS): $(MAKEFILE_LIST)

$(LUFA_TARGET): $(LUFA_OUT)

.PHONY: $(LUFA_TARGET)
.PRECIOUS: $(LUFA_OBJS)
.SECONDARY: $(LUFA_OUT)

# Explicitly include all our build dep files
LUFA_DEPFILES ?= $(LUFA_OBJS:$(LUFA_Build_Path)%=$(Build_DepPath)LUFA/%.d)
-include $(LUFA_DEPFILES)

AUTO_GENERATED_FILES += $(LUFA_OUT) $(LUFA_OBJS) $(LUFA_DEPFILES)

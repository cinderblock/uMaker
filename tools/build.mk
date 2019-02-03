ifndef VARS_INCLUDE
 $(error You need to include a vars file)
endif

# Leading includes take precedence
Build_IncludeDirs ?= $(INCLUDES) $(AUTO_INC)
# Trailing defines override previous ones
Build_Defines  ?= $(AUTO_DEF) $(DEFINES)

Build_Undefines ?= $(AUTO_UNDEF) $(UNDEFINES)

OPTIMIZATION ?= 2

Build_Optimization ?= $(OPTIMIZATION)
Build_LanguageStandard_GCC ?= gnu11
Build_LanguageStandard_GXX ?= gnu++11

# Add appropriate command line flags to each include, define, and undefine
Build_Flags_Includes ?= $(Build_IncludeDirs:%=-I%)
Build_Flags_Defines ?= $(Build_Defines:%=-D%)
Build_Flags_Undefines ?= $(Build_Undefines:%=-U%)

BLD_DEPFLAGS = -MMD -MP -MF $(@:$(Build_Path)%=$(Build_DepPath)%.d)

BLD_HEXFLAGS ?= -O $(OUT_FMT)

# Collect all our flags in one final place. Also include standard user flags
Build_Flags_GCC_Final ?= $(Build_Flags_GCC) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CFLAGS)
Build_Flags_GXX_Final ?= $(Build_Flags_GXX) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CXXFLAGS)
Build_Flags_ASM_Final ?= $(Build_Flags_ASM) $(BLD_DEPFLAGS) $(ASFLAGS)
BLD_LNKFLAGS_FINAL ?= $(LNK_FLAGS) $(LDFLAGS) $(LDLIBS)
BLD_HEXFLAGS_FINAL ?= $(BLD_HEXFLAGS)

BLD_GCCOBJ ?= $(Source_cFilesFinal:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_GXXOBJ ?= $(Source_cppFilesFinal:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_ASMOBJ ?= $(Source_asmFilesFinal:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_LIBOBJ ?= $(Source_libFilesFinal)

BLD_OBJS = $(BLD_GCCOBJ) $(BLD_GXXOBJ) $(BLD_ASMOBJ) $(AUTO_OBJ)
BLD_LIBS = $(BLD_LIBOBJ)

OUT_ELF ?= $(Build_OutputPath)$(TARGET).elf
OUT_HEX ?= $(Build_OutputPath)$(TARGET).hex
OUT_LSS ?= $(Build_OutputPath)$(TARGET).lss
OUT_MAP ?= $(Build_OutputPath)$(TARGET).map
OUT_SYM ?= $(Build_OutputPath)$(TARGET).sym
OUT_EEP ?= $(Build_OutputPath)$(TARGET).eep

OUT_LIB ?= $(Build_OutputPath)lib$(TARGET).$(Build_ExtentionLibrary)

OUT_FILES = $(OUT_ELF) $(OUT_HEX) $(OUT_LSS) $(OUT_MAP) $(OUT_SYM) $(OUT_EEP) $(OUT_LIB)

AUTO_GENERATED_FILES += $(BLD_GCCOBJ) $(BLD_GXXOBJ) $(BLD_ASMOBJ) $(OUT_FILES)

# Output file format
OUT_FMT ?= ihex

OUT_DEPS ?= $(BLD_OBJS) $(BLD_LIBS) $(AUTO_OUT_DEPS)

ifdef GCC_VARIANT
  GCC_PREFIX ?= $(GCC_VARIANT)-
endif

ifdef GCC_RootDir
  GCC_BinPath ?= $(GCC_RootDir)/bin/
endif

BLD_GCC ?= "$(GCC_BinPath)$(GCC_PREFIX)gcc"
BLD_GXX ?= "$(GCC_BinPath)$(GCC_PREFIX)g++"
BLD_ASM ?= "$(GCC_BinPath)$(GCC_PREFIX)g++"
BLD_LNK ?= "$(GCC_BinPath)$(GCC_PREFIX)g++"
BLD_OCP ?= "$(GCC_BinPath)$(GCC_PREFIX)objcopy"
BLD_ODP ?= "$(GCC_BinPath)$(GCC_PREFIX)objdump"
BLD_SZE ?= "$(GCC_BinPath)$(GCC_PREFIX)size"
BLD_ARR ?= "$(GCC_BinPath)$(GCC_PREFIX)ar" rcs
BLD_NMM ?= "$(GCC_BinPath)$(GCC_PREFIX)nm"

RMF ?= rm -rf

ECO ?= @echo

# Create object files from .c sources
$(Build_Path)%.$(Build_ExtentionC).$(Build_ExtentionObject): $(Source_cPath)%.$(Build_ExtentionC)
	$(ECO) "CC	$@"
	$(BLD_GCC) -o $@ $< -c $(Build_Flags_GCC_Final)

# Create object files from .cpp sources
$(Build_Path)%.$(Build_ExtentionCpp).$(Build_ExtentionObject): $(Source_cppPath)%.$(Build_ExtentionCpp)
	$(ECO) "C++	$@"
	$(BLD_GXX) -o $@ $< -c $(Build_Flags_GXX_Final)

# Create object files from .s sources
$(Build_Path)%.$(Build_ExtentionAssembly).$(Build_ExtentionObject): $(Source_asmPath)%.$(Build_ExtentionAssembly)
	$(ECO) "ASM	$@"
	$(BLD_ASM) -o $@ $< -c $(Build_Flags_ASM_Final)

# Create output .elf from objects
$(OUT_ELF): $(OUT_DEPS)
	$(ECO) "Lnk	$@"
	$(BLD_LNK) -o $@ $(OUT_DEPS) $(BLD_LNKFLAGS_FINAL)

# Create output .a from objects
$(OUT_LIB): $(OUT_DEPS)
	$(ECO) "AR	$@"
	$(BLD_ARR) $@ $(OUT_DEPS)

# Create output .hex from ELF
$(OUT_HEX): $(OUT_ELF)
	$(ECO) "HEX	$@"
	$(BLD_OCP) $< $@ $(BLD_HEXFLAGS_FINAL)

# Create output .eep from ELF
$(OUT_EPP): $(OUT_ELF)
	$(ECO) "EEP	$@"
	$(BLD_OCP) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 --no-change-warnings -O $(OUT_FMT) $< $@ || exit 0

# Create extended listing file from ELF
$(OUT_LSS): $(OUT_ELF)
	$(ECO) "LST	$@"
	$(BLD_ODP) -h -S -z $< > $@

# Create a symbol table from ELF
$(OUT_SYM): $(OUT_ELF)
	$(ECO) "SYM	$@"
	$(BLD_NMM) -n $< > $@

size: $(OUT_ELF)
	$(BLD_SZE) $(OUT_ELF)
	
build-lss: $(OUT_LSS)

build: $(OUT_ELF)

clean: clean_build

clean_build:
	$(ECO) Cleaning Build...
	$(RMF) $(Build_Path) $(Build_OutputPath) $(Build_LibPath) $(Build_DepPath)

.PHONY: clean size clean_build build-lss build

.PRECIOUS: $(BLD_ALL_OBJS)
.SECONDARY: $(OUT_FILES)

$(BLD_OBJS) $(OUT_FILES): $(MAKEFILE_LIST)

# Explicitly include all our build dep files
BLD_DEPFILES ?= $(BLD_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)

AUTO_GENERATED_FILES += $(BLD_DEPFILES)
-include $(BLD_DEPFILES)

# Special target that tells make to delete files created by failed builds
.DELETE_ON_ERRORS:

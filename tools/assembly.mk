# Create assembly (.s/.S) files from C/C++ sources

ASM ?= $(C:%=%.$(Build_ExtentionC).$(Build_ExtentionAssembly)) $(CPP:%=%.$(Build_ExtentionCpp).$(Build_ExtentionAssembly))

ASM_DIR ?= $(BuildPath)

ASM_FILES ?= $(ASM:%=$(ASM_DIR)%)

asm: $(ASM_FILES)

# Create assembly files from .c sources
$(ASM_DIR)%.$(Build_ExtentionC).$(Build_ExtentionAssembly): $(SRCDIR)%.$(Build_ExtentionC) $(MAKEFILE_LIST)
	$(ECO) "CC AS	$@"
	$(BLD_GCC) -o $@ $< -S $(BLD_GCCFLAGS_FINAL)

# Create object files from .cpp sources
$(ASM_DIR)%.$(Build_ExtentionCpp).$(Build_ExtentionAssembly): $(SRCDIR)%.$(Build_ExtentionCpp) $(MAKEFILE_LIST)
	$(ECO) "C++ AS	$@"
	$(BLD_GXX) -o $@ $< -S $(BLD_GXXFLAGS_FINAL)

AUTO_GENERATED_FILES += $(ASM_FILES)

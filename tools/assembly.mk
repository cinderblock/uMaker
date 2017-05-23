# Create assembly (.s/.S) files from C/C++ sources

ASM ?= $(C:%=%.$(Build_ExtentionC).$(Build_ExtentionAssembly)) $(CPP:%=%.$(Build_ExtentionCpp).$(Build_ExtentionAssembly))

ASM_DIR ?= $(Build_Path)

ASM_FILES ?= $(ASM:%=$(ASM_DIR)%)

asm: $(ASM_FILES)

# Create assembly files from .c sources
$(ASM_DIR)%.$(Build_ExtentionC).$(Build_ExtentionAssembly): $(Source_Path)%.$(Build_ExtentionC) $(MAKEFILE_LIST)
	$(ECO) "CC AS	$@"
	$(BLD_GCC) -o $@ $< -S $(Build_Flags_GCC_Final)

# Create object files from .cpp sources
$(ASM_DIR)%.$(Build_ExtentionCpp).$(Build_ExtentionAssembly): $(Source_Path)%.$(Build_ExtentionCpp) $(MAKEFILE_LIST)
	$(ECO) "C++ AS	$@"
	$(BLD_GXX) -o $@ $< -S $(Build_Flags_GXX_Final)

AUTO_GENERATED_FILES += $(ASM_FILES)

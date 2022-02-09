# Create assembly (.s/.S) files from C/C++ sources

ASM ?= $(cNames:%=%.$(Build_ExtentionC).$(Build_ExtentionAssembly)) $(cppNames:%=%.$(Build_ExtentionCpp).$(Build_ExtentionAssembly))

ASM_Path ?= $(Build_Path)

ASM_FILES ?= $(ASM:%=$(ASM_Path)%)

asm: $(ASM_FILES)

# Create assembly files from .c sources
$(ASM_Path)%.$(Build_ExtentionC).$(Build_ExtentionAssembly): $(Source_Path)%.$(Build_ExtentionC) $(MAKEFILE_LIST)
	$(ECO) "CC AS	$@"
	$(BLD_GCC) -o $@ $< -S $(Build_Flags_GCC_Final)

# Create object files from .cpp sources
$(ASM_Path)%.$(Build_ExtentionCpp).$(Build_ExtentionAssembly): $(Source_Path)%.$(Build_ExtentionCpp) $(MAKEFILE_LIST)
	$(ECO) "C++ AS	$@"
	$(BLD_GXX) -o $@ $< -S $(Build_Flags_GXX_Final)

AUTO_GENERATED_FILES += $(ASM_FILES)

ASM_BLD_DEPFILES ?= $(ASM_FILES:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(ASM_BLD_DEPFILES)

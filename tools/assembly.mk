# Create assembly (.s/.S) files from C/C++ sources

ASM ?= $(C:%=%.c.s) $(CPP:%=%.cpp.S)

ASM_DIR ?= $(BLD_DIR)

ASM_FILES ?= $(ASM:%=$(ASM_DIR)%)

asm: $(ASM_FILES)

# Create assembly files from .c sources
$(ASM_DIR)%.c.s: $(SRCDIR)%.c $(MAKEFILE_LIST)
	$(ECO) "CC AS	$@"
	$(BLD_GCC) -o $@ $< -S $(BLD_GCCFLAGS_FINAL)

# Create object files from .cpp sources
$(ASM_DIR)%.cpp.S: $(SRCDIR)%.cpp $(MAKEFILE_LIST)
	$(ECO) "C++ AS	$@"
	$(BLD_GXX) -o $@ $< -S $(BLD_GXXFLAGS_FINAL)

AUTO_GENERATED_FILES += $(ASM_FILES)

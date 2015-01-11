# Create assembly (.s/.S) files from C/C++ sources


# Create assembly files from .c sources
$(BLD_DIR)%.c.s: $(SRCDIR)%.c
	$(ECO) "CC AS	$@"
	$(BLD_GCC) -o $@ $< -S $(BLD_GCCFLAGS_FINAL)

	# Create object files from .cpp sources
$(BLD_DIR)%.cpp.S: $(SRCDIR)%.cpp
	$(ECO) "C++	AS $@"
	$(BLD_GXX) -o $@ $< -S $(BLD_GXXFLAGS_FINAL)

ifndef VARS_INCLUDE
 $(error You need to include a vars file)
endif
	
build: $(OUT_ELF)

# Create object files from .c sources
$(BLD_DIR)%.c.o: $(SRCDIR)%.c
	$(ECO) "CC	$@"
	$(GCC) -o $@ $< $(BLD_GCCFLAGS_FINAL)

# Create object files from .cpp sources
$(BLD_DIR)%.cpp.o: $(SRCDIR)%.cpp
	$(ECO) "C++	$@"
	$(GXX) -o $@ $< $(BLD_GXXFLAGS_FINAL)

# Create output .elf from objects
$(OUT_ELF): $(OUT_DEPS)
	$(ECO) "Lnk	$@"
	$(LNK) -o $@ $(OUT_DEPS) $(BLD_LNKFLAGS_FINAL)

# Create output .a from objects
$(OUT_LIB): $(OUT_DEPS)
	$(ECO) "AR	$@"
	$(ARR) $@ $(OUT_DEPS)

# Create output .hex from ELF
$(OUT_HEX): $(OUT_ELF)
	$(ECO) "HEX	$@"
	$(OCP) -O $(OUT_FMT) -R .eeprom -R .fuse -R .lock $< $@

# Create output .eep from ELF
$(OUT_EPP): $(OUT_ELF)
	$(ECO) "EEP	$@"
	$(OCP) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 --no-change-warnings -O $(OUTFMT) $< $@ || exit 0

# Create extended listing file from ELF
$(OUT_LSS): $(OUT_ELF)
	$(ECO) "LST	$@"
	$(ODP) -h -S -z $< > $@

# Create a symbol table from ELF
$(OUT_SYM): $(OUT_ELF)
	$(ECO) "SYM	$@"
	$(NMM) -n $< > $@

clean: clean_build

clean_build:
	$(ECO) Cleaning Build...
	$(RMF) $(BLD_DIR) $(OUT_DIR) $(BLD_LIBDIR) $(BLD_DEPDIR)

.PHONY: clean clean_build

.PRECIOUS: $(OUT_DEPS)
.SECONDARY: $(OUT_FILES)
	
$(BLD_OBJS) $(OUT_FILES): $(MAKEFILE_LIST)

# Explicitly include all our build dep files
BLD_DEPFILES = $(BLD_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(BLD_DEPFILES)

# Directories should always end in '/' so you can do things like this
%/: ; $(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(OUT_FILES) $(OUT_DEPS) $(BLD_DEPFILES): | $$(dir $$@)
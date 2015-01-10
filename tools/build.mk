ifndef VARS_INCLUDE
 $(error You need to include a vars file)
endif

build-lss: $(OUT_LSS)

build: $(OUT_ELF)

# Create object files from .c sources
$(BLD_DIR)%.c.o: $(SRCDIR)%.c
	$(ECO) "CC	$@"
	$(BLD_GCC) -o $@ $< -c $(BLD_GCCFLAGS_FINAL)

# Create object files from .cpp sources
$(BLD_DIR)%.cpp.o: $(SRCDIR)%.cpp
	$(ECO) "C++	$@"
	$(BLD_GXX) -o $@ $< -c $(BLD_GXXFLAGS_FINAL)

# Create object files from .s sources
$(BLD_DIR)%.s.o: $(SRCDIR)%.s
	$(ECO) "ASM	$@"
	$(BLD_ASM) -o $@ $< -c $(BLD_ASMFLAGS_FINAL)

# Create output .elf from objects
$(OUT_ELF): $(OUT_DEPS)
	$(ECO) "Lnk	$@"
	$(BLD_LNK) -o $@ $(BLD_ALL_OBJS) $(BLD_LNKFLAGS_FINAL)

# Create output .a from objects
$(OUT_LIB): $(OUT_DEPS)
	$(ECO) "AR	$@"
	$(BLD_ARR) $@ $(BLD_ALL_OBJS)

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

clean: clean_build

clean_build:
	$(ECO) Cleaning Build...
	$(RMF) $(BLD_DIR) $(OUT_DIR) $(BLD_LIBDIR) $(BLD_DEPDIR)

.PHONY: clean size clean_build build-lss build

.PRECIOUS: $(BLD_ALL_OBJS)
.SECONDARY: $(OUT_FILES)

$(BLD_OBJS) $(OUT_FILES): $(MAKEFILE_LIST)

# Explicitly include all our build dep files
BLD_DEPFILES = $(BLD_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(BLD_DEPFILES)

# Older version of make strip trailing '/' from targets unless they're explicitly declared
$(sort $(dir $(OUT_FILES) $(BLD_ALL_OBJS) $(BLD_DEPFILES))):
	$(ECO) "MKDIR	$@"
	$(MKD) $@

# Directories should always end in '/' so you can do things like this
%/:
	$(ECO) "MKDIR1	$@"
	$(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(OUT_FILES) $(BLD_ALL_OBJS) $(BLD_DEPFILES): | $$(dir $$@)/

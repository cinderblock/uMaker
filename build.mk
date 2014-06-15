

# Create object files from .c sources
$(BLDDIR)%.c.o: $(SRCDIR)%.c $(MAKEFILE_LIST)
	$(ECO) "CC : $@		$<"
	$(GCC) -c $(BLDFLAGS) $(DEPFLAGS) $(GCCFLAGS) $< -o $@

# Create object files from .cpp sources
$(BLDDIR)%.cpp.o: $(SRCDIR)%.cpp $(MAKEFILE_LIST)
	$(ECO) "C++: $@		$<"
	$(GXX) -c $(BLDFLAGS) $(DEPFLAGS) $(GXXFLAGS) $< -o $@

# Create output .elf from objects
$(ELFOUT): $(COBJ) $(CPPOBJ) $(LIBOBJ)
	$(ECO) $(LIBFILES)
	$(ECO) Lnk: $@
	$(GXX) $^ --output $@ $(LDFLAGS)

# Create output .a from objects
$(LIBOUT): $(COBJ) $(CPPOBJ) $(LIBOBJ)
	$(ECO) AR : $@
	$(AR) $@ $^

# Create output .hex from ELF
$(HEXOUT): $(ELFOUT)
	$(ECO) HEX: $@
	$(OCP) -O $(OUTFMT) -R .eeprom -R .fuse -R .lock $< $@

# Create output .eep from ELF
$(EEPOUT): $(ELFOUT)
	$(ECO) EEP: $@
	$(OCP) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 --no-change-warnings -O $(OUTFMT) $< $@ || exit 0

# Create extended listing file from ELF
$(LSSOUT): $(ELFOUT)
	$(ECO) LST: $@
	$(OBJDUMP) -h -S -z $< > $@

# Create a symbol table from ELF
$(SYMOUT): $(ELFOUT)
	$(ECO) SYM: $@
	$(NM) -n $< > $@

clean: clean_build

clean_build:
	$(ECO) Cleaning Build...
	$(RMF) $(LIBDIR) $(BLDDIR) $(OUTDIR) $(DEPDIR)

.PHONY: clean clean_build

.PRECIOUS: %.o
.SECONDARY: $(ELFOUT) $(LIBOUT)

-include $(DEPDIR)*.d

# Make all the directories...
%/: ; $(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(ELFOUT) $(HEXOUT) $(LSSOUT) $(MAPOUT) $(SYMOUT) $(EEPOUT) $(LIBOUT): | $$(dir $$@)
$(COBJ) $(CPPOBJ) $(LIBOBJ): | $$(dir $$@)
$(COBJ) $(CPPOBJ): | $$(dir $(DEPDIR)$$(@F).d)
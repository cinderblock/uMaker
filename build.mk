

# Create object files from .c sources
$(BLDDIR)%.c.o: $(SRCDIR)%.c
	$(ECO) "CC : $@		$<"
	$(GCC) -c $(BLDFLAGS) $(DEPFLAGS) $(GCCFLAGS) $< -o $@

# Create object files from .cpp sources
$(BLDDIR)%.cpp.o: $(SRCDIR)%.cpp
	$(ECO) "C++: $@		$<"
	$(GXX) -c $(BLDFLAGS) $(DEPFLAGS) $(GXXFLAGS) $< -o $@

# Create output .elf from objects
$(ELFOUT): $(OBJS) $(LIBS)
	$(ECO) Lnk: $@
	$(GXX) $(OBJS) $(LIBS) --output $@ $(LDFLAGS)

# Create output .a from objects
$(LIBOUT): $(OBJS) $(LIBS)
	$(ECO) AR : $@
	$(ARR) $@ $^

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
	$(ODP) -h -S -z $< > $@

# Create a symbol table from ELF
$(SYMOUT): $(ELFOUT)
	$(ECO) SYM: $@
	$(NMM) -n $< > $@

clean: clean_build

clean_build:
	$(ECO) Cleaning Build...
	$(RMF) $(LIBDIR) $(BLDDIR) $(OUTDIR) $(DEPDIR)

.PHONY: clean clean_build

.PRECIOUS: $(OBJS) $(LIBS)
.SECONDARY: $(OUTFILES)
	
$(OBJS) $(LIBS) $(OUTFILES): $(MAKEFILE_LIST)

# Explicitly include all our build dep files
DEPFILES = $(OBJS:$(BLDDIR)%=$(DEPDIR)%.d)
-include $(DEPFILES)

# Make all the directories...
%/: ; $(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(OUTFILES) $(OBJS) $(LIBS) $(DEPFILES): | $$(dir $$@)
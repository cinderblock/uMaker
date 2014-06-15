


$(BLDDIR)%.c.o: $(LUFA_BASEDIR)%.c
	$(ECO) "LUFA: $<"
	$(GCC) -c $(BLDFLAGS) $(DEPFLAGS) $(GCCFLAGS) $(LUFA_FLAGS) $< -o $@

$(LIBDIR)$(LUFA_AR): $(LUFA_OBJS)
	$(ECO) AR : $@
	$(ARR) $@ $(LUFA_OBJS)

$(LIBDIR)$(LUFA_AR) $(LUFA_OBJS): $(MAKEFILE_LIST)

lufa: $(LIBDIR)$(LUFA_AR)

.PHONY: lufa
.PRECIOUS: $(LUFA_OBJS)
.SECONDARY: $(LIBDIR)$(LUFA_AR)

# Explicitly include all our build dep files
LUFA_DEPFILES = $(LUFA_OBJS:$(BLDDIR)%=$(DEPDIR)%.d)
-include $(LUFA_DEPFILES)

# Add directory targets to those that need them
.SECONDEXPANSION:
$(LUFA_OBJS) $(LUFA_DEPFILES): | $$(dir $$@)

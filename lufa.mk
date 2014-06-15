
LUFA_BASEDIR ?= ../LUFA/

LUFA_MAKEFILE_SOURCES ?= $(LUFA_BASEDIR)LUFA/Build/lufa_sources.mk

ARCH ?= AVR8
LUFA_PATH ?= LUFA
include $(LUFA_MAKEFILE_SOURCES)

# Relative to LUFA_BASEDIR
LUFA_SRC ?= $(LUFA_SRC_USB) $(LUFA_SRC_USBCLASS) $(LUFA_SRC_PLATFORM)

LUFA_AR ?= LUFA.a

LUFA_OBJS ?= $(LUFA_SRC:%=$(BLDDIR)%.o)
	
LUFA_FLAGS ?= -fshort-enums -fno-inline-small-functions -fpack-struct $(LUFA_BASE_FLAGS)

LUFA_BASE_FLAGS ?= -Wall -fno-strict-aliasing -funsigned-char -funsigned-bitfields -DARCH=ARCH_$(ARCH) -DF_USB=$(F_USB) -Wstrict-prototypes

AUTO_LIB += $(LUFA_AR)

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

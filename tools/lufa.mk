

LUFA_BASEDIR ?= ../LUFA/

ARCH ?= AVR8
LUFA_PATH ?= LUFA
include $(LUFA_BASEDIR)LUFA/Build/lufa_sources.mk

# Relative to LUFA_BASEDIR
LUFA_SRC ?= $(LUFA_SRC_USB) $(LUFA_SRC_USBCLASS) $(LUFA_SRC_PLATFORM)

LUFA_AR ?= LUFA.a

LUFA_OBJS ?= $(LUFA_SRC:%=$(BLD_DIR)%.o)

LUFA_OUT ?= $(BLD_LIBDIR)$(LUFA_AR)

F_USB ?= $(F_CPU)	

AUTO_DEFS += ARCH=ARCH_$(ARCH) F_USB=$(F_USB)

AUTO_LIB += $(LUFA_AR)


##### Targets

$(BLD_DIR)%.c.o: $(LUFA_BASEDIR)%.c
	$(ECO) "LUFA	$@"
	$(BLD_GCC) $< -o $@ $(BLD_GCCFLAGS)

$(LUFA_OUT): $(LUFA_OBJS)
	$(ECO) "AR	$@"
	$(BLD_ARR) $@ $(LUFA_OBJS)

$(LUFA_OUT) $(LUFA_OBJS): $(MAKEFILE_LIST)

lufa: $(LUFA_OUT)

.PHONY: lufa
.PRECIOUS: $(LUFA_OBJS)
.SECONDARY: $(LUFA_OUT)

# Explicitly include all our build dep files
LUFA_DEPFILES = $(LUFA_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(LUFA_DEPFILES)

# Add directory targets to those that need them
.SECONDEXPANSION:
$(LUFA_OUT) $(LUFA_OBJS) $(LUFA_DEPFILES): | $$(dir $$@)

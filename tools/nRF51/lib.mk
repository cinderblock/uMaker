


NRF51_SRCDIR ?= $(NRF51_BASEDIR)Source/
NRF51_INCDIR ?= $(NRF51_BASEDIR)Include/

NRF51_BLDDIR ?= $(BLD_DIR)nRF51/

NRF51_EXTRA_INCLUDES ?= $(SRCDIR)nRF51inc

# Relative to NRF51_SRCDIR
NRF51_SRC ?= simple_uart/simple_uart.c

NRF51_AR ?= nRF51.a

NRF51_OBJS ?= $(NRF51_SRC:%=$(NRF51_BLDDIR)%.o)

NRF51_OUT ?= $(BLD_LIBDIR)$(NRF51_AR)

NRF51_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_GCCFLAGS_EXTRA)

AUTO_DEFS += BLE_STACK_SUPPORT_REQD

NRF51_INCLUDES := $(sort $(dir $(wildcard $(NRF51_INCDIR)*/) $(wildcard $(NRF51_INCDIR)ble/*/)))

AUTO_INCS += $(NRF51_INCLUDES) $(NRF51_EXTRA_INCLUDES)

AUTO_LIB += $(NRF51_OUT)


##### Targets

$(NRF51_BLDDIR)%.c.o: $(NRF51_SRCDIR)%.c
	$(ECO) "nRF51	$@"
	$(BLD_GCC) $< -o $@ $(NRF51_GCCFLAGS_FINAL)

$(NRF51_OUT): $(NRF51_OBJS)
	$(ECO) "AR	$@"
	$(BLD_ARR) $@ $(NRF51_OBJS)

$(NRF51_OUT) $(NRF51_OBJS): $(MAKEFILE_LIST)

lufa: $(NRF51_OUT)

.PHONY: lufa
.PRECIOUS: $(NRF51_OBJS)
.SECONDARY: $(NRF51_OUT)

# Explicitly include all our build dep files
NRF51_DEPFILES = $(NRF51_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51_DEPFILES)

# Older version of make strip trailing '/' from targets unless they're explicitly declared
$(sort $(dir $(NRF51_OUT) $(NRF51_OBJS) $(NRF51_DEPFILES))):
	$(ECO) "MKDIR	$@"
	$(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(NRF51_OUT) $(NRF51_OBJS) $(NRF51_DEPFILES): | $$(dir $$@)

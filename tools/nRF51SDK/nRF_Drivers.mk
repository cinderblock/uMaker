


NRF51_SRCDIR ?= $(NRF51_BASEDIR)components/

# This matches the folder name that Nordic assigns
NRF51_NRFDRIVERS ?= drivers_nrf

NRF51_NRFDRIVERS_SRCDIR ?= $(NRF51_SRCDIR)$(NRF51_NRFDRIVERS)/

NRF51_NRFDRIVERS_BLDDIR ?= $(BLD_DIR)nRF51/$(NRF51_NRFDRIVERS)/

# Names of nRF51 source files to "find" and include
NRF51_NRFDRIVERS_C ?= simple_uart

NRF51_NRFDRIVERS_SRC_FILES ?= $(NRF51_NRFDRIVERS_C:%=%.c)

NRF51_NRFDRIVERS_SRC_FILES_FULL ?= $(foreach file,$(NRF51_NRFDRIVERS_SRC_FILES),$(shell find $(NRF51_NRFDRIVERS_SRCDIR) -type f -name $(file)))

NRF51_NRFDRIVERS_AR ?= nRF51-$(NRF51_NRFDRIVERS).a

NRF51_NRFDRIVERS_OBJS ?= $(NRF51_NRFDRIVERS_SRC_FILES_FULL:$(NRF51_NRFDRIVERS_SRCDIR)%=$(NRF51_NRFDRIVERS_BLDDIR)%.o)

NRF51_NRFDRIVERS_OUT ?= $(BLD_LIBDIR)$(NRF51_NRFDRIVERS_AR)

NRF51_NRFDRIVERS_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_NRFDRIVERS_GCCFLAGS_EXTRA)

NRF51_NRFDRIVERS_INCLUDES ?= $(sort $(dir $(NRF51_NRFDRIVERS_SRC_FILES_FULL)))

AUTO_INC += $(NRF51_NRFDRIVERS_INCLUDES)

AUTO_LIB += $(NRF51_NRFDRIVERS_OUT)

NRF51_NRFDRIVERS_TARGET ?= nRF51/nRF_Drivers

AUTO_GENERATED_FILES += $(NRF51_NRFDRIVERS_OUT) $(NRF51_NRFDRIVERS_OBJS) $(NRF51_NRFDRIVERS_DEPFILES)

##### Targets

$(NRF51_NRFDRIVERS_BLDDIR)%.c.o: $(NRF51_NRFDRIVERS_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_NRFDRIVERS_GCCFLAGS_FINAL)

$(NRF51_NRFDRIVERS_OUT): $(NRF51_NRFDRIVERS_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_NRFDRIVERS_OBJS)

$(NRF51_NRFDRIVERS_OUT) $(NRF51_NRFDRIVERS_OBJS): | $(MAKEFILE_LIST)

$(NRF51_NRFDRIVERS_TARGET): $(NRF51_NRFDRIVERS_OUT)

.PHONY: $(NRF51_NRFDRIVERS_TARGET)
.PRECIOUS: $(NRF51_NRFDRIVERS_OBJS)
.SECONDARY: $(NRF51_NRFDRIVERS_OUT)

# Explicitly include all our build dep files
NRF51_NRFDRIVERS_DEPFILES = $(NRF51_NRFDRIVERS_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51_NRFDRIVERS_DEPFILES)

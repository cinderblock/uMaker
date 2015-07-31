


nRF51SDK_SourcePath ?= $(nRF51SDK_BasePath)components/

# This matches the folder name that Nordic assigns
NRF51_EXTDRIVERS ?= drivers_ext

NRF51_EXTDRIVERS_SRCDIR ?= $(nRF51SDK_SourcePath)$(NRF51_EXTDRIVERS)/

NRF51_EXTDRIVERS_BLDDIR ?= $(BLD_DIR)nRF51/$(NRF51_EXTDRIVERS)/

# Names of nRF51 source files to "find" and include
NRF51_EXTDRIVERS_C ?= adns2080 cherry8x16 ds1624 mpu6050 nrf6350 synaptics_touchpad

NRF51_EXTDRIVERS_SRC_FILES ?= $(NRF51_EXTDRIVERS_C:%=%.c)

NRF51_EXTDRIVERS_SRC_FILES_FULL ?= $(foreach file,$(NRF51_EXTDRIVERS_SRC_FILES),$(shell find $(NRF51_EXTDRIVERS_SRCDIR) -type f -name "$(file)"))

NRF51_EXTDRIVERS_AR ?= nRF51-$(NRF51_EXTDRIVERS).a

NRF51_EXTDRIVERS_OBJS ?= $(NRF51_EXTDRIVERS_SRC_FILES_FULL:$(NRF51_EXTDRIVERS_SRCDIR)%=$(NRF51_EXTDRIVERS_BLDDIR)%.o)

NRF51_EXTDRIVERS_OUT ?= $(BLD_LIBDIR)$(NRF51_EXTDRIVERS_AR)

NRF51_EXTDRIVERS_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_EXTDRIVERS_GCCFLAGS_EXTRA)

AUTO_LIB += $(NRF51_EXTDRIVERS_OUT)

NRF51_EXTDRIVERS_TARGET ?= nRF51/extDrivers

AUTO_GENERATED_FILES += $(NRF51_EXTDRIVERS_OUT) $(NRF51_EXTDRIVERS_OBJS) $(NRF51_EXTDRIVERS_DEPFILES)

##### Targets

$(NRF51_EXTDRIVERS_BLDDIR)%.c.o: $(NRF51_EXTDRIVERS_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_EXTDRIVERS_GCCFLAGS_FINAL)

$(NRF51_EXTDRIVERS_OUT): $(NRF51_EXTDRIVERS_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_EXTDRIVERS_OBJS)

$(NRF51_EXTDRIVERS_OUT) $(NRF51_EXTDRIVERS_OBJS): $(MAKEFILE_LIST)

$(NRF51_EXTDRIVERS_TARGET): $(NRF51_EXTDRIVERS_OUT)

.PHONY: $(NRF51_EXTDRIVERS_TARGET)
.PRECIOUS: $(NRF51_EXTDRIVERS_OBJS)
.SECONDARY: $(NRF51_EXTDRIVERS_OUT)

# Explicitly include all our build dep files
NRF51_EXTDRIVERS_DEPFILES = $(NRF51_EXTDRIVERS_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51_EXTDRIVERS_DEPFILES)

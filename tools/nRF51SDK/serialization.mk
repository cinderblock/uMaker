
# This build script does not just run. There are too many different source files
# that conflict so we can't just build them all. And making exceptions for them
# is taking too long.

NRF51_SRCDIR ?= $(NRF51_BASEDIR)components/

# This matches the folder name that Nordic assigns
NRF51_SERIALIZATION ?= serialization

NRF51_SERIALIZATION_SRCDIR ?= $(NRF51_SRCDIR)$(NRF51_SERIALIZATION)/

NRF51_SERIALIZATION_BLDDIR ?= $(BLD_DIR)nRF51/$(NRF51_SERIALIZATION)/

# Names of nRF51 source files to "find" and include
NRF51_SERIALIZATION_C ?= *

NRF51_SERIALIZATION_SRC_FILES ?= $(NRF51_SERIALIZATION_C:%=%.c)

# Don't build a bunch of sources that conflict with the soft device
ifneq (,$(NRF51_SOFTDEVICE_VERSION))
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += %app_mw_ble.c
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += %app_mw_ble_gap.c
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += %app_mw_ble_gatts.c
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += %app_mw_ble_gattc.c
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += %app_mw_ble_l2cap.c
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += %app_mw_nrf_soc.c

 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += %ser_softdevice_handler.c
endif

# Sources that only support s120
ifeq (,$(filter $(NRF51_SOFTDEVICE_VERSION),s120))
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += $(NRF51_SERIALIZATION_SRCDIR)application/codecs/s120/serializers/%
 NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER += $(NRF51_SERIALIZATION_SRCDIR)common/struct_ser/s120/%
endif

# Filter sources that depend on user boards.h
NRF51_SERIALIZATION_SRC_FILTER_USERBOARDS ?= %hal/ser_app_hal_nrf51.c $(NRF51_SERIALIZATION_SRCDIR)common/transport/ser_phy/%

# Filter sources that depend on user boards.h
NRF51_SERIALIZATION_SRC_FILTER_OTHER ?= %ser_phy/ser_phy.c

NRF51_SERIALIZATION_SRC_FILES_FILTER ?= $(NRF51_SERIALIZATION_SRC_FILTER_OTHER) $(NRF51_SERIALIZATION_SRC_FILES_AUTO_FILTER) $(NRF51_SERIALIZATION_SRC_FILTER_USERBOARDS)

NRF51_SERIALIZATION_SRC_FILES_FULL ?= $(filter-out $(NRF51_SERIALIZATION_SRC_FILES_FILTER),$(foreach file,$(NRF51_SERIALIZATION_SRC_FILES),$(shell find $(NRF51_SERIALIZATION_SRCDIR) -type f -name "$(file)")))

NRF51_SERIALIZATION_AR ?= nRF51-$(NRF51_SERIALIZATION).a

NRF51_SERIALIZATION_OBJS ?= $(NRF51_SERIALIZATION_SRC_FILES_FULL:$(NRF51_SERIALIZATION_SRCDIR)%=$(NRF51_SERIALIZATION_BLDDIR)%.o)

NRF51_SERIALIZATION_OUT ?= $(BLD_LIBDIR)$(NRF51_SERIALIZATION_AR)

NRF51_SERIALIZATION_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_SERIALIZATION_GCCFLAGS_EXTRA)

AUTO_LIB += $(NRF51_SERIALIZATION_OUT)

NRF51_SERIALIZATION_TARGET ?= nRF51/serialization

AUTO_GENERATED_FILES += $(NRF51_SERIALIZATION_OUT) $(NRF51_SERIALIZATION_OBJS) $(NRF51_SERIALIZATION_DEPFILES)

##### Targets

$(NRF51_SERIALIZATION_BLDDIR)%.c.o: $(NRF51_SERIALIZATION_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_SERIALIZATION_GCCFLAGS_FINAL)

$(NRF51_SERIALIZATION_OUT): $(NRF51_SERIALIZATION_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_SERIALIZATION_OBJS)

$(NRF51_SERIALIZATION_OUT) $(NRF51_SERIALIZATION_OBJS): $(MAKEFILE_LIST)

$(NRF51_SERIALIZATION_TARGET): $(NRF51_SERIALIZATION_OUT)

.PHONY: $(NRF51_SERIALIZATION_TARGET)
.PRECIOUS: $(NRF51_SERIALIZATION_OBJS)
.SECONDARY: $(NRF51_SERIALIZATION_OUT)

# Explicitly include all our build dep files
NRF51_SERIALIZATION_DEPFILES = $(NRF51_SERIALIZATION_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51_SERIALIZATION_DEPFILES)

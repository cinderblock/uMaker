


nRF51SDK_SourcePath ?= $(nRF51SDK_BasePath)components/

# This matches the folder name that Nordic assigns
NRF51_BLE ?= ble

NRF51_BLE_SRCDIR ?= $(nRF51SDK_SourcePath)$(NRF51_BLE)/

NRF51_BLE_BLDDIR ?= $(Build_Path)nRF51/$(NRF51_BLE)/

# Only automatically build certain files if we're using a soft device
ifneq (,$(filter $(NRF51_SOFTDEVICE_VERSION),s110 s120 s130 s210 s310))
 # Names of nRF51 source files to "find" and include
 NRF51_BLE_C ?= *
endif

NRF51_BLE_SRC_FILES ?= $(NRF51_BLE_C:%=%.c)

# BUGFIX: Broken nRF51 sources
NRF51_BLE_SRC_FILES_BROKEN ?= %ble_services/ble_sps/ble_sps.c

# TODO: Handle this better
# If the user isn't using a multi-device soft device, don't build device_manager_central.c
ifneq (,$(filter $(NRF51_SOFTDEVICE_VERSION),s110))
 NRF51_BLE_SRC_FILES_AUTO_FILTER += %ble/device_manager/device_manager_central.c
endif

# Filter broken sources and others
NRF51_BLE_SRC_FILES_FILTER ?= $(NRF51_BLE_SRC_FILES_BROKEN) $(NRF51_BLE_SRC_FILES_AUTO_FILTER)

NRF51_BLE_SRC_FILES_FULL ?= $(filter-out $(NRF51_BLE_SRC_FILES_FILTER),$(foreach file,$(NRF51_BLE_SRC_FILES),$(shell find $(NRF51_BLE_SRCDIR) -type f -name "$(file)")))

NRF51_BLE_AR ?= nRF51-$(NRF51_BLE).a

NRF51_BLE_OBJS ?= $(NRF51_BLE_SRC_FILES_FULL:$(NRF51_BLE_SRCDIR)%=$(NRF51_BLE_BLDDIR)%.o)

NRF51_BLE_OUT ?= $(Build_LibPath)$(NRF51_BLE_AR)

NRF51_BLE_GCCFLAGS_FINAL ?= $(Build_Flags_GCC_Final) $(NRF51_BLE_GCCFLAGS_EXTRA)

AUTO_LIB += $(NRF51_BLE_OUT)

NRF51_BLE_TARGET ?= nRF51/BLE

AUTO_GENERATED_FILES += $(NRF51_BLE_OUT) $(NRF51_BLE_OBJS) $(NRF51_BLE_DEPFILES)

# Nordic's ble_cgm.c references constants that have been removed
ifneq (,$(findstring ble_cgm.c,$(NRF51_BLE_SRC_FILES_FULL)))
 NRF51_BLE_MISSING_DEFS_AUTO += CGM_MEASUREMENT_CHAR=0x2A6C
 NRF51_BLE_MISSING_DEFS_AUTO += CGM_FEATURES_CHAR=0x2A6D
 NRF51_BLE_MISSING_DEFS_AUTO += CGM_STATUS_CHAR=0x2A6E
 NRF51_BLE_MISSING_DEFS_AUTO += CGM_SESSION_START_TIME_CHAR=0x2A6F
 NRF51_BLE_MISSING_DEFS_AUTO += CGM_APPLICATION_SECURITY_POINT_CHAR=0x2A70
 NRF51_BLE_MISSING_DEFS_AUTO += CGM_SPECIFIC_OPS_CONTROL_POINT_CHAR=0x2A71
 NRF51_BLE_MISSING_DEFS_AUTO += BLE_UUID_CGM_SERVICE=0x181A
endif

AUTO_DEF += $(NRF51_BLE_MISSING_DEFS_AUTO)

##### Targets

$(NRF51_BLE_BLDDIR)%.c.o: $(NRF51_BLE_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_BLE_GCCFLAGS_FINAL)

$(NRF51_BLE_OUT): $(NRF51_BLE_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_BLE_OBJS)

$(NRF51_BLE_OUT) $(NRF51_BLE_OBJS): $(MAKEFILE_LIST)

$(NRF51_BLE_TARGET): $(NRF51_BLE_OUT)

.PHONY: $(NRF51_BLE_TARGET)
.PRECIOUS: $(NRF51_BLE_OBJS)
.SECONDARY: $(NRF51_BLE_OUT)

# Explicitly include all our build dep files
NRF51_BLE_DEPFILES = $(NRF51_BLE_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(NRF51_BLE_DEPFILES)

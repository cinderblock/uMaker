


nRF51SDK_SourcePath ?= $(nRF51SDK_BasePath)components/

# This matches the folder name that Nordic assigns
NRF51_LIBRARIES ?= libraries

NRF51_LIBRARIES_SRCDIR ?= $(nRF51SDK_SourcePath)$(NRF51_LIBRARIES)/

NRF51_LIBRARIES_BLDDIR ?= $(Build_Path)nRF51/$(NRF51_LIBRARIES)/

# List of ALL possible nRF51 Libraries
nRF51_Libraries_Auto_All =

nRF51_Libraries_Auto_All += ant_fs/antfs
nRF51_Libraries_Auto_All += ant_fs/crc
nRF51_Libraries_Auto_All += bootloader_dfu/bootloader
nRF51_Libraries_Auto_All += bootloader_dfu/bootloader_settings_arm
nRF51_Libraries_Auto_All += bootloader_dfu/bootloader_util_arm
nRF51_Libraries_Auto_All += bootloader_dfu/bootloader_util_gcc
nRF51_Libraries_Auto_All += bootloader_dfu/dfu_dual_bank
nRF51_Libraries_Auto_All += bootloader_dfu/dfu_init_template
nRF51_Libraries_Auto_All += bootloader_dfu/dfu_single_bank
nRF51_Libraries_Auto_All += bootloader_dfu/dfu_transport_ble
nRF51_Libraries_Auto_All += bootloader_dfu/dfu_transport_serial
nRF51_Libraries_Auto_All += bootloader_dfu/experimental/dfu_app_handler
nRF51_Libraries_Auto_All += button/app_button
nRF51_Libraries_Auto_All += console/console
nRF51_Libraries_Auto_All += crc16/crc16
nRF51_Libraries_Auto_All += fifo/app_fifo
nRF51_Libraries_Auto_All += gpiote/app_gpiote
nRF51_Libraries_Auto_All += gpiote/app_gpiote_fast_detect
nRF51_Libraries_Auto_All += hci/hci_mem_pool
nRF51_Libraries_Auto_All += hci/hci_slip
nRF51_Libraries_Auto_All += hci/hci_transport
nRF51_Libraries_Auto_All += scheduler/app_scheduler
nRF51_Libraries_Auto_All += scheduler/app_scheduler_serconn
nRF51_Libraries_Auto_All += sensorsim/ble_sensorsim
nRF51_Libraries_Auto_All += timer/app_timer
nRF51_Libraries_Auto_All += timer/app_timer_ble_gzll
nRF51_Libraries_Auto_All += timer/app_timer_freertos
nRF51_Libraries_Auto_All += timer/app_timer_rtx
nRF51_Libraries_Auto_All += trace/app_trace
nRF51_Libraries_Auto_All += uart/retarget
nRF51_Libraries_Auto_All += util/app_error
nRF51_Libraries_Auto_All += util/app_util_platform
nRF51_Libraries_Auto_All += util/nrf_assert

# List of sane default libraries
nRF51_Libraries_Auto =

# Check if the user wants to use the nRF51 SDK's ANT libraries
ifneq ($(nRF51_Libraries_Use_ANT),)
 nRF51_Libraries_Auto_ANT  = ant_fs/antfs
 nRF51_Libraries_Auto_ANT += ant_fs/crc

 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_ANT)
endif

# Check if the user wants to use the nRF51 SDK's DFU bootloader libraries
ifneq ($(nRF51_Libraries_Use_DFU),)
 nRF51_Libraries_Auto_DFU  = bootloader_dfu/bootloader
# nRF51_Libraries_Auto_DFU += bootloader_dfu/bootloader_settings_arm
# nRF51_Libraries_Auto_DFU += bootloader_dfu/bootloader_util_arm
 nRF51_Libraries_Auto_DFU += bootloader_dfu/bootloader_util_gcc
 nRF51_Libraries_Auto_DFU += bootloader_dfu/dfu_dual_bank
 nRF51_Libraries_Auto_DFU += bootloader_dfu/dfu_init_template
 nRF51_Libraries_Auto_DFU += bootloader_dfu/dfu_single_bank
# nRF51_Libraries_Auto_DFU += bootloader_dfu/dfu_transport_ble
 nRF51_Libraries_Auto_DFU += bootloader_dfu/dfu_transport_serial
 nRF51_Libraries_Auto_DFU += bootloader_dfu/experimental/dfu_app_handler

 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_DFU)
endif

# Check if the user wants to use the nRF51 SDK's button library
ifneq ($(nRF51_Libraries_Use_Button),)
 nRF51_Libraries_Auto_Button = button/app_button
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_Button)
endif

# Check if the user wants to use the nRF51 SDK's crc16 library
ifneq ($(nRF51_Libraries_Use_CRC16),)
 nRF51_Libraries_Auto_CRC16 = crc16/crc16
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_CRC16)
endif

# Check if the user wants to use the nRF51 SDK's FIFO library
ifneq ($(nRF51_Libraries_Use_FIFO),)
 nRF51_Libraries_Auto_FIFO = fifo/app_fifo
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_FIFO)
endif

# Check if the user wants to use the nRF51 SDK's GPIOTE handler
ifneq ($(nRF51_Libraries_Use_GPIOTE),)

# If UseGPIOTE is set to either "normal" or "true", use the standard GPIOTE handler
ifneq (,$(filter $(nRF51_Libraries_Use_GPIOTE),normal true))
 nRF51_Libraries_Auto_GPIOTE = gpiote/app_gpiote
else
 nRF51_Libraries_Auto_GPIOTE = gpiote/app_gpiote_$(nRF51_Libraries_Use_GPIOTE)
# nRF51_Libraries_Auto_GPIOTE += gpiote/app_gpiote_fast_detect
endif

nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_GPIOTE)

endif

# Check if the user wants to use the nRF51 SDK's HCI library
ifneq ($(nRF51_Libraries_Use_HCI),)
 nRF51_Libraries_Auto_HCI = hci/hci_mem_pool hci/hci_slip hci/hci_transport
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_HCI)
endif

# Check if the user wants to use the nRF51 SDK's Scheduler library
ifneq ($(nRF51_Libraries_Use_Scheduler),)

# If Use_Scheduler is set to either "normal" or "true", use the standard scheduler
ifneq (,$(filter $(nRF51_Libraries_Use_Scheduler),normal true))
 nRF51_Libraries_Auto_Scheduler = scheduler/app_scheduler
else
 nRF51_Libraries_Auto_Scheduler = scheduler/app_scheduler_$(nRF51_Libraries_Use_Scheduler)
# nRF51_Libraries_Auto_Scheduler = scheduler/app_scheduler_serconn
endif

 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_Scheduler)
endif

# Check if the user wants to use the nRF51 SDK's SensorSim library
ifneq ($(nRF51_Libraries_Use_SensorSim),)
 nRF51_Libraries_Auto_SensorSim = sensorsim/ble_sensorsim
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_SensorSim)
endif

# Check if the user wants to use the nRF51 SDK's Timer library
ifneq ($(nRF51_Libraries_Use_Timer),)

# If Use_Timer is set to either "normal" or "true", use the standard timer
ifneq (,$(filter $(nRF51_Libraries_Use_Timer),normal true))
 nRF51_Libraries_Auto_Timer = timer/app_timer
else
 nRF51_Libraries_Auto_Timer = timer/app_timer_$(nRF51_Libraries_Use_Timer)
# nRF51_Libraries_Auto_Timer = timer/app_timer_ble_gzll
# nRF51_Libraries_Auto_Timer = timer/app_timer_freertos
# nRF51_Libraries_Auto_Timer = timer/app_timer_rtx
endif

nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_Timer)

endif

# Check if the user wants to use the nRF51 SDK's Trace library
ifneq ($(nRF51_Libraries_Use_Trace),)
 nRF51_Libraries_Auto_Trace = trace/app_trace
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_Trace)
endif

# Check if the user wants to use the nRF51 SDK's printf redirect library
ifneq ($(nRF51_Libraries_Use_Retarget),)
 nRF51_Libraries_Auto_Retarget = uart/retarget
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_Retarget)
endif

# Check if the user wants to use the nRF51 SDK's utils
ifneq ($(nRF51_Libraries_Use_Utils),)
 nRF51_Libraries_Auto_Utils = util/app_error util/app_util_platform util/nrf_assert
 nRF51_Libraries_Auto += $(nRF51_Libraries_Auto_Utils)
endif

# Filter arm (aka KEIL I think) sources
NRF51_LIBRARIES_SRC_KEIL_FILTER ?= %arm.c

# BUGFIX: Broken nRF51 sources
NRF51_LIBRARIES_SRC_FILES_OLD ?= %console/console.c

NRF51_LIBRARIES_Files ?= $(nRF51_Libraries_Auto)

# Names of nRF51 source files to "find" and include
NRF51_LIBRARIES_C ?= $(NRF51_LIBRARIES_Files)

NRF51_LIBRARIES_SRC_FILES ?= $(NRF51_LIBRARIES_C:%=%.c)

# Filter certain sources by default
NRF51_LIBRARIES_SRC_FILES_FILTER ?= $(NRF51_LIBRARIES_SRC_FILES_OLD) $(NRF51_LIBRARIES_SRC_KEIL_FILTER)

NRF51_LIBRARIES_SRC_FILES_FULL ?= $(filter-out $(NRF51_LIBRARIES_SRC_FILES_FILTER),$(NRF51_LIBRARIES_SRC_FILES:%=$(NRF51_LIBRARIES_SRCDIR)%))

NRF51_LIBRARIES_AR ?= nRF51-$(NRF51_LIBRARIES).a

NRF51_LIBRARIES_OBJS ?= $(NRF51_LIBRARIES_SRC_FILES_FULL:$(NRF51_LIBRARIES_SRCDIR)%=$(NRF51_LIBRARIES_BLDDIR)%.o)

NRF51_LIBRARIES_OUT ?= $(Build_LibPath)$(NRF51_LIBRARIES_AR)

NRF51_LIBRARIES_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_LIBRARIES_GCCFLAGS_EXTRA)

AUTO_LIB += $(NRF51_LIBRARIES_OUT)

NRF51_LIBRARIES_TARGET ?= nRF51/libraries

AUTO_GENERATED_FILES += $(NRF51_LIBRARIES_OUT) $(NRF51_LIBRARIES_OBJS) $(NRF51_LIBRARIES_DEPFILES)

##### Targets

$(NRF51_LIBRARIES_BLDDIR)%.c.o: $(NRF51_LIBRARIES_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_LIBRARIES_GCCFLAGS_FINAL)

$(NRF51_LIBRARIES_OUT): $(NRF51_LIBRARIES_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_LIBRARIES_OBJS)

$(NRF51_LIBRARIES_OUT) $(NRF51_LIBRARIES_OBJS): $(MAKEFILE_LIST)

$(NRF51_LIBRARIES_TARGET): $(NRF51_LIBRARIES_OUT)

.PHONY: $(NRF51_LIBRARIES_TARGET)
.PRECIOUS: $(NRF51_LIBRARIES_OBJS)
.SECONDARY: $(NRF51_LIBRARIES_OUT)

# Explicitly include all our build dep files
NRF51_LIBRARIES_DEPFILES = $(NRF51_LIBRARIES_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(NRF51_LIBRARIES_DEPFILES)

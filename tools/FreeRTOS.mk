FreeRTOS_Port ?= ATMega323

FreeRTOS_Base_Path ?= freertos/FreeRTOS/

FreeRTOS_Source_Path ?= $(FreeRTOS_Base_Path)Source/
FreeRTOS_Include_Dir ?= $(FreeRTOS_Source_Path)include

FreeRTOS_Port_Path ?= $(FreeRTOS_Source_Path)portable/GCC/$(FreeRTOS_Port)/

FreeRTOS_Build_Path ?= $(Build_Path)FreeRTOS/

# Folder that has your `portmacro.h`
FreeRTOS_PortInc_Dir ?= $(Source_Path)FreeRTOSinc
FreeRTOS_PortInc_Path ?= $(FreeRTOS_PortInc_Dir)/
FreeRTOS_Portmacro_Name ?= portmacro.h

FreeRTOS_Portmacro_File ?= $(FreeRTOS_PortInc_Path)$(FreeRTOS_Portmacro_Name)

FreeRTOS_PortDefinitions_Path ?= $(Source_Path)
FreeRTOS_PortDefinitions_Name ?= FreeRTOSPortDefinitions.c
FreeRTOS_PortDefinitions_File ?= $(FreeRTOS_PortDefinitions_Path)$(FreeRTOS_PortDefinitions_Name)

# Relative to FreeRTOS_Source_Path
FreeRTOS_cFiles ?= croutine event_groups list queue tasks timers portable/MemMang/heap_4
FreeRTOS_Source_cFilenames ?= $(FreeRTOS_cFiles:%=%.c)

FreeRTOS_Archive_Name ?= FreeRTOS.a

FreeRTOS_Objects ?= $(FreeRTOS_Source_cFilenames:%=$(FreeRTOS_Build_Path)%.o)

FreeRTOS_Build_Out ?= $(Build_LibPath)$(FreeRTOS_Archive_Name)

FreeRTOS_Build_Flags_GCC_Final ?= $(Build_Flags_GCC_Final) $(FREERTOS_GCCFLAGS_EXTRA)

AUTO_INC += $(FreeRTOS_Include_Dir) $(FreeRTOS_PortInc_Dir)

AUTO_LIB += $(FreeRTOS_Build_Out)

# TODO: Fix AUTO_GCC when Source_Dir is not .
#AUTO_GCC += $(FreeRTOS_PortDefinitions_File)

FreeRTOS_Target ?= FreeRTOS-lib

##### Targets

$(FreeRTOS_PortDefinitions_File): | $(dir $(FreeRTOS_PortDefinitions_File)) $(FreeRTOS_Port_Path)port.c
	$(ECO) "FreeRTOS init	$@"
	cp -u $(FreeRTOS_Port_Path)port.c $@

$(FreeRTOS_Portmacro_File): | $(dir $(FreeRTOS_Portmacro_File)) $(FreeRTOS_Port_Path)portmacro.h
	$(ECO) "FreeRTOS init	$@"
	cp -u $(FreeRTOS_Port_Path)portmacro.h $@

$(FreeRTOS_PortDefinitions_File:$(Source_Path)%=$(Build_Path)%.o): | $(FreeRTOS_Portmacro_File)

$(FreeRTOS_Build_Path)%.c.o: $(FreeRTOS_Source_Path)%.c | $(FreeRTOS_Portmacro_File)
	$(ECO) "FreeRTOS CC $@"
	$(BLD_GCC) $< -o $@ -c $(FreeRTOS_Build_Flags_GCC_Final)

$(FreeRTOS_Build_Out): $(FreeRTOS_Objects)
	$(ECO) "FreeRTOS AR	$@"
	$(BLD_ARR) $@ $(FreeRTOS_Objects)

$(FreeRTOS_Build_Out) $(FreeRTOS_Objects): | $(MAKEFILE_LIST)

$(FreeRTOS_Target): $(FreeRTOS_Build_Out)

.PHONY: $(FreeRTOS_Target)
.PRECIOUS: $(FreeRTOS_Objects)
.SECONDARY: $(FreeRTOS_Build_Out)

# Explicitly include all our build dep files
FreeRTOS_DepFiles = $(FreeRTOS_Objects:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(FreeRTOS_DepFiles)

AUTO_GENERATED_FILES += $(FreeRTOS_Build_Out) $(FreeRTOS_Objects) $(FreeRTOS_DepFiles) $(FreeRTOS_Portmacro_File) $(FreeRTOS_PortDefinitions_File)

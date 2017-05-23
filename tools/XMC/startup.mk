
XMC_Startup_BasePath ?= $(XMC_InitialStart_BasePath)
XMC_Startup_SourcePath ?= Startup/

XMC_Startup_ObjectPath ?= $(Build_Path)XMC/Startup/

XMC_Startup_FullSourcePath ?= $(XMC_Startup_BasePath)$(XMC_Startup_SourcePath)

XMC_Startup_SystemC_Name = system_XMC1100.c
XMC_Startup_StartupASM_Name = startup_XMC1100.S

XMC_Startup_Sources_C ?= $(XMC_Startup_FullSourcePath)$(XMC_Startup_SystemC_Name)
XMC_Startup_Sources_ASM ?= $(XMC_Startup_FullSourcePath)$(XMC_Startup_StartupASM_Name)

XMC_Startup_Sources ?= $(XMC_Startup_Sources_C) $(XMC_Startup_Sources_ASM)

XMC_Startup_ArchiveName ?= XMC-Startup.a

XMC_Startup_Objects ?= $(XMC_Startup_Sources:$(XMC_Startup_FullSourcePath)%=$(XMC_Startup_ObjectPath)%.o)

XMC_Startup_Out ?= $(Build_LibPath)$(XMC_Startup_ArchiveName)

XMC_Startup_Build_Flags_GCC ?= 

XMC_Startup_Build_Flags_GCC_Final ?= $(Build_Flags_GCC_Final) $(XMC_Startup_Build_Flags_GCC) $(XMC_Startup_Build_Flags_GCC_Extra)

XMC_Startup_Build_Flags_ASM_Final ?= $(Build_Flags_ASM_Final) $(XMC_Startup_Build_Flags_ASM_Extra)

AUTO_LIB += $(XMC_Startup_Out)

XMC_Startup_Target ?= XMC/Startup

AUTO_GENERATED_FILES += $(XMC_Startup_Out) $(XMC_Startup_Objects) $(XMC_Startup_DepFiles)

XMC_Startup_Build_DepPath ?= $(Build_DepPath)XMC/Startup/

##### Targets

$(XMC_Startup_ObjectPath)%.c.o: $(XMC_Startup_FullSourcePath)%.c
	$(ECO) "XMC Startup C	$@"
	$(BLD_GCC) $< -o $@ -c $(XMC_Startup_Build_Flags_GCC_Final)
	
$(XMC_Startup_ObjectPath)%.S.o: $(XMC_Startup_FullSourcePath)%.S
	$(ECO) "XMC Startup ASM	$@"
	$(BLD_GCC) $< -o $@ -c $(XMC_Startup_Build_Flags_ASM_Final)

$(XMC_Startup_Out): $(XMC_Startup_Objects)
	$(ECO) "XMC Startup Archive	$@"
	$(BLD_ARR) $@ $(XMC_Startup_Objects)

$(XMC_Startup_Out) $(XMC_Startup_Objects): $(MAKEFILE_LIST)

$(XMC_Startup_Target): $(XMC_Startup_Out)

.PHONY: $(XMC_Startup_Target)
.PRECIOUS: $(XMC_Startup_Objects)
.SECONDARY: $(XMC_Startup_Out)

# Explicitly include all our build dep files
XMC_Startup_DepFiles = $(XMC_Startup_Objects:$(XMC_Startup_ObjectPath)%=$(XMC_Startup_Build_DepPath)%.d)
-include $(XMC_Startup_DepFiles)

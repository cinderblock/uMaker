
InfineonMemtool_ComPort ?= COM1

InfineonMemtool_TargetDescription ?= $(TARGET) ($(InfineonMemtool_Build_TargetSettings_Fullname))

XMC_PartNumber ?= XMC1202-T016X0032

InfineonMemtool_MemtoolPath ?= C:/Program Files (x86)/Infineon/Memtool 4.7/

InfineonMemtool_Target ?= infineon-memtool

InfineonMemtool_OutPath ?= ${Build_Path}memtool/

InfineonMemtool_MemtoolBin_Filename ?= IMTMemtool.exe

InfineonMemtool_MemtoolBin ?= "$(InfineonMemtool_MemtoolPath)$(InfineonMemtool_MemtoolBin_Filename)"

InfineonMemtool_BuildAbsolutePath ?= $(abspath $(InfineonMemtool_OutPath))/

InfineonMemtool_AssetPath ?= ${uMakerPath}assets/infineon-memtool/

InfineonMemtool_Template_LoadScript_Filename ?= load-script.template.mtb
InfineonMemtool_Template_ProjectSettings_Filename ?= project-settings.imt.template.cfg
InfineonMemtool_Template_TargetSettings_Filename ?= target-settings.template.cfg

InfineonMemtool_Build_LoadScript_Filename ?= load-script.mtb
InfineonMemtool_Build_ProjectSettings_Filename ?= project-settings.imt
InfineonMemtool_Build_TargetSettings_Filename ?= target-settings.cfg

InfineonMemtool_Template_LoadScript_Fullname ?= $(InfineonMemtool_AssetPath)$(InfineonMemtool_Template_LoadScript_Filename)
InfineonMemtool_Template_ProjectSettings_Fullname ?= $(InfineonMemtool_AssetPath)$(InfineonMemtool_Template_ProjectSettings_Filename)
InfineonMemtool_Template_TargetSettings_Fullname ?= $(InfineonMemtool_AssetPath)$(InfineonMemtool_Template_TargetSettings_Filename)

InfineonMemtool_Build_LoadScript_Fullname ?= $(InfineonMemtool_OutPath)$(InfineonMemtool_Build_LoadScript_Filename)
InfineonMemtool_Build_ProjectSettings_Fullname ?= $(InfineonMemtool_OutPath)$(InfineonMemtool_Build_ProjectSettings_Filename)
InfineonMemtool_Build_TargetSettings_Fullname ?= $(InfineonMemtool_OutPath)$(InfineonMemtool_Build_TargetSettings_Filename)

InfineonMemtool_Build_Files ?= $(InfineonMemtool_Build_LoadScript_Fullname) $(InfineonMemtool_Build_ProjectSettings_Fullname) $(InfineonMemtool_Build_TargetSettings_Fullname)

# Replacement values need to be suitable for usaing inside a sed script; slashes (/) escaped

InfineonMemtool_OutHex_abs ?= $(abspath $(OUT_HEX))
InfineonMemtool_OutHex_absLetter ?= $(subst /,\\,$(InfineonMemtool_OutHex_abs:/c%=C:%))

# Example value:
InfineonMemtool_Build_LoadScript_Replacement_HEXFILE_ABSOLUTE ?= $(InfineonMemtool_OutHex_absLetter)

# Relative to Memtool settings file
# Example value: target-settings.cfg
InfineonMemtool_Build_ProjectSettings_Replacement_TARGETSETTINGS_FILENAME ?= $(subst /,\/,$(InfineonMemtool_Build_TargetSettings_Filename))

# Anything really
InfineonMemtool_Build_TargetSettings_Replacement_MAIN_DESCRIPTION ?= $(subst /,\/,$(InfineonMemtool_TargetDescription))

# Example value: XMC1202-T016X0032
InfineonMemtool_Build_TargetSettings_Replacement_CONTROLLER_TYPE ?= $(XMC_PartNumber)

# Example value: COM4
InfineonMemtool_Build_TargetSettings_Replacement_COMPORT ?= $(InfineonMemtool_ComPort)

InfineonMemtool_Build_LoadScript_Replacements ?= -e 's/HEXFILE_ABSOLUTE/$(InfineonMemtool_Build_LoadScript_Replacement_HEXFILE_ABSOLUTE)/'
InfineonMemtool_Build_ProjectSettings_Replacements ?= -e 's/TARGET_INFO_FILE/$(InfineonMemtool_Build_ProjectSettings_Replacement_TARGETSETTINGS_FILENAME)/'
InfineonMemtool_Build_TargetSettings_Replacements ?= -e 's/MAIN_DESCRIPTION/$(InfineonMemtool_Build_TargetSettings_Replacement_MAIN_DESCRIPTION)/' -e 's/CONTROLLER_TYPE/$(InfineonMemtool_Build_TargetSettings_Replacement_CONTROLLER_TYPE)/' -e 's/COMPORT/$(InfineonMemtool_Build_TargetSettings_Replacement_COMPORT)/'

InfineonMemtool_Build_LoadScript_sedArgs ?= $(InfineonMemtool_Build_sedFlags) $(InfineonMemtool_Build_LoadScript_Replacements)
InfineonMemtool_Build_ProjectSettings_sedArgs ?= $(InfineonMemtool_Build_sedFlags) $(InfineonMemtool_Build_ProjectSettings_Replacements)
InfineonMemtool_Build_TargetSettings_sedArgs ?= $(InfineonMemtool_Build_sedFlags) $(InfineonMemtool_Build_TargetSettings_Replacements)

$(InfineonMemtool_Build_LoadScript_Fullname): $(InfineonMemtool_Template_LoadScript_Fullname)
	$(ECO) Memtool	$(InfineonMemtool_Build_LoadScript_Fullname)
	sed $(InfineonMemtool_Build_LoadScript_sedArgs) $< > $@

$(InfineonMemtool_Build_ProjectSettings_Fullname): $(InfineonMemtool_Template_ProjectSettings_Fullname)
	$(ECO) Memtool	$(InfineonMemtool_Build_ProjectSettings_Fullname)
	sed $(InfineonMemtool_Build_ProjectSettings_sedArgs) $< > $@

$(InfineonMemtool_Build_TargetSettings_Fullname): $(InfineonMemtool_Template_TargetSettings_Fullname)
	$(ECO) Memtool	$(InfineonMemtool_Build_TargetSettings_Fullname)
	sed $(InfineonMemtool_Build_TargetSettings_sedArgs) $< > $@


$(InfineonMemtool_Build_Files): $(MAKEFILE_LIST)

AUTO_GENERATED_FILES += $(InfineonMemtool_Build_Files)

 $(InfineonMemtool_Target)-files: $(InfineonMemtool_Build_Files)

$(InfineonMemtool_Target)-upload: $(OUT_HEX) $(InfineonMemtool_Target)-files
	$(ECO) Launching Memtool
	$(InfineonMemtool_MemtoolBin) $(InfineonMemtool_Build_LoadScript_Fullname)

.PHONY: $(InfineonMemtool_Target)-upload $(InfineonMemtool_Target)-files
.SECONDARY: $(InfineonMemtool_Build_Files)

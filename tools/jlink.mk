
jlink_Target ?= jlink

jlink_CommanderFilePath ?= $(Build_Path)
jlink_CommanderFileName ?= commands.jlink
jlink_CommanderFile ?= $(jlink_CommanderFilePath)$(jlink_CommanderFileName)

jlink_BinaryPath ?= 
jlink_BinaryName ?= JLink.exe
jlink_Binary ?= "$(jlink_BinaryPath)$(jlink_BinaryName)"

jlink_Args ?= -if swd -speed 100000

$(jlink_Target): $(OUT_HEX) $(jlink_CommanderFile)
	$(ECO) J-Link Load $(OUT_HEX) 
	$(jlink_Binary) $(jlink_Args) "$(jlink_CommanderFile)"

$(jlink_CommanderFile): $(MAKEFILE_LIST)
	$(ECO) Generating J-Link Commander File $(jlink_CommanderFile)
	@echo si 1 > $@
	@echo speed 3000 >> $@
	@echo device XMC1100-0064 >> $@
	@echo r >> $@
	@echo h >> $@
	@echo loadfile $(OUT_HEX) >> $@
	@echo g >> $@
	@echo q >> $@

AUTO_GENERATED_FILES += "$(jlink_CommanderFile)"

.PHONY: $(jlink_Target)

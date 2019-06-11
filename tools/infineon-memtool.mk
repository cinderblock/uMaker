
InfineonMemtool_ComPort ?= COM1

InfineonMemtool_TargetDescription ?= $(TARGET) ($(InfineonMemtool_Build_TargetSettings_Fullname))

XMC_PartNumber ?= XMC1202-T016X0032

InfineonMemtool_MemtoolPath ?= C:/Program Files (x86)/Infineon/Memtool 4.7/

InfineonMemtool_Target ?= infineon-memtool

InfineonMemtool_OutPath ?= ${Build_Path}memtool/

InfineonMemtool_MemtoolBin_Filename ?= IMTMemtool.exe

InfineonMemtool_MemtoolBin ?= "$(InfineonMemtool_MemtoolPath)$(InfineonMemtool_MemtoolBin_Filename)"

InfineonMemtool_BuildAbsolutePath ?= $(abspath $(InfineonMemtool_OutPath))/

InfineonMemtool_Build_LoadScript_Filename ?= load-script.mtb
InfineonMemtool_Build_ProjectSettings_Filename ?= project-settings.imt
InfineonMemtool_Build_TargetSettings_Filename ?= target-settings.cfg
InfineonMemtool_Build_MemtoolConfig_Filename ?= IMTMemtool.ini

InfineonMemtool_Build_LoadScript_Fullname ?= $(InfineonMemtool_OutPath)$(InfineonMemtool_Build_LoadScript_Filename)
InfineonMemtool_Build_ProjectSettings_Fullname ?= $(InfineonMemtool_OutPath)$(InfineonMemtool_Build_ProjectSettings_Filename)
InfineonMemtool_Build_TargetSettings_Fullname ?= $(InfineonMemtool_OutPath)$(InfineonMemtool_Build_TargetSettings_Filename)
InfineonMemtool_Build_MemtoolConfig_Fullname ?= $(InfineonMemtool_OutPath)$(InfineonMemtool_Build_MemtoolConfig_Filename)

InfineonMemtool_Build_MemtoolConfig_Final ?= "C:/Users/Cameron/Documents/Infineon/IMT 4.7/IMTMemtool.ini"

InfineonMemtool_Build_Files ?= $(InfineonMemtool_Build_LoadScript_Fullname) $(InfineonMemtool_Build_ProjectSettings_Fullname) $(InfineonMemtool_Build_TargetSettings_Fullname) $(InfineonMemtool_Build_MemtoolConfig_Fullname)

# Replacement values need to be suitable for usaing inside a sed script; slashes (/) escaped

InfineonMemtool_OutHex_abs ?= $(abspath $(OUT_HEX))
InfineonMemtool_OutHex_absLetter ?= $(subst /,\,$(InfineonMemtool_OutHex_abs:/c%=C:%))

# Example value:
InfineonMemtool_Build_LoadScript_Replacement_HEXFILE_ABSOLUTE ?= $(InfineonMemtool_OutHex_absLetter)

# Relative to Memtool settings file
# Example value: target-settings.cfg
InfineonMemtool_Build_ProjectSettings_Replacement_TARGETSETTINGS_FILENAME ?= $(InfineonMemtool_Build_TargetSettings_Filename)

# Anything really
InfineonMemtool_Build_TargetSettings_Replacement_MAIN_DESCRIPTION ?= $(InfineonMemtool_TargetDescription)

# Example value: XMC1202-T016X0032
InfineonMemtool_Build_TargetSettings_Replacement_CONTROLLER_TYPE ?= $(XMC_PartNumber)

# Example value: COM4
InfineonMemtool_Build_TargetSettings_Replacement_COMPORT ?= $(InfineonMemtool_ComPort)


$(InfineonMemtool_Build_LoadScript_Fullname):
	$(ECO) Memtool	$(InfineonMemtool_Build_LoadScript_Fullname)
	echo "$$IMT_LOAD_SCRIPT" > $@

$(InfineonMemtool_Build_ProjectSettings_Fullname):
	$(ECO) Memtool	$(InfineonMemtool_Build_ProjectSettings_Fullname)
	echo "$$IMT_PROJECT_SETTINGS" > $@

$(InfineonMemtool_Build_TargetSettings_Fullname):
	$(ECO) Memtool	$(InfineonMemtool_Build_TargetSettings_Fullname)
	echo "$$IMT_TARGET_SETTINGS" > $@

$(InfineonMemtool_Build_MemtoolConfig_Fullname):
	$(ECO) Memtool	$(InfineonMemtool_Build_MemtoolConfig_Fullname)
	echo "$$IMT_CONFIG_SETTINGS" > $@

$(InfineonMemtool_Target)-ini: $(InfineonMemtool_Build_MemtoolConfig_Fullname)
	cp $(InfineonMemtool_Build_MemtoolConfig_Fullname) $(InfineonMemtool_Build_MemtoolConfig_Final)

$(InfineonMemtool_Build_Files): $(MAKEFILE_LIST)

AUTO_GENERATED_FILES += $(InfineonMemtool_Build_Files)

$(InfineonMemtool_Target)-files: $(InfineonMemtool_Build_Files)

$(InfineonMemtool_Target)-upload: $(OUT_HEX) $(InfineonMemtool_Target)-files $(InfineonMemtool_Target)-ini
	$(ECO) Launching Memtool
	$(InfineonMemtool_MemtoolBin) $(InfineonMemtool_Build_LoadScript_Fullname)

.PHONY: $(InfineonMemtool_Target)-upload $(InfineonMemtool_Target)-files $(InfineonMemtool_Target)-ini
.SECONDARY: $(InfineonMemtool_Build_Files)

# For generating `.mtb` file for memtool
define IMT_LOAD_SCRIPT
open_file $(InfineonMemtool_Build_LoadScript_Replacement_HEXFILE_ABSOLUTE)
select_all_sections
add_selected_sections
connect
program
disconnect
exit
endef
export IMT_LOAD_SCRIPT

# For generating `.imt` project settings file
define IMT_PROJECT_SETTINGS
[Main]
Signature=IMT_MEMTOOL_1.0
Version=4.7
Logo=1
AutoConnect=0
AutoReopen=1
LastFileExt=hex
TargInfoFile=$(InfineonMemtool_Build_ProjectSettings_Replacement_TARGETSETTINGS_FILENAME)
LastHexMode=0
LastFillSize=0
LastFillPatt=0
ShowExecTime=0
ShowLog=1
LogLevel=75
DiagLog=0
BeepOnFail=1
PeriodRetry=0
RetryTime=2
LastModule=0
VerifyProt=0
VerifyProtFile=verify.txt
AllowOverwrite=0
IgnoreErrorsInHexFiles=0
LookForOtherCommDevs=0
IgnoreReadMemErrors=0
IgnoreMappingErrors=0
SkipLockedSectors=0
BinReadStart=0x0
BinReadSize=0x0
ReqCoreName=
LastFileSecSel=all
DlgFrame=1,1402,709,1865,1558
LogFrame=2,220,599,1789,3479
[Memtool0.FlashMod_PFLASH]
Enabled=1
AdvancedRemap=0
RemapRead=1
AllowOverwrite=1
UserRemap=0
RunTimeStart=0xFFFFFFFF
AutoChipErase=1
AutoErase=0
SimulateRAM=0
AutoVerify=1
AutoChipProt=0
SkipUnchangedSectors=0
FillGaps=0
FillByte=-1
AutoSetBootMode=1
AbmHeaderHandling=0
AbmHeader1=
AbmHeader2=
HsmVectabHandling=0
HsmVectab1=
HsmVectab2=
Driver=
DrvStart=0xFFFFFFFF
DrvExecAddr=0xFFFFFFFF
VerifyDrv=1
BakDrvRam=0
TrBufSize=0xFFFFFFFF
TrBufStart=0xFFFFFFFF
VerifyTrBuf=0
CheckTrBuf=0
TryReadCfi=0
VerifyByCrc=1
MarginControl=0
DisableProtection=0
ExcludeDflashFromProtection=0
BmiCfg=65488
endef
export IMT_PROJECT_SETTINGS

# For generating `.cfg` target settings file
define IMT_TARGET_SETTINGS
[Main]
Signature=UDE_TARGINFO_2.0
Description=$(InfineonMemtool_Build_TargetSettings_Replacement_MAIN_DESCRIPTION)
MCUs=Controller0
[Controller0]
Family=ARM
Type=$(InfineonMemtool_Build_TargetSettings_Replacement_CONTROLLER_TYPE)
Enabled=1
IntClock=64000
ExtClock=8000
[Controller0.CORTEX]
Protocol=MINIMON
Enabled=1
[Controller0.CORTEX.MiniMonTargIntf]
PortType=COMX
PortSel=$(InfineonMemtool_Build_TargetSettings_Replacement_COMPORT)
ReqReset=0
ReqResetMsg=
ResetOnConnect=1
ResetWaitTime=500
ExecInitCmds=0
ExtStartMode=0
BaudRate=9600
KLineProt=0
UseRS232Drv=1
CanPortNum=1
AssureSendOfComPort=0
Stm32AscBaudrateForConnect=0
MonType=ASC
CheckAckCode=1
AlwaysEINIT=0
UseExtMon=0
MonitorPath=
UseExtMon2=0
Mon2Path=
Mon2Start=0xFFFFFFFF
SCRMSupport=0
SCRMBaudRate=0
RSTCON_H=0x0
S0BRL=-1
UseChangedBaudRate=0
Sv2PLLCON=0x7103
Sv2ASC0BG=0xFFFF
Sv2CANBTR=0xFFFF
TcPllValue=0x0
TcPllValue2=0x0
TcPllValue3=0x0
TcAscBgValue=0x0
TcCanBtrValue=0x0
XC2000ScrmClock=40000000
MaxReadBlockSize=0
BootPasswd0=0xFEEDFACE
BootPasswd1=0xCAFEBEEF
AurixEdBootWorkaround=0
OnConnect0=clr RTS
OnConnect1=wait 100
OnConnect2=set RTS

[Controller0.CORTEX.MiniMonTargIntf.InitScript]
[Controller0.PFLASH]
Enabled=1
EnableMemtoolByDefault=1
[Controller0.CORTEX.LoadedAddOn]
UDEMemtool=1
endef
export IMT_TARGET_SETTINGS

# For generating `.cfg` target settings file
define IMT_CONFIG_SETTINGS
[Main]
Logo=1
AutoConnect=1
AutoReopen=1
LastFileExt=hex
TargInfoFile=$(InfineonMemtool_Build_TargetSettings_Fullname)
LastHexMode=0
LastFillSize=0
LastFillPatt=0
ShowExecTime=0
ShowLog=1
LogLevel=75
DiagLog=0
BeepOnFail=1
PeriodRetry=0
RetryTime=2
LastModule=0
VerifyProt=0
VerifyProtFile=verify.txt
AllowOverwrite=0
IgnoreErrorsInHexFiles=0
LookForOtherCommDevs=0
IgnoreReadMemErrors=0
IgnoreMappingErrors=0
SkipLockedSectors=0
BinReadStart=0x0
BinReadSize=0x0
ReqCoreName=
LastFileSecSel=all
DlgFrame=1,1229,1055,1692,1904
LogFrame=1,291,264,1860,3144
endef
export IMT_CONFIG_SETTINGS

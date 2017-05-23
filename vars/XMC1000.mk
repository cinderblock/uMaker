XMC_Device ?= XMC1200

GCC_VERSION ?= 4.9.3
GCC_ROOT    ?= C:/Progra~2/GNUTOO~1/50A5A~1.420/
GCC_PREFIX  ?= arm-none-eabi

XMC_InitialStart_BasePath ?= XMC/

AUTO_INC += $(XMC_InitialStart_BasePath)Libraries/CMSIS/Infineon/XMC1100_series/Include
AUTO_INC += $(XMC_InitialStart_BasePath)Libraries/CMSIS/Include

AUTO_GCC += $(XMC_InitialStart_BasePath)Libraries/Newlib/syscalls.c

## Setup final flags we're going to use

# Don't forget to include your Source_Path
INCLUDES ?= $(if $(Source_Path),$(Source_Path:%/=%),.)

CPU ?= cortex-m0

# Build (and link) flags required for the XMC series
XMC_Build_Flags ?= -nostartfiles -mcpu=$(CPU) -mthumb #-mabi=aapcs -mfloat-abi=soft

XMC_Build_Flags_Debug ?= -g -gdwarf-2

Build_Flags_Required = $(XMC_Build_Flags) $(Build_Flags_Includes) $(Build_Flags_Defines) $(Build_Flags_Undefines)

Build_Flags_Standard ?= -O$(BLD_OPTIMIZATION) -pipe

### Recommended gcc flags for compilation
Build_Flags_Recommended  = -ffreestanding -funsigned-bitfields

# Compiler warnings
Build_Flags_Recommended += -Wall

# Automatically activated with -O2
#Build_Flags_Recommended += -fno-inline-small-functions -fno-strict-aliasing

# Enable function and data sections so the linker can strip what we aren't using
Build_Flags_Recommended += -ffunction-sections -fdata-sections

# Build flags shared with all build steps
Build_Flags ?= $(Build_Flags_Required) $(Build_Flags_Standard) $(Build_Flags_Recommended) $(Build_Flags_Extra)

# Standalone build flags for GCC/G++
Build_Flags_GCC_Recommended ?= -std=$(Build_LanguageStandard_GCC) -Wstrict-prototypes
Build_Flags_GXX_Recommended ?= -std=$(Build_LanguageStandard_GXX) -fno-exceptions

# Collected build flags for assembly sources
Build_Flags_ASM ?= $(Build_Flags_Includes) $(Build_Flags_Defines) $(Build_Flags_Undefines)

# Collected build flags for GCC/G++
Build_Flags_GCC ?= $(Build_Flags_GCC_Recommended) $(Build_Flags)
Build_Flags_GXX ?= $(Build_Flags_GXX_Recommended) $(Build_Flags)

# Path that linker script sits in
XMC_LinkerScript_Path ?= $(XMC_InitialStart_BasePath)
# Name of linker script to use
XMC_LinkerScript_Name ?= linker_script.ld

# Full path to linker script
XMC_LinkerScript ?= $(XMC_LinkerScript_Path)$(XMC_LinkerScript_Name)

# Flag to specify linker script
Linker_T_Flag ?= -T$(XMC_LinkerScript)

# List of directories to look in for libraries
Linker_Directories ?= 

# List of linker directories, each prefixed with "-L"
Linker_L_Flags ?= $(Linker_Directories:%=-L%)

LNK_FLAGS_REQUIRED ?= $(Linker_L_Flags) $(Linker_T_Flag)

LNK_LINKER_FLAGS ?= -Map=$(OUT_MAP) #--gc-sections

LNK_WL_FLAGS ?= $(LNK_LINKER_FLAGS:%=-Wl,%)

LNK_FLAGS_RECOMMENDED ?= $(LNK_WL_FLAGS)

LNK_FLAGS_OPTIONAL ?= --specs=nano.specs

LNK_FLAGS ?= $(XMC_Build_Flags) $(LNK_FLAGS_REQUIRED) $(LNK_FLAGS_RECOMMENDED) $(LNK_FLAGS_OPTIONAL) $(LNK_FLAGS_EXTRA)

# Mark that we've included the XMC vars file
VARS_INCLUDE=XMC

DEVICE ?= NRF51

# Which series are we really compiling for? ANT/BLE => (nrf51422/nrf51)
DEVICESERIES ?= nrf51

# Which variant (different flash sizes)
VARIANT ?= xxaa

GCC_VERSION ?= 4.9.3
GCC_ROOT    ?= C:/Progra~2/GNUTOO~1/4947E~1.920/
GCC_VARIANT  ?= arm-none-eabi

nRF51SDK_BasePath ?= C:/Progra~2/Nordic~1/NRF51_~1.0_C/

# Nordic expects some defines if you're using their libraries
AUTO_DEFINES += $(DEVICE)

## Setup final flags we're going to use

# Don't forget to include your Source_Path
INCLUDES ?= $(if $(Source_Path),$(Source_Path:%/=%),.)

CPU ?= cortex-m0

# Build (and link) flags required for the nRF51 series
nRF51_Build_Flags ?= -mcpu=$(CPU) -mthumb -mabi=aapcs -mfloat-abi=soft

Build_Flags_Required = $(nRF51_Build_Flags) $(Build_Flags_Includes) $(Build_Flags_Defines) $(Build_Flags_Undefines)

Build_Flags_Standard ?= -O$(Build_Optimization) -pipe

### Recommended gcc flags for compilation
Build_Flags_Recommended  = -ffreestanding -funsigned-bitfields

# Compiler warnings
Build_Flags_Recommended += -Wall

# Automatically activated with -O2
#Build_Flags_Recommended += -fno-inline-small-functions -fno-strict-aliasing

# Enable function and data sections so the linker can strip what we aren't using
Build_Flags_Recommended += #-ffunction-sections -fdata-sections

Build_Flags ?= $(Build_Flags_Required) $(Build_Flags_Standard) $(Build_Flags_Recommended) $(Build_Flags_Extra)

BLD_GCCFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GCC) -Wstrict-prototypes
BLD_GXXFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GXX) -fno-exceptions

BLD_ASMFLAGS ?= $(Build_Flags_Includes) $(Build_Flags_Defines) $(Build_Flags_Undefines)

BLD_GCCFLAGS ?= $(BLD_GCCFLAGS_RECOMMENDED) $(Build_Flags)
BLD_GXXFLAGS ?= $(BLD_GXXFLAGS_RECOMMENDED) $(Build_Flags)

nRF51_ldScriptPrefix ?=

NRF51_LDSCRIPT ?= $(nRF51_ldScriptPrefix)$(DEVICESERIES)_$(VARIANT).ld

NRF51_LNK_DIRS ?= $(NRF51_TOOLCHAIN_LINK_DIR)

LNK_DIRS ?= $(NRF51_LNK_DIRS)

LNK_L_FLAGS ?= $(LNK_DIRS:%=-L%)

LNK_T_FLAGS ?= -T$(NRF51_LDSCRIPT)

LNK_FLAGS_REQUIRED ?= $(LNK_L_FLAGS) $(LNK_T_FLAGS)

LNK_LINKER_FLAGS ?= -Map=$(OUT_MAP) #--gc-sections

LNK_WL_FLAGS ?= $(LNK_LINKER_FLAGS:%=-Wl,%)

LNK_FLAGS_RECOMMENDED ?= $(LNK_WL_FLAGS)

LNK_FLAGS_OPTIONAL ?= --specs=nano.specs -lc -lnosys

LNK_FLAGS ?= $(nRF51_Build_Flags) $(LNK_FLAGS_REQUIRED) $(LNK_FLAGS_RECOMMENDED) $(LNK_FLAGS_OPTIONAL) $(LNK_FLAGS_EXTRA)


VARS_INCLUDE=nRF51

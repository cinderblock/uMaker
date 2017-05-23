
ifndef MCU
 $(error Define MCU in your Makefile to enable AVR compilation)
endif

AVR_MCU ?= $(MCU)
AVR_Architecture ?= $(AVR_MCU)

# Get rid of the silly AVR #define that gnu sets outside of the reserved namespace
UNDEFINES = AVR

# Set this in your Makefile as you like
DEFINES ?= F_CPU=$(F_CPU)

AVR_Build_Flags ?= -mmcu=$(AVR_Architecture)

Build_Flags_Required = $(AVR_Build_Flags) $(Build_Flags_Includes) $(Build_Flags_Defines) $(Build_Flags_Undefines)

Build_Flags_Standard ?= -O$(Build_Optimization) -pipe

### Recommended gcc flags for compilation

# main() can return void
Build_Flags_Recommended  = -ffreestanding

# Compiler warnings
Build_Flags_Recommended += -Wall

# Note really necessary if you write your code right
Build_Flags_Recommended += -fshort-enums -funsigned-char -funsigned-bitfields

# Automatically activated with -O2
Build_Flags_Recommended += -fno-inline-small-functions -fno-strict-aliasing

Build_Flags_Recommended += -fpack-struct

Build_Flags ?= $(Build_Flags_Required) $(Build_Flags_Standard) $(Build_Flags_Recommended) $(Build_Flags_Extra)

BLD_GCCFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GCC) -Wstrict-prototypes
BLD_GXXFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GXX) -fno-exceptions
BLD_ASMFLAGS_RECOMMENDED ?=

BLD_GCCFLAGS ?= $(BLD_GCCFLAGS_RECOMMENDED) $(Build_Flags)
BLD_GXXFLAGS ?= $(BLD_GXXFLAGS_RECOMMENDED) $(Build_Flags)
BLD_ASMFLAGS ?= $(BLD_ASMFLAGS_RECOMMENDED) $(Build_Flags)

BLD_LNKFLAGS ?= $(AVR_Build_Flags)

# Assume avr-gcc et al. are in PATH
BLD_BIN_PREFIX = avr-

VARS_INCLUDE=AVR

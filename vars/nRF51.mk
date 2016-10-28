DEVICE ?= NRF51

# Which series are we really compiling for? ANT/BLE => (nrf51422/nrf51)
DEVICESERIES ?= nrf51

# Which variant (different flash sizes)
VARIANT ?= xxaa

GCC_VERSION ?= 4.9.3
GCC_ROOT    ?= C:/Progra~2/GNUTOO~1/4947E~1.920/
GCC_PREFIX  ?= arm-none-eabi

# Define these in your Makefile
GCCFILES ?= $(AUTO_GCC) $(C:%=$(Source_Path)%.$(Build_ExtentionC))
GXXFILES ?= $(AUTO_GXX) $(CPP:%=$(Source_Path)%.$(Build_ExtentionCpp))
ASMFILES ?= $(AUTO_ASM) $(ASM:%=$(Source_Path)%.$(Build_ExtentionAssembly))
LIBFILES ?= $(AUTO_LIB) $(LIB:%=%.$(Build_ExtentionLibrary))

nRF51SDK_BasePath ?= C:/Progra~2/Nordic~1/NRF51_~1.0_C/

# Base output file name
TARGET ?= setTARGETinYourMakefile

# Temporary directories to build into
Build_Path    ?= .bld/
Build_DepPath ?= $(Build_Path).dep/

# Only for libs that we build. Not for ones you're including that are pre-built
Build_LibPath ?= $(Build_Path)libs/

OPTIMIZATION ?= 2

BLD_OPTIMIZATION ?= $(OPTIMIZATION)
Build_LanguageStandard_GCC ?= gnu11
Build_LanguageStandard_GXX ?= gnu++11

# Directory that src files are in. ie: Source_Path = src/
Source_Path ?=

# Directory for compiled output files
Build_OutputPath ?= out/

# Nordic expects some defines if you're using their libraries
NRF51_DEFINES ?= $(DEVICE)

## Setup final flags we're going to use

# Don't forget to include your Source_Path
INCLUDES ?= $(if $(Source_Path),$(Source_Path:%/=%),.)

# Leading -I flags take precedence
Build_IncludeDirs ?= $(INCLUDES) $(AUTO_INC)
# Trailing -D flags override previous ones
Build_Defines  ?= $(NRF51_DEFINES) $(AUTO_DEF) $(DEFINES)

BLD_I_OPTS ?= $(Build_IncludeDirs:%=-I%)
BLD_D_OPTS ?= $(Build_Defines:%=-D%)

CPU ?= cortex-m0

# Build (and link) flags required for the nRF51 series
BLD_FLAGS_NRF ?= -mcpu=$(CPU) -mthumb -mabi=aapcs -mfloat-abi=soft

BLD_FLAGS_REQUIRED = $(BLD_FLAGS_NRF) $(BLD_I_OPTS) $(BLD_D_OPTS)

BLD_FLAGS_STANDARD ?= -O$(BLD_OPTIMIZATION) -pipe

### Recommended gcc flags for compilation
BLD_FLAGS_RECOMMENDED  = -ffreestanding -funsigned-bitfields

# Compiler warnings
BLD_FLAGS_RECOMMENDED += -Wall

# Automatically activated with -O2
#BLD_FLAGS_RECOMMENDED += -fno-inline-small-functions -fno-strict-aliasing

# Enable function and data sections so the linker can strip what we aren't using
BLD_FLAGS_RECOMMENDED += #-ffunction-sections -fdata-sections

BLD_FLAGS ?= $(BLD_FLAGS_REQUIRED) $(BLD_FLAGS_STANDARD) $(BLD_FLAGS_RECOMMENDED) $(BLD_FLAGS_EXTRA)

BLD_GCCFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GCC) -Wstrict-prototypes
BLD_GXXFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GXX) -fno-exceptions

BLD_ASMFLAGS ?= $(BLD_I_OPTS) $(BLD_D_OPTS)

BLD_GCCFLAGS ?= $(BLD_GCCFLAGS_RECOMMENDED) $(BLD_FLAGS)
BLD_GXXFLAGS ?= $(BLD_GXXFLAGS_RECOMMENDED) $(BLD_FLAGS)

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

LNK_FLAGS ?= $(BLD_FLAGS_NRF) $(LNK_FLAGS_REQUIRED) $(LNK_FLAGS_RECOMMENDED) $(LNK_FLAGS_OPTIONAL) $(LNK_FLAGS_EXTRA)

BLD_DEPFLAGS = -MMD -MP -MF $(@:$(Build_Path)%=$(Build_DepPath)%.d)

BLD_HEXFLAGS ?= -O $(OUT_FMT)

# Collect all our flags in one final place. Also include standard user flags
BLD_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CFLAGS)
BLD_GXXFLAGS_FINAL ?= $(BLD_GXXFLAGS) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CXXFLAGS)
BLD_ASMFLAGS_FINAL ?= $(BLD_ASMFLAGS) $(BLD_DEPFLAGS) $(ASFLAGS)
BLD_LNKFLAGS_FINAL ?= $(LNK_FLAGS) $(LDFLAGS) $(LDLIBS)
BLD_HEXFLAGS_FINAL ?= $(BLD_HEXFLAGS)

BLD_GCCOBJ ?= $(GCCFILES:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_GXXOBJ ?= $(GXXFILES:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_ASMOBJ ?= $(ASMFILES:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_LIBOBJ ?= $(LIBFILES)

BLD_OBJS = $(BLD_GCCOBJ) $(BLD_GXXOBJ) $(BLD_ASMOBJ) $(AUTO_OBJ)
BLD_LIBS = $(BLD_LIBOBJ)

OUT_ELF ?= $(Build_OutputPath)$(TARGET).elf
OUT_HEX ?= $(Build_OutputPath)$(TARGET).hex
OUT_LSS ?= $(Build_OutputPath)$(TARGET).lss
OUT_MAP ?= $(Build_OutputPath)$(TARGET).map
OUT_SYM ?= $(Build_OutputPath)$(TARGET).sym
OUT_EEP ?= $(Build_OutputPath)$(TARGET).eep

OUT_LIB ?= $(Build_OutputPath)lib$(TARGET).$(Build_ExtentionLibrary)

OUT_FILES = $(OUT_ELF) $(OUT_HEX) $(OUT_LSS) $(OUT_MAP) $(OUT_SYM) $(OUT_EEP) $(OUT_LIB)

AUTO_GENERATED_FILES += $(BLD_GCCOBJ) $(BLD_GXXOBJ) $(BLD_ASMOBJ) $(OUT_FILES)

# Output file format
OUT_FMT ?= ihex

BLD_ALL_OBJS ?= $(BLD_OBJS) $(BLD_LIBS)
OUT_DEPS ?= $(BLD_ALL_OBJS) $(AUTO_OUT_DEPS)

VARS_INCLUDE=nRF51

BLD_BIN_PREFIX ?= $(GCC_ROOT)bin/$(GCC_PREFIX)-

BLD_GCC ?= "$(BLD_BIN_PREFIX)gcc"
BLD_GXX ?= "$(BLD_BIN_PREFIX)g++"
BLD_ASM ?= "$(BLD_BIN_PREFIX)g++"
BLD_LNK ?= "$(BLD_BIN_PREFIX)g++"
BLD_OCP ?= "$(BLD_BIN_PREFIX)objcopy"
BLD_ODP ?= "$(BLD_BIN_PREFIX)objdump"
BLD_SZE ?= "$(BLD_BIN_PREFIX)size"
BLD_ARR ?= "$(BLD_BIN_PREFIX)ar" rcs
BLD_NMM ?= "$(BLD_BIN_PREFIX)nm"

RMF ?= rm -rf

ECO ?= @echo

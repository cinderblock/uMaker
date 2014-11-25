CPU ?= cortex-m0
DEVICE ?= NRF51
DEVICESERIES ?= nrf51
VARIANT ?= xxaa
SOFTDEVICE ?= blank

GCC_VERSION ?= 4.8.4
GCC_ROOT    ?= C:/Progra~2/GNUTOO~1/4F412~1.820/
GCC_PREFIX  ?= arm-none-eabi

# Define these in your Makefile
GCCFILES ?= $(AUTO_GCC) $(C:%=%.c)
GXXFILES ?= $(AUTO_GXX) $(CPP:%=%.cpp) #$(CXX:%=%.cxx) $(C++:%=%.c++)
ASMFILES ?= $(AUTO_ASM) $(ASM:%=%.s)
LIBFILES ?= $(AUTO_LIB) $(LIB:%=%.a)

NRF51_BASEDIR ?= C:/Progra~2/Nordic~1/nRF51S~2.0/Nordic/nrf51822/

# Base output file name
TARGET ?= setTARGETinYourMakefile

# Temporary directories to build into
BLD_DIR    ?= .bld/
BLD_DEPDIR ?= $(BLD_DIR).dep/

# Only for libs that we build. Not for ones you're including that are pre-built
BLD_LIBDIR ?= $(BLD_DIR)libs/

OPT ?= 2

BLD_OPT ?= $(OPT)
BLD_STD_GCC ?= gnu11
BLD_STD_GXX ?= gnu++11

# Directory that src files are in. ie: SRCDIR = src/
SRCDIR ?= 

# Directory for compiled output files
OUT_DIR ?= out/

# Set this in your Makefile as you like
NRF51_DEFINES ?= $(DEVICE) $(AUTO_DEF)

## Setup final flags we're going to use

# Don't forget to include your SRCDIR
INCLUDES ?= $(if $(SRCDIR),$(SRCDIR:%/=%),.)

# Leading -I flags take precedence
BLD_INCLUDES ?= $(INCLUDES) $(AUTO_INC)
# Trailing -D flags override previous ones
BLD_DEFINES  ?= $(NRF51_DEFINES) $(DEFINES)

BLD_I_OPTS ?= $(BLD_INCLUDES:%=-I%)
BLD_D_OPTS ?= $(BLD_DEFINES:%=-D%)
	
BLD_FLAGS_NRF ?= -mcpu=$(CPU) -mthumb -mabi=aapcs -mfloat-abi=soft

BLD_FLAGS_REQUIRED = $(BLD_FLAGS_NRF) $(BLD_I_OPTS) $(BLD_D_OPTS)

BLD_FLAGS_STANDARD ?= -O$(BLD_OPT) #-pipe

### Recommended gcc flags for compilation
#BLD_FLAGS_RECOMMENDED  = -ffreestanding -funsigned-bitfields

# Compiler warnings
BLD_FLAGS_RECOMMENDED += -Wall

# Note really necessary if you write your code right
#BLD_FLAGS_RECOMMENDED += -fshort-enums -funsigned-char

# Automatically activated with -O2
#BLD_FLAGS_RECOMMENDED += -fno-inline-small-functions -fno-strict-aliasing

# Enable function and data sections so the linker can strip what we aren't using
#BLD_FLAGS_RECOMMENDED += -ffunction-sections -fdata-sections

BLD_FLAGS ?= $(BLD_FLAGS_REQUIRED) $(BLD_FLAGS_STANDARD) $(BLD_FLAGS_RECOMMENDED) $(BLD_FLAGS_EXTRA)

BLD_GCCFLAGS_RECOMMENDED ?= -std=$(BLD_STD_GCC) -Wstrict-prototypes
BLD_GXXFLAGS_RECOMMENDED ?= -std=$(BLD_STD_GXX) -fno-exceptions

BLD_ASMFLAGS ?= -x assembler-with-cpp $(BLD_I_OPTS) $(BLD_D_OPTS)

BLD_GCCFLAGS ?= $(BLD_GCCFLAGS_RECOMMENDED) $(BLD_FLAGS)
BLD_GXXFLAGS ?= $(BLD_GXXFLAGS_RECOMMENDED) $(BLD_FLAGS)

NRF51_LDSCRIPT ?= $(NRF51INIT_DIR)gcc/gcc_$(DEVICESERIES)_$(SOFTDEVICE)_$(VARIANT).ld

NRF51_LIBDIRS ?= $(NRF51INIT_DIR)gcc # $(GCC_ROOT)$(GCC_PREFIX)/lib/armv6-m $(GCC_ROOT)lib/gcc/$(GCC_PREFIX)/$(GCC_VERSION)/armv6-m

LNK_LIBDIRS ?= $(NRF51_LIBDIRS)

LNK_L_FLAGS ?= $(LNK_LIBDIRS:%=-L%)

LNK_LINKER_FLAGS ?= -Map=$(OUT_MAP) --gc-sections

LNK_WL_FLAGS ?= $(LNK_LINKER_FLAGS:%=-Wl,%)

LNK_FLAGS_RECOMMENDED += $(LNK_L_FLAGS) $(LNK_WL_FLAGS) -T$(NRF51_LDSCRIPT) --specs=nano.specs

LNK_FLAGS ?= $(BLD_FLAGS_NRF) $(LNK_FLAGS_RECOMMENDED) $(LNK_FLAGS_EXTRA)

BLD_DEPFLAGS = -MMD -MP -MF $(@:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)

BLD_HEXFLAGS ?= -O $(OUT_FMT)

# Collect all our flags in one final place. Also include standard user flags
BLD_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CFLAGS)
BLD_GXXFLAGS_FINAL ?= $(BLD_GXXFLAGS) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CXXFLAGS)
BLD_ASMFLAGS_FINAL ?= $(BLD_ASMFLAGS) $(BLD_DEPFLAGS) $(ASFLAGS)
BLD_LNKFLAGS_FINAL ?= $(LNK_FLAGS) $(LDFLAGS) $(LDLIBS)
BLD_HEXFLAGS_FINAL ?= $(BLD_HEXFLAGS)

BLD_GCCOBJ ?= $(GCCFILES:%=$(BLD_DIR)%.o)
BLD_GXXOBJ ?= $(GXXFILES:%=$(BLD_DIR)%.o)
BLD_ASMOBJ ?= $(ASMFILES:%=$(BLD_DIR)%.o)
BLD_LIBOBJ ?= $(LIBFILES)

BLD_OBJS = $(BLD_GCCOBJ) $(BLD_GXXOBJ)
BLD_LIBS = $(BLD_LIBOBJ) $(AUTO_LIB)

OUT_ELF ?= $(OUT_DIR)$(TARGET).elf
OUT_HEX ?= $(OUT_DIR)$(TARGET).hex
OUT_LSS ?= $(OUT_DIR)$(TARGET).lss
OUT_MAP ?= $(OUT_DIR)$(TARGET).map
OUT_SYM ?= $(OUT_DIR)$(TARGET).sym
OUT_EEP ?= $(OUT_DIR)$(TARGET).eep

OUT_LIB ?= $(OUT_DIR)lib$(TARGET).a

OUT_FILES = $(OUT_ELF) $(OUT_HEX) $(OUT_LSS) $(OUT_MAP) $(OUT_SYM) $(OUT_EEP) $(OUT_LIB)

# Output file format
OUT_FMT ?= ihex

BLD_ALL_OBJS ?= $(BLD_OBJS) $(BLD_LIBS)
OUT_DEPS ?= $(BLD_ALL_OBJS) $(AUTO_OUT_DEPS)

VARS_INCLUDE=nRF51

BLD_BIN_PREFIX ?= $(GCC_ROOT)bin/$(GCC_PREFIX)-

BLD_GCC ?= "$(BLD_BIN_PREFIX)gcc" -c
BLD_GXX ?= "$(BLD_BIN_PREFIX)g++" -c
BLD_ASM ?= "$(BLD_BIN_PREFIX)g++" -c
BLD_LNK ?= "$(BLD_BIN_PREFIX)g++"
BLD_OCP ?= "$(BLD_BIN_PREFIX)objcopy"
BLD_ODP ?= "$(BLD_BIN_PREFIX)objdump"
BLD_SZE ?= "$(BLD_BIN_PREFIX)size"
BLD_ARR ?= "$(BLD_BIN_PREFIX)ar" rcs
BLD_NMM ?= "$(BLD_BIN_PREFIX)nm"

RMF ?= rm -rf

MKD ?= mkdir -p

ECO ?= @echo
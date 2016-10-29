
ifndef MCU
 $(error Define MCU in your Makefile to enable AVR compilation)
endif

AVR_MCU ?= $(MCU)
AVR_Architecture ?= $(AVR_MCU)

# Base output file name
TARGET ?= setTARGETinYourMakefile

# Temporary directories to build into
Build_Path    ?= .bld/
Build_DepPath ?= $(Build_Path).dep/

# Only for libs that we build. Not for ones you're including that are pre-built
Build_LibPath ?= $(Build_Path)libs/

Build_Optimization ?= 2
Build_LanguageStandard_GCC ?= gnu11
Build_LanguageStandard_GXX ?= gnu++11

# Get rid of the silly AVR #define that gnu sets outside of the reserved namespace
UNDEFINES = AVR

# Directory for fully compiled files
Build_OutputPath ?= out/

# Set this in your Makefile as you like
DEFINES ?= F_CPU=$(F_CPU)

BLD_FLAGS_AVR ?= -mmcu=$(AVR_Architecture)

BLD_FLAGS_REQUIRED = $(BLD_FLAGS_AVR) $(Build_Flags_Includes) $(Build_Flags_Defines) $(Build_Flags_Undefines)

BLD_FLAGS_STANDARD ?= -O$(Build_Optimization) -pipe

### Recommended gcc flags for compilation

# main() can return void
BLD_FLAGS_RECOMMENDED  = -ffreestanding

# Compiler warnings
BLD_FLAGS_RECOMMENDED += -Wall

# Note really necessary if you write your code right
BLD_FLAGS_RECOMMENDED += -fshort-enums -funsigned-char -funsigned-bitfields

# Automatically activated with -O2
BLD_FLAGS_RECOMMENDED += -fno-inline-small-functions -fno-strict-aliasing

BLD_FLAGS_RECOMMENDED += -fpack-struct

BLD_FLAGS ?= $(BLD_FLAGS_REQUIRED) $(BLD_FLAGS_STANDARD) $(BLD_FLAGS_RECOMMENDED) $(BLD_FLAGS_EXTRA)

BLD_GCCFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GCC) -Wstrict-prototypes
BLD_GXXFLAGS_RECOMMENDED ?= -std=$(Build_LanguageStandard_GXX) -fno-exceptions
BLD_ASMFLAGS_RECOMMENDED ?=

BLD_GCCFLAGS ?= $(BLD_GCCFLAGS_RECOMMENDED) $(BLD_FLAGS)
BLD_GXXFLAGS ?= $(BLD_GXXFLAGS_RECOMMENDED) $(BLD_FLAGS)
BLD_ASMFLAGS ?= $(BLD_ASMFLAGS_RECOMMENDED) $(BLD_FLAGS)

BLD_LNKFLAGS ?= $(BLD_FLAGS_AVR)

# TODO: This is not quite right if you change ASM_DIR. May need rework of build.
BLD_DEPFLAGS = -MMD -MP -MF $(@:$(Build_Path)%=$(Build_DepPath)%.d)

BLD_HEXFLAGS ?= -O $(OUT_FMT) -R .eeprom -R .fuse -R .lock

# Collect all our flags in one final place. Also include standard user flags
BLD_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CFLAGS)
BLD_GXXFLAGS_FINAL ?= $(BLD_GXXFLAGS) $(BLD_DEPFLAGS) $(CPPFLAGS) $(CXXFLAGS)
BLD_ASMFLAGS_FINAL ?= $(BLD_ASMFLAGS) $(BLD_DEPFLAGS) $(ASMFLAGS)
BLD_LNKFLAGS_FINAL ?= $(BLD_LNKFLAGS) $(LDFLAGS) $(LDLIBS)

BLD_HEXFLAGS_FINAL ?= $(BLD_HEXFLAGS)

BLD_GCCOBJ ?= $(GCCFILES:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_GXXOBJ ?= $(GXXFILES:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_ASMOBJ ?= $(ASMFILES:%=$(Build_Path)%.$(Build_ExtentionObject))
BLD_LIBOBJ ?= $(LIBFILES)

BLD_OBJS ?= $(BLD_GCCOBJ) $(BLD_GXXOBJ) $(BLD_ASMOBJ) $(AUTO_OBJ)
BLD_LIBS ?= $(BLD_LIBOBJ)

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

VARS_INCLUDE=AVR

BLD_BIN_PREFIX ?=

BLD_GCC ?= "$(BLD_BIN_PREFIX)avr-gcc"
BLD_GXX ?= "$(BLD_BIN_PREFIX)avr-g++"
BLD_ASM ?= "$(BLD_BIN_PREFIX)avr-g++"
BLD_LNK ?= "$(BLD_BIN_PREFIX)avr-g++"
BLD_OCP ?= "$(BLD_BIN_PREFIX)avr-objcopy"
BLD_ODP ?= "$(BLD_BIN_PREFIX)avr-objdump"
BLD_SZE ?= "$(BLD_BIN_PREFIX)avr-size" --format=avr --mcu=$(MCU)
BLD_ARR ?= "$(BLD_BIN_PREFIX)avr-ar" rcs
BLD_NMM ?= "$(BLD_BIN_PREFIX)avr-nm"

RMF ?= rm -rf

ECO ?= @echo

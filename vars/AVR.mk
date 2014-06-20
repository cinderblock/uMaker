
ifndef MCU
 $(error Define MCU in your Makefile to enable AVR compilation)
endif

# Define these in your Makefile
CFILES   ?= $(C:%=%.c)
CPPFILES ?= $(CPP:%=%.cpp)
LIBFILES ?= $(AUTO_LIB)

# Base output file name
TARGET ?= SETME

# Default target directories
BLD_DIR    ?= .bld/
BLD_DEPDIR ?= $(BLD_DIR).dep/
BLD_LIBDIR ?= $(BLD_DIR)libs/

OPT ?= 2
SRCDIR ?= ./
OUT_DIR ?= out/

DEFINES ?= F_CPU=$(F_CPU)

BLD_INCLUDES ?= $(AUTO_INC) $(INCLUDES)
BLD_DEFINES  ?= $(AUTO_DEF) $(DEFINES)

BLD_I_OPTS ?= $(BLD_INCLUDES:%=-I%)
BLD_D_OPTS ?= $(BLD_DEFINES:%=-D%)
	
BLD_FLAGS_AVR ?= -mmcu=$(MCU)

BLD_FLAGS_REQUIRED = $(BLD_FLAGS_AVR) $(BLD_I_OPTS) $(BLD_D_OPTS)

BLD_FLAGS_STANDARD ?= -O$(OPT) -pipe

# Recommended gcc flags for compilation
BLD_FLAGS_RECOMMENDED  = -ffreestanding -funsigned-bitfields

# Compiler warnings
BLD_FLAGS_RECOMMENDED += -Wall

# Note really necessary if you write your code right
BLD_FLAGS_RECOMMENDED += -fshort-enums -funsigned-char

# Automatically activated with -O2
BLD_FLAGS_RECOMMENDED += -fno-inline-small-functions -fno-strict-aliasing

# TODO: make sure this is right and we don't actually want =8 or something
BLD_FLAGS_RECOMMENDED += -fpack-struct

BLD_FLAGS ?= $(BLD_FLAGS_REQUIRED) $(BLD_FLAGS_STANDARD) $(BLD_FLAGS_RECOMMENDED) $(BLD_FLAGS_EXTRA)

BLD_GCCFLAGS_RECOMMENDED ?= -std=c11 -Wstrict-prototypes
BLD_GXXFLAGS_RECOMMENDED ?= -std=c++11

BLD_GCCFLAGS ?= $(BLD_GCCFLAGS_RECOMMENDED) $(BLD_FLAGS)
BLD_GXXFLAGS ?= $(BLD_GXXFLAGS_RECOMMENDED) $(BLD_FLAGS)

BLD_LNKFLAGS ?= $(BLD_FLAGS_AVR)

BLD_DEPFLAGS = -MMD -MP -MF $(@:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)

BLD_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS) $(BLD_DEPFLAGS) $(C_FLAGS)
BLD_GXXFLAGS_FINAL ?= $(BLD_GXXFLAGS) $(BLD_DEPFLAGS) $(CPP_FLAGS)
BLD_LNKFLAGS_FINAL ?= $(BLD_LNKFLAGS)

BLD_COBJ   ?= $(CFILES:%=$(BLD_DIR)%.o)
BLD_CPPOBJ ?= $(CPPFILES:%=$(BLD_DIR)%.o)
BLD_LIBOBJ ?= $(LIBFILES:%=$(BLD_LIBDIR)%)

BLD_OBJS = $(BLD_COBJ) $(BLD_CPPOBJ)
BLD_LIBS = $(BLD_LIBOBJ)

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

OUT_DEPS ?= $(BLD_OBJS) $(BLD_LIBS)

VARS_INCLUDE=AVR

BLD_GCC ?= avr-gcc -c
BLD_GXX ?= avr-g++ -c
BLD_LNK ?= avr-g++
BLD_OCP ?= avr-objcopy
BLD_ODP ?= avr-objdump
BLD_SZE ?= avr-size
BLD_ARR ?= avr-ar rcs
BLD_NMM ?= avr-nm

RMF ?= rm -rf

MKD ?= mkdir -p

ECO ?= @echo
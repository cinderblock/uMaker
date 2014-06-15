
GCC ?= avr-gcc
GXX ?= avr-g++
OCP ?= avr-objcopy
ODP ?= avr-objdump
SZE ?= avr-size
ARR ?= avr-ar rcs
NMM ?= avr-nm
RMF ?= rm -rf
MKD ?= mkdir -p
ECO ?= echo

DEPFLAGS = -MMD -MP -MF $(DEPDIR)$(@F).d

OPT ?= -O2

INCLUDES ?= $(AUTO_INC)

I_OPTS ?= $(INCLUDES:%=-I%)

BLDFLAGS ?= $(OPT) -mmcu=$(MCU) $(I_OPTS) -ffreestanding -DF_CPU=$(F_CPU) 

# Extra flags for C builds
GCCFLAGS ?= -std=c11
# Extra flags for C++ builds
GXXFLAGS ?= -std=c++0x
# Link flags
LDFLAGS  ?= -mmcu=$(MCU)

# Default target directories
BLDDIR ?= .bld/
OUTDIR ?= out/
SRCDIR ?= ./
DEPDIR ?= $(BLDDIR).dep/
LIBDIR ?= $(BLDDIR)libs/

# Define these in your Makefile
CFILES ?= 
CPPFILES ?= 
LIBFILES ?= $(AUTO_LIB)

COBJ   ?= $(CFILES:%=$(BLDDIR)%.o)
CPPOBJ ?= $(CPPFILES:%=$(BLDDIR)%.o)
LIBOBJ ?= $(LIBFILES:%=$(BLDDIR)%.o)

OBJS = $(COBJ) $(CPPOBJ)
LIBS = $(LIBOBJ)

# Base output file name
TARGET ?= default

ELFOUT ?= $(OUTDIR)$(TARGET).elf
HEXOUT ?= $(OUTDIR)$(TARGET).hex
LSSOUT ?= $(OUTDIR)$(TARGET).lss
MAPOUT ?= $(OUTDIR)$(TARGET).map
SYMOUT ?= $(OUTDIR)$(TARGET).sym
EEPOUT ?= $(OUTDIR)$(TARGET).eep

LIBOUT ?= $(OUTDIR)lib$(TARGET).a

# Output file format
OUTFMT ?= ihex


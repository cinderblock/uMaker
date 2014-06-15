
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

DEPFLAGS = -MMD -MP -MF $(@:$(BLDDIR)%=$(DEPDIR)%.d)

OPT ?= -O2

INCLUDES ?= $(AUTO_INC)

I_OPTS ?= $(INCLUDES:%=-I%)

BLDFLAGS ?= $(OPT) -mmcu=$(MCU) $(I_OPTS) -ffreestanding -DF_CPU=$(F_CPU) -pipe

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
CFILES ?= $(C:%=%.c)
CPPFILES ?= $(CPP:%=%.cpp)
LIBFILES ?= $(AUTO_LIB)

COBJ   ?= $(CFILES:%=$(BLDDIR)%.o)
CPPOBJ ?= $(CPPFILES:%=$(BLDDIR)%.o)
LIBOBJ ?= $(LIBFILES:%=$(LIBDIR)%)

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

OUTFILES = $(ELFOUT) $(HEXOUT) $(LSSOUT) $(MAPOUT) $(SYMOUT) $(EEPOUT) $(LIBOUT)

# Output file format
OUTFMT ?= ihex




LUFA_BASEDIR ?= ../LUFA/

LUFA_MAKEFILE_SOURCES ?= $(LUFA_BASEDIR)LUFA/Build/lufa_sources.mk

ARCH ?= AVR8
LUFA_PATH ?= LUFA
include $(LUFA_MAKEFILE_SOURCES)

# Relative to LUFA_BASEDIR
LUFA_SRC ?= $(LUFA_SRC_USB) $(LUFA_SRC_USBCLASS) $(LUFA_SRC_PLATFORM)

LUFA_AR ?= LUFA.a

LUFA_OBJS ?= $(LUFA_SRC:%=$(BLDDIR)%.o)
	
LUFA_FLAGS ?= -fshort-enums -fno-inline-small-functions -fpack-struct $(LUFA_BASE_FLAGS)

LUFA_BASE_FLAGS ?= -Wall -fno-strict-aliasing -funsigned-char -funsigned-bitfields -DARCH=ARCH_$(ARCH) -DF_USB=$(F_USB) -Wstrict-prototypes

AUTO_LIB += $(LUFA_AR)
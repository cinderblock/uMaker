
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

DEPFLAGS = -MMD -MP -MF $(DEPDIR)/$(@F).d

OPT ?= -O2

BLDFLAGS ?= $(OPT) -mmcu=$(MCU) -I$(SRCDIR) -ffreestanding -DF_CPU=$(F_CPU)

# Extra flags for C builds
GCCFLAGS ?= -std=c11
# Extra flags for C++ builds
GXXFLAGS ?= -std=c++0x
# Link flags
LDFLAGS  ?= -mmcu=$(MCU)

# Default target directories
BLDDIR ?= build
OUTDIR ?= out
SRCDIR ?= .
DEPDIR ?= $(BLDDIR)/.dep
LIBDIR ?= $(BLDDIR)/libs

# Define one or both of these in your Makefile
CPPFILES ?= 
CFILES ?= 
LIBFILES ?= 

OBJ = $(CPPFILES:%.cpp=$(BLDDIR)/%.cpp.o) $(CFILES:%.c=$(BLDDIR)/%.c.o) $(LIBFILES:%=$(LIBDIR)/%)

# Base output file name
TARGET ?= default

ELFOUT ?= $(OUTDIR)/$(TARGET).elf
HEXOUT ?= $(OUTDIR)/$(TARGET).hex
LSSOUT ?= $(OUTDIR)/$(TARGET).lss
MAPOUT ?= $(OUTDIR)/$(TARGET).map
SYMOUT ?= $(OUTDIR)/$(TARGET).sym
EEPOUT ?= $(OUTDIR)/$(TARGET).eep

LIBOUT ?= $(OUTDIR)/lib$(TARGET).a

# Output file format
OUTFMT ?= ihex

all: 

gcc_verbose:
	$(ECO) "CC : $(GCC) -c $(BLDFLAGS) <deps> $(GCCFLAGS) <in> -o <out>"

gxx_verbose:
	$(ECO) "C++: $(GCC) -c $(BLDFLAGS) <deps> $(GXXFLAGS) <in> -o <out>"

# Create object files from .c sources
$(BLDDIR)/%.c.o: $(SRCDIR)/%.c | $(DEPDIR)/ gcc_verbose
	$(ECO) "CC : $@		$<"
	$(GCC) -c $(BLDFLAGS) $(DEPFLAGS) $(GCCFLAGS) $< -o $@

# Create object files from .cpp sources
$(BLDDIR)/%.cpp.o: $(SRCDIR)/%.cpp | $(DEPDIR)/ gxx_verbose
	$(ECO) "C++: $@		$<"
	$(GXX) -c $(BLDFLAGS) $(DEPFLAGS) $(GXXFLAGS) $< -o $@

# Create output .elf from objects
$(ELFOUT): $(OBJ)
	$(ECO) Lnk: $@
	$(GXX) $^ --output $@ $(LDFLAGS)

# Create output .a from objects
$(LIBOUT): $(OBJ)
	$(ECO) AR : $@
	$(AR) $@ $^

# Create output .hex from ELF
$(HEXOUT): $(ELFOUT)
	$(ECO) HEX: $@
	$(OCP) -O $(OUTFMT) -R .eeprom -R .fuse -R .lock $< $@

# Create output .eep from ELF
$(EEPOUT): $(ELFOUT)
	$(ECO) EEP: $@
	$(OCP) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 --no-change-warnings -O $(OUTFMT) $< $@ || exit 0

# Create extended listing file from ELF
$(LSSOUT): $(ELFOUT)
	$(ECO) LST: $@
	$(OBJDUMP) -h -S -z $< > $@

# Create a symbol table from ELF
$(SYMOUT): $(ELFOUT)
	$(ECO) SYM: $@
	$(NM) -n $< > $@

clean:
	$(ECO) Cleaning...
	$(RMF) $(LIBDIR) $(BLDDIR) $(OUTDIR) $(DEPDIR)

.PHONY: clean gcc_verbose gxx_verbose
.PRECIOUS: %.o
.SECONDARY: $(ELFOUT) $(LIBOUT)

-include $(DEPDIR)/*.d


# Create target directories
$(BLDDIR)/ $(LIBDIR)/ $(OUTDIR)/ $(DEPDIR)/:
	$(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(ELFOUT) $(HEXOUT) $(LSSOUT) $(MAPOUT) $(SYMOUT) $(EEPOUT) $(LIBOUT): | $$(dir $$@)

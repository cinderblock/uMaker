
LUFA_DIR ?= ../LUFA/LUFA/

LUFA_MAKEFILE         ?= Build/lufa_build.mk
LUFA_MAKEFILE_SOURCES ?= $(LUFA_DIR)Build/lufa_sources.mk

LUFA_MAKE_EXTRA_OPTS ?= 

LUFA_MAKE_BASE_OPTS ?= -s -C $(LUFA_DIR) -f $(LUFA_MAKEFILE) ARCH=AVR8 LUFA_PATH=.

ARCH ?= AVR8
LUFA_PATH ?= .
include $(LUFA_MAKEFILE_SOURCES)

LUFA_SRC ?= "$(LUFA_SRC_USB) $(LUFA_SRC_USBCLASS) $(LUFA_SRC_PLATFORM)"

LUFA_BUILD_DIR ?= "$(abspath $(BLDDIR)LUFA/)"

# Remove the "UL" that LUFA sets on its own
LUFA_F_CPU ?= $(F_CPU:UL=)
LUFA_F_USB ?= $(F_USB:UL=)

LUFA_MAKE_OPTS ?= $(LUFA_MAKE_BASE_OPTS) \
 TARGET=fake MCU=$(MCU) SRC=$(LUFA_SRC) F_CPU=$(LUFA_F_CPU) F_USB=$(LUFA_F_USB) \
 OBJDIR=$(LUFA_BUILD_DIR) $(LUFA_MAKE_EXTRA_OPTS)

LUFA_MAKE_TARGET ?= "$(abspath $(LIBDIR)LUFA.a)"

LUFA_TARGET ?= $(LIBDIR)LUFA.a

$(LUFA_TARGET): | $(LIBDIR)
	$(ECO) "Lib: $@"
	"$(MAKE)" $(LUFA_MAKE_OPTS) $(LUFA_MAKE_TARGET)

clean: clean_lufa

clean_lufa:
	$(ECO) Cleaning LUFA...
	"$(MAKE)" $(LUFA_MAKE_OPTS) clean

.PHONY: clean_lufa clean
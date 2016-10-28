
# USAGE:
#
# Define EXTLIB_LIBS as a list of all <lib>s
# Define EXTLIB_LIBDIR_<lib> for each <lib>
# Optional var: EXTLIB_EXTRA_OPTS_<lib>

# Default for this build system
EXTLIB_EXTRA_OPTS ?= OUT_LIB="$(abspath $@)"

EXTLIB_CHDIG ?= "$(EXTLIB_LIBDIR_$*)"
EXTLIB_MAKEFILE ?= "$(EXTLIB_LIBDIR_$*)/Makefile"

EXTLIB_MAKE_OPTS ?= -Rrs -C $(EXTLIB_CHDIG) -f $(EXTLIB_MAKEFILE) MCU=$(MCU) $(EXTLIB_EXTRA_OPTS) $(EXTLIB_EXTRA_OPTS_$*)

EXTLIB_MAKE_TARGET ?= "$(abspath $@)"

EXTLIB_TARGET_PATTERN ?= $(Build_LibPath)/%.a

AUTO_LIB += $(EXTLIB_LIBS:%=$(EXTLIB_TARGET_PATTERN))

$(EXTLIB_TARGET_PATTERN):
	$(ECO) "Lib:	$@"
	$(ECO) "$(MAKE)" $(EXTLIB_MAKE_OPTS) $(EXTLIB_MAKE_TARGET)

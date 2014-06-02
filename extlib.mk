
# USAGE:
#
# Define var  : EXTLIB_LIBDIR_<libname>
# Call target : $(LIBDIR)/<libname>.a
# Optional var: EXTLIB_EXTRA_OPTS_<libname>

# Default for this build system
EXTLIB_EXTRA_OPTS ?= LIBOUT="$(abspath $@)"

EXTLIB_CHDIG ?= "$(EXTLIB_LIBDIR_$*)"
EXTLIB_MAKEFILE ?= "$(EXTLIB_LIBDIR_$*)/Makefile"

EXTLIB_MAKE_OPTS ?= -Rrs -C $(EXTLIB_CHDIG) -f $(EXTLIB_MAKEFILE) MCU=$(MCU) $(EXTLIB_EXTRA_OPTS) $(EXTLIB_EXTRA_OPTS_$*)

EXTLIB_MAKE_TARGET ?= "$(abspath $@)"

$(LIBDIR)/%.a: 
	$(ECO) "Lib: $@"
	$(ECO) "$(MAKE)" $(EXTLIB_MAKE_OPTS) $(EXTLIB_MAKE_TARGET)

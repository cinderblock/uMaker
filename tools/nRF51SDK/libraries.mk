


NRF51_SRCDIR ?= $(NRF51_BASEDIR)components/

# This matches the folder name that Nordic assigns
NRF51_LIBRARIES ?= libraries

NRF51_LIBRARIES_SRCDIR ?= $(NRF51_SRCDIR)$(NRF51_LIBRARIES)/

NRF51_LIBRARIES_BLDDIR ?= $(BLD_DIR)nRF51/$(NRF51_LIBRARIES)/

# Names of nRF51 source files to "find" and include
NRF51_LIBRARIES_C ?= button

NRF51_LIBRARIES_SRC_FILES ?= $(NRF51_LIBRARIES_C:%=%.c)

NRF51_LIBRARIES_SRC_FILES_FULL ?= $(foreach file,$(NRF51_LIBRARIES_SRC_FILES),$(shell find $(NRF51_LIBRARIES_SRCDIR) -type f -name $(file)))

NRF51_LIBRARIES_AR ?= nRF51-$(NRF51_LIBRARIES).a

NRF51_LIBRARIES_OBJS ?= $(NRF51_LIBRARIES_SRC_FILES_FULL:$(NRF51_LIBRARIES_SRCDIR)%=$(NRF51_LIBRARIES_BLDDIR)%.o)

NRF51_LIBRARIES_OUT ?= $(BLD_LIBDIR)$(NRF51_LIBRARIES_AR)

NRF51_LIBRARIES_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_LIBRARIES_GCCFLAGS_EXTRA)

AUTO_LIB += $(NRF51_LIBRARIES_OUT)

NRF51_LIBRARIES_TARGET ?= nRF51/libraries

AUTO_GENERATED_FILES += $(NRF51_LIBRARIES_OUT) $(NRF51_LIBRARIES_OBJS) $(NRF51_LIBRARIES_DEPFILES)

##### Targets

$(NRF51_LIBRARIES_BLDDIR)%.c.o: $(NRF51_LIBRARIES_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_LIBRARIES_GCCFLAGS_FINAL)

$(NRF51_LIBRARIES_OUT): $(NRF51_LIBRARIES_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_LIBRARIES_OBJS)

$(NRF51_LIBRARIES_OUT) $(NRF51_LIBRARIES_OBJS): | $(MAKEFILE_LIST)

$(NRF51_LIBRARIES_TARGET): $(NRF51_LIBRARIES_OUT)

.PHONY: $(NRF51_LIBRARIES_TARGET)
.PRECIOUS: $(NRF51_LIBRARIES_OBJS)
.SECONDARY: $(NRF51_LIBRARIES_OUT)

# Explicitly include all our build dep files
NRF51_LIBRARIES_DEPFILES = $(NRF51_LIBRARIES_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51_LIBRARIES_DEPFILES)

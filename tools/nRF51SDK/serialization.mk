


NRF51_SRCDIR ?= $(NRF51_BASEDIR)components/

# This matches the folder name that Nordic assigns
NRF51_SERIALIZATION ?= serialization

NRF51_SERIALIZATION_SRCDIR ?= $(NRF51_SRCDIR)$(NRF51_SERIALIZATION)/

NRF51_SERIALIZATION_BLDDIR ?= $(BLD_DIR)nRF51/$(NRF51_SERIALIZATION)/

# Names of nRF51 source files to "find" and include
NRF51_SERIALIZATION_C ?= simple_uart

NRF51_SERIALIZATION_SRC_FILES ?= $(NRF51_SERIALIZATION_C:%=%.c)

NRF51_SERIALIZATION_SRC_FILES_FULL ?= $(foreach file,$(NRF51_SERIALIZATION_SRC_FILES),$(shell find $(NRF51_SERIALIZATION_SRCDIR) -type f -name $(file)))

NRF51_SERIALIZATION_AR ?= nRF51-$(NRF51_SERIALIZATION).a

NRF51_SERIALIZATION_OBJS ?= $(NRF51_SERIALIZATION_SRC_FILES_FULL:$(NRF51_SERIALIZATION_SRCDIR)%=$(NRF51_SERIALIZATION_BLDDIR)%.o)

NRF51_SERIALIZATION_OUT ?= $(BLD_LIBDIR)$(NRF51_SERIALIZATION_AR)

NRF51_SERIALIZATION_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_SERIALIZATION_GCCFLAGS_EXTRA)

AUTO_LIB += $(NRF51_SERIALIZATION_OUT)

NRF51_SERIALIZATION_TARGET ?= nRF51/serialization

AUTO_GENERATED_FILES += $(NRF51_SERIALIZATION_OUT) $(NRF51_SERIALIZATION_OBJS) $(NRF51_SERIALIZATION_DEPFILES)

##### Targets

$(NRF51_SERIALIZATION_BLDDIR)%.c.o: $(NRF51_SERIALIZATION_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_SERIALIZATION_GCCFLAGS_FINAL)

$(NRF51_SERIALIZATION_OUT): $(NRF51_SERIALIZATION_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_SERIALIZATION_OBJS)

$(NRF51_SERIALIZATION_OUT) $(NRF51_SERIALIZATION_OBJS): $(MAKEFILE_LIST)

$(NRF51_SERIALIZATION_TARGET): $(NRF51_SERIALIZATION_OUT)

.PHONY: $(NRF51_SERIALIZATION_TARGET)
.PRECIOUS: $(NRF51_SERIALIZATION_OBJS)
.SECONDARY: $(NRF51_SERIALIZATION_OUT)

# Explicitly include all our build dep files
NRF51_SERIALIZATION_DEPFILES = $(NRF51_SERIALIZATION_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51_SERIALIZATION_DEPFILES)

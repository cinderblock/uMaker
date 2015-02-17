


NRF51_SRCDIR ?= $(NRF51_BASEDIR)components/

# This matches the folder name that Nordic assigns
NRF51_COMPONENT ?= <COMPONENT_REAL_DIR>

NRF51_COMPONENT_SRCDIR ?= $(NRF51_SRCDIR)$(NRF51_COMPONENT)/

NRF51_COMPONENT_BLDDIR ?= $(BLD_DIR)nRF51/$(NRF51_COMPONENT)/

# Names of nRF51 source files to "find" and include
NRF51_COMPONENT_C ?= simple_uart

NRF51_COMPONENT_SRC_FILES ?= $(NRF51_COMPONENT_C:%=%.c)

NRF51_COMPONENT_SRC_FILES_FULL ?= $(foreach file,$(NRF51_COMPONENT_SRC_FILES),$(shell find $(NRF51_COMPONENT_SRCDIR) -type f -name $(file)))

NRF51_COMPONENT_AR ?= nRF51-$(NRF51_COMPONENT).a

NRF51_COMPONENT_OBJS ?= $(NRF51_COMPONENT_SRC_FILES_FULL:$(NRF51_COMPONENT_SRCDIR)%=$(NRF51_COMPONENT_BLDDIR)%.o)

NRF51_COMPONENT_OUT ?= $(BLD_LIBDIR)$(NRF51_COMPONENT_AR)

NRF51_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(NRF51_GCCFLAGS_EXTRA)

# This needs to go in one place... where tho?
#AUTO_DEF += BLE_STACK_SUPPORT_REQD

NRF51_COMPONENT_INCLUDES ?= $(sort $(dir $(NRF51_COMPONENT_SRC_FILES_FULL)))

AUTO_INC += $(NRF51_COMPONENT_INCLUDES)

AUTO_LIB += $(NRF51_COMPONENT_OUT)

NRF51_COMPONENT_TARGET ?= nRF51/<COMPONENT_NAME>

AUTO_GENERATED_FILES += $(NRF51_COMPONENT_OUT) $(NRF51_COMPONENT_OBJS) $(NRF51_COMPONENT_DEPFILES)

##### Targets

$(NRF51_COMPONENT_BLDDIR)%.c.o: $(NRF51_COMPONENT_SRCDIR)%.c
	$(ECO) "nRF51 C	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51_GCCFLAGS_FINAL)

$(NRF51_COMPONENT_OUT): $(NRF51_COMPONENT_OBJS)
	$(ECO) "nRF51 AR	$@"
	$(BLD_ARR) $@ $(NRF51_COMPONENT_OBJS)

$(NRF51_COMPONENT_OUT) $(NRF51_COMPONENT_OBJS): | $(MAKEFILE_LIST)

$(NRF51_COMPONENT_TARGET): $(NRF51_COMPONENT_OUT)

.PHONY: $(NRF51_COMPONENT_TARGET)
.PRECIOUS: $(NRF51_COMPONENT_OBJS)
.SECONDARY: $(NRF51_COMPONENT_OUT)

# Explicitly include all our build dep files
NRF51_COMPONENT_DEPFILES = $(NRF51_COMPONENT_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51_COMPONENT_DEPFILES)

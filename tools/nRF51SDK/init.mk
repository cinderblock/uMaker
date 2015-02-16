# This tool copies nRF51 required common build files to the local directory if they do not exist.



ifneq ($(VARS_INCLUDE),nRF51)
 $(error You need to include vars/nRF51.mk \(or equivalent\) to use this uMaker tool)
endif

NRF51INIT_TEMPLATE_DIR ?= $(NRF51_BASEDIR)Source/templates/

NRF51INIT_SRC ?= system_$(DEVICESERIES).c gcc/gcc_startup_$(DEVICESERIES).s
NRF51INIT_LNK ?= gcc/gcc_$(DEVICESERIES)_common.ld gcc/gcc_$(DEVICESERIES)_$(SOFTDEVICE)_$(VARIANT).ld

NRF51INIT_DIR ?= $(SRCDIR)nRF51init/

NRF51INIT_BLDDIR ?= $(BLD_DIR)nRF51init/

NRF51INIT_SRC_FULL ?= $(NRF51INIT_SRC:%=$(NRF51INIT_DIR)%)
NRF51INIT_LNK_FULL ?= $(NRF51INIT_LNK:%=$(NRF51INIT_DIR)%)

AUTO_OUT_DEPS += $(NRF51INIT_LNK_FULL)

NRF51INIT_FILES ?= $(NRF51INIT_SRC_FULL) $(NRF51INIT_LNK_FULL)

NRF51INIT_OBJS ?= $(NRF51INIT_SRC_FULL:%=$(BLD_DIR)%.o)

NRF51INIT_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL)
NRF51INIT_ASMFLAGS_FINAL ?= $(BLD_ASMFLAGS_FINAL)

NRF51INIT_AR ?= nRF51init.a

NRF51INIT_OUT ?= $(BLD_LIBDIR)$(NRF51INIT_AR)

AUTO_LIB += $(NRF51INIT_OUT)

##### Targets

$(NRF51INIT_BLDDIR)%.c.o: $(NRF51INIT_DIR)%.c
	$(ECO) "nRFi CC	$@"
	$(BLD_GCC) $< -o $@ -c $(NRF51INIT_GCCFLAGS_FINAL)

$(NRF51INIT_BLDDIR)%.s.o: $(NRF51INIT_DIR)%.s
	$(ECO) "nRFi AS	$@"
	$(BLD_ASM) -c $(NRF51INIT_ASMFLAGS_FINAL) -o $@ $<

$(NRF51INIT_OUT): $(NRF51INIT_OBJS)
	$(ECO) "nRFi AR	$@"
	$(BLD_ARR) $@ $(NRF51INIT_OBJS)

$(NRF51INIT_OUT) $(NRF51INIT_OBJS): $(MAKEFILE_LIST)

nRF51init-build: $(NRF51INIT_OUT)

nRF51init-src: $(NRF51INIT_FILES)

.PHONY: nRF51init-build nRF51init-src

.PRECIOUS: $(NRF51INIT_OBJS)
.SECONDARY: $(NRF51INIT_OUT) $(NRF51INIT_FILES)

# Explicitly include all our build dep files
NRF51INIT_DEPFILES = $(NRF51INIT_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(NRF51INIT_DEPFILES)

$(NRF51INIT_FILES):
	$(ECO) "nRFinit	$@"
	cp -u $(@:$(NRF51INIT_DIR)%=$(NRF51INIT_TEMPLATE_DIR)%) $@

# Older version of make strip trailing '/' from targets unless they're explicitly declared
$(sort $(dir $(NRF51INIT_FILES) $(NRF51INIT_OUT) $(NRF51INIT_OBJS) $(NRF51INIT_DEPFILES))):
	$(ECO) "MKDIR	$@"
	$(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(NRF51INIT_FILES) $(NRF51INIT_OUT) $(NRF51INIT_OBJS) $(NRF51INIT_DEPFILES): | $$(dir $$@)
# This tool copies nRF51 required common build files to the local directory if they do not exist.


# Catch this now
ifneq ($(VARS_INCLUDE),nRF51)
$(error You need to include vars/nRF51.mk \(or equivalent\) to use this uMaker tool)
endif

NRF51_SRCDIR ?= $(NRF51_BASEDIR)components/

# This matches the folder name that Nordic assigns
NRF51_TOOLCHAIN_DIRNAME ?= toolchain

NRF51_TOOLCHAIN_BASEDIR ?= $(NRF51_SRCDIR)$(NRF51_TOOLCHAIN_DIRNAME)/

NRF51_TOOLCHAIN_HEADERS ?= $(NRF51_TOOLCHAIN_BASEDIR) $(NRF51_TOOLCHAIN_BASEDIR)gcc/

AUTO_INC += $(NRF51_TOOLCHAIN_HEADERS)

NRF51_TOOLCHAIN_LINK_DIR ?= $(NRF51_TOOLCHAIN_BASEDIR)gcc/

# Files that we need to copy to the source directory
NRF51_TOOLCHAIN_SRCSDK ?= system_$(DEVICESERIES).c gcc/gcc_startup_nrf51.s
NRF51_TOOLCHAIN_SRC ?= $(notdir $(NRF51_TOOLCHAIN_SRCSDK))

# Directory to copy the toolchain's init files to
NRF51_TOOLCHAIN_SRCDIR ?= $(SRCDIR)nRF51/

NRF51_TOOLCHAIN_SRC_FULL ?= $(NRF51_TOOLCHAIN_SRC:%=$(NRF51_TOOLCHAIN_SRCDIR)%)

# Instead of compiling these sources ourselves, lets just let the build.mk script do this for us
AUTO_GCC += $(filter %.c,$(NRF51_TOOLCHAIN_SRC_FULL))
AUTO_ASM += $(filter %.s,$(NRF51_TOOLCHAIN_SRC_FULL))

# This uMaker script will create some source files if they don't already exist
# so add them to this list so that directories can be created.
AUTO_GENERATED_FILES += $(NRF51_TOOLCHAIN_SRC_FULL)

##### Targets

# TODO: Make these targets more generic

$(NRF51_TOOLCHAIN_SRCDIR)system_$(DEVICESERIES).c:
	$(ECO) "nRF51 copy	$@"
	cp -u $(NRF51_TOOLCHAIN_BASEDIR)system_$(DEVICESERIES).c $(NRF51_TOOLCHAIN_SRCDIR)system_$(DEVICESERIES).c

#$(NRF51_TOOLCHAIN_SRCDIR)gcc/gcc_startup_nrf51.s:
#	$(ECO) "nRF51 copy	$@"
#	cp -u $(NRF51_TOOLCHAIN_BASEDIR)gcc/gcc_startup_nrf51.s $(NRF51_TOOLCHAIN_SRCDIR)gcc_startup_nrf51.s

# A convenience target for initializing our source files
nRF51x/toolchain/copy: $(NRF51_TOOLCHAIN_SRC_FULL)

.PHONY: nRF51x/toolchain/copy

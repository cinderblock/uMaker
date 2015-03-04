# Generate all of the paths needed for all nRF51 SDK header files.

# Since Nordic uses the non-standard format of not including the directories that
# each included file is actually in. So, instead, let's just add all of the paths
# to the AUTO_INC variable.

# Search only in the real source directory
NRF51_SRCDIR ?= $(NRF51_BASEDIR)components/

# Find everything by default
NRF51_HEADERS ?= *

# Set this variable if you only use some
NRF51_HEADER_FILES ?= $(NRF51_HEADERS:%=%.h)

# Soft device header locations to be filtered-out
NRF51_SRCDIR_SD ?= $(NRF51_SRCDIR)softdevice/

# Find all the files that we're searching for. This will work for either a list of
# specific files we're looking for, or match the wildcard default. Also, filter
# out the softdevice folder since that needs special handling
NRF51_HEADER_FILES_FULL ?= $(filter-out $(NRF51_SRCDIR_SD)%,$(foreach file,$(NRF51_HEADER_FILES),$(shell find $(NRF51_SRCDIR) -type f -name "$(file)")))

# We only want to include the directories of each of theses files, and ideally only once.
NRF51_INCLUDES ?= $(sort $(dir $(NRF51_HEADER_FILES_FULL)))

# Append to the list of files to include
AUTO_INC += $(NRF51_INCLUDES)

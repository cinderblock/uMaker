# Generate all of the paths needed for all nRF51 SDK header files.

# Since Nordic uses the non-standard format of not including the directories that
# each included file is actually in. So, instead, let's just add all of the paths
# to the AUTO_INC variable.

# Search only in the real source directory
nRF51SDK_SourcePath ?= $(nRF51SDK_BasePath)components/

# List of header file names to search for so that we can automatically include
# the appropriate directory. Do not include the trailing .h extension. By
# default, match all file names
nRF51SDK_HeaderPlainFileNames ?= *

# List of files to find with file extensions
nRF51SDK_HeaderFullFileNames ?= $(nRF51SDK_HeaderPlainFileNames:%=%.h)

# Filter the header files that the soft device replaces
ifneq (,$(filter-out blank,$(NRF51_SOFTDEVICE_VERSION)))
 nRF51SDK_HeaderFullFileNames_OtherFilters ?= $(nRF51SDK_SourcePath)drivers_nrf/nrf_soc_nosd/%
endif

nRF51SDK_BuiltinSoftDeviceDirs ?= $(nRF51SDK_SourcePath)softdevice/%

# Soft device header locations to be filtered-out since they're included manually.
nRF51SDK_HeaderFullFileNames_Filters ?= $(nRF51SDK_BuiltinSoftDeviceDirs) $(nRF51SDK_HeaderFullFileNames_OtherFilters)

# Find all the files that we're searching for. This will work for either a list of
# specific files we're looking for, or match the wildcard default
nRF51SDK_FoundHeaderFiles ?= $(foreach file,$(nRF51SDK_HeaderFullFileNames),$(shell find $(nRF51SDK_SourcePath) -type f -name "$(file)"))

nRF51SDK_FoundHeaderFilesFiltered ?= $(filter-out $(nRF51SDK_HeaderFullFileNames_Filters) ___SOME_RANDOM_STRING_JUST_IN_CASE_VAR_IS_EMPTY_ASDAASDhasdfGASIUDYASGUYbjcabsDAS,$(nRF51SDK_FoundHeaderFiles))

# We only want to include the directories of each of theses files. sort() also
# removes duplicates. Also make the list match the Dirs naming standard.
nRF51SDK_FoundIncludeDirs ?= $(patsubst %/,%,$(sort $(dir $(nRF51SDK_FoundHeaderFilesFiltered))))

# Append to the list of directories to include from
AUTO_INC += $(nRF51SDK_FoundIncludeDirs)

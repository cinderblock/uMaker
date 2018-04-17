
# Location of AVR++ library. There should be a folder 'AVR++' inside this one
AVRpp_BaseDir ?= AVR++
AVRpp_BasePath ?= $(AVRpp_BaseDir)/

# base source names to build
AVRpp_SRC ?= ADC USART gccGuard

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
AVRpp_Build_ExtentionC ?= c
AVRpp_Build_ExtentionCpp ?= cpp
AVRpp_Build_ExtentionAssembly ?= S
AVRpp_Build_ExtentionObject ?= $(Build_ExtentionObject)
AVRpp_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

# Relative to AVRpp_BaseDir
AVRpp_FILES ?= $(AVRpp_SRC:%=AVR++/%.$(AVRpp_Build_ExtentionCpp))

AVRpp_AR ?= AVR++.$(AVRpp_Build_ExtentionLibrary)

AVRpp_OBJS ?= $(AVRpp_FILES:%=$(Build_Path)%.$(AVRpp_Build_ExtentionObject))

AVRpp_OUT ?= $(Build_LibPath)$(AVRpp_AR)

AUTO_LIB += $(AVRpp_OUT)

AVRpp_TARGET ?= AVR++

AUTO_INC += $(AVRpp_BaseDir)

##### Targets

$(Build_Path)%.$(AVRpp_Build_ExtentionCpp).$(AVRpp_Build_ExtentionObject): $(AVRpp_BasePath)%.$(AVRpp_Build_ExtentionCpp)
	$(ECO) "AVR++		$@"
	$(BLD_GXX) $< -o $@ -c $(Build_Flags_GXX_Final)

$(AVRpp_OUT): $(AVRpp_OBJS)
	$(ECO) "AVR++ AR	$@"
	$(BLD_ARR) $@ $(AVRpp_OBJS)

$(AVRpp_OUT) $(AVRpp_OBJS) : $(MAKEFILE_LIST)

$(AVRpp_TARGET): $(AVRpp_OUT)

.PHONY: $(AVRpp_TARGET)
.PRECIOUS: $(AVRpp_OBJS)
.SECONDARY: $(AVRpp_OUT)

# Explicitly include all our build dep files
AVRpp_DEPFILES ?= $(AVRpp_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(AVRpp_DEPFILES)

AUTO_GENERATED_FILES += $(AVRpp_OUT) $(AVRpp_OBJS) $(AVRpp_DEPFILES)

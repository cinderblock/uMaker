
# Location of AVR++ library. There should be a folder 'AVR++' inside this one
AVRpp_BASEDIR ?= AVR++/

# base source names to build
AVRpp_SRC ?= ADC USART DecPrintFormatter gccGuard

# We use fixed values for the variables that probably shouldn't change if the developer decides to use a different file extention for their source files.
AVRpp_Build_ExtentionC ?= c
AVRpp_Build_ExtentionCpp ?= cpp
AVRpp_Build_ExtentionAssembly ?= S
AVRpp_Build_ExtentionObject ?= $(Build_ExtentionObject)
AVRpp_Build_ExtentionLibrary ?= $(Build_ExtentionLibrary)

# Relative to AVRpp_BASEDIR
AVRpp_FILES ?= $(AVRpp_SRC:%=AVR++/%.$(AVRpp_Build_ExtentionCpp))

AVRpp_AR ?= AVR++.$(AVRpp_Build_ExtentionLibrary)

AVRpp_OBJS ?= $(AVRpp_FILES:%=$(BuildPath)%.$(AVRpp_Build_ExtentionObject))

AVRpp_OUT ?= $(BLD_LIBDIR)$(AVRpp_AR)

AUTO_LIB += $(AVRpp_OUT)

AVRpp_TARGET ?= AVR++

AUTO_INC += $(AVRpp_BASEDIR)

##### Targets

$(BuildPath)%.$(AVRpp_Build_ExtentionCpp).$(AVRpp_Build_ExtentionObject): $(AVRpp_BASEDIR)%.$(AVRpp_Build_ExtentionCpp)
	$(ECO) "AVR++		$@"
	$(BLD_GXX) $< -o $@ -c $(BLD_GXXFLAGS_FINAL)

$(AVRpp_OUT): $(AVRpp_OBJS)
	$(ECO) "AVR++ AR	$@"
	$(BLD_ARR) $@ $(AVRpp_OBJS)

$(AVRpp_OUT) $(AVRpp_OBJS) : $(MAKEFILE_LIST)

$(AVRpp_TARGET): $(AVRpp_OUT)

.PHONY: $(AVRpp_TARGET)
.PRECIOUS: $(AVRpp_OBJS)
.SECONDARY: $(AVRpp_OUT)

# Explicitly include all our build dep files
AVRpp_DEPFILES ?= $(AVRpp_OBJS:$(BuildPath)%=$(BLD_DEPDIR)%.d)
-include $(AVRpp_DEPFILES)

AUTO_GENERATED_FILES += $(AVRpp_OUT) $(AVRpp_OBJS) $(AVRpp_DEPFILES)

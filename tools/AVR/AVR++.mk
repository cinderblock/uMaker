
# Location of AVR++ library. There should be a folder 'AVR++' inside this one
AVRpp_BASEDIR ?= AVR++/

# base source names to build
AVRpp_SRC ?= ADC USART gccGuard

# Relative to AVRpp_BASEDIR
AVRpp_FILES ?= $(AVRpp_SRC:%=AVR++/%.cpp)

AVRpp_AR ?= AVR++.a

AVRpp_OBJS ?= $(AVRpp_FILES:%=$(BLD_DIR)%.o)

AVRpp_OUT ?= $(BLD_LIBDIR)$(AVRpp_AR)

AUTO_LIB += $(AVRpp_OUT)

AVRpp_TARGET ?= AVR++

AUTO_INC += $(AVRpp_BASEDIR)

##### Targets

$(BLD_DIR)%.cpp.o: $(AVRpp_BASEDIR)%.cpp
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
AVRpp_DEPFILES ?= $(AVRpp_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(AVRpp_DEPFILES)

AUTO_GENERATED_FILES += $(AVRpp_OUT) $(AVRpp_OBJS) $(AVRpp_DEPFILES)

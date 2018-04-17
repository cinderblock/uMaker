
# Location of libCameron library. There should be a folder 'src' inside this one
libCameron_BaseDir ?= libCameron/

libCameron_SrcDir ?= $(libCameron_BaseDir)src/

# base source names to build
libCameron_SRC ?= DecPrintFormatter

# Relative to libCameron_SrcDir
libCameron_SrcFiles ?= $(libCameron_SRC:%=$(libCameron_SrcDir)%.cpp)

libCameron_AR ?= libCameron.a

libCameron_OBJS ?= $(libCameron_SrcFiles:%=$(BLD_DIR)%.o)

libCameron_OUT ?= $(BLD_LIBDIR)$(libCameron_AR)

AUTO_LIB += $(libCameron_OUT)

libCameron_TARGET ?= libCameron

AUTO_INC += $(libCameron_SrcDir)

##### Targets

$(BLD_DIR)%.cpp.o: $(libCameron_SrcDir)%.cpp
	$(ECO) "libCameron		$@"
	$(BLD_GXX) $< -o $@ -c $(BLD_GXXFLAGS_FINAL)

$(libCameron_OUT): $(libCameron_OBJS)
	$(ECO) "libCameron AR	$@"
	$(BLD_ARR) $@ $(libCameron_OBJS)

$(libCameron_OUT) $(libCameron_OBJS) : $(MAKEFILE_LIST)

$(libCameron_TARGET): $(libCameron_OUT)

.PHONY: $(libCameron_TARGET)
.PRECIOUS: $(libCameron_OBJS)
.SECONDARY: $(libCameron_OUT)

# Explicitly include all our build dep files
libCameron_DEPFILES ?= $(libCameron_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(libCameron_DEPFILES)

AUTO_GENERATED_FILES += $(libCameron_OUT) $(libCameron_OBJS) $(libCameron_DEPFILES)

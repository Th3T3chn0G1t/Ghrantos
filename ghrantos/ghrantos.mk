include $(GHRANTOS_DIR)/ghrantos/vendor/glad.mk
include $(GHRANTOS_DIR)/ghrantos/vendor/libbmp.mk
include $(GHRANTOS_DIR)/ghrantos/vendor/glfw.mk
include $(GHRANTOS_DIR)/ghrantos/vendor/tracy.mk
# include $(GHRANTOS_DIR)/build/stdlib.mk

GHRANTOS_SOURCES = $(wildcard $(GHRANTOS_DIR)/ghrantos/*.c3)
GHRANTOS_PROCESSED = $(addprefix $(GHRANTOS_DIR)/tmp/,$(notdir $(GHRANTOS_SOURCES:.c3=.processed.c3)))
GHRANTOS_OBJECT = $(GHRANTOS_DIR)/tmp/ghrantos$(OBJECT_SUFFIX)

GHRANTOS_OUT = $(GHRANTOS_DIR)/ghrantos$(EXECUTABLE_SUFFIX)

.PHONY: ghrantos
ghrantos: $(GHRANTOS_OUT)

$(GHRANTOS_OUT): C3FLAGS = $(GHRANTOS_C3FLAGS)
$(GHRANTOS_OUT): LFLAGS = $(GHRANTOS_LFLAGS) $(GEN_CORE_LFLAGS) $(GLFW_LFLAGS) -lglad -lbmp -lstdc3 -lglfw
$(GHRANTOS_OUT): LIBDIRS = $(GEN_CORE_LIBDIRS) $(GHRANTOS_DIR)/lib
$(GHRANTOS_OUT): $(GHRANTOS_OBJECT) $(LIBBMP_OUT)# $(C3_STDLIB)

$(GHRANTOS_OBJECT): $(GHRANTOS_PROCESSED)

$(GHRANTOS_PROCESSED): C3_PREPROCESSOR_FLAGS = -I$(GHRANTOS_DIR)/ghrantos/include -I$(GENSTONE_DIR)/genstone/gencore/include -I$(GHRANTOS_DIR)/tmp/include -I$(GHRANTOS_DIR)/ghrantos/vendor/libbmp -I$(GHRANTOS_DIR)/ghrantos/vendor/GLFW/include -I$(GHRANTOS_DIR)/ghrantos/vendor/tracy/public/tracy
$(GHRANTOS_PROCESSED): $(GHRANTOS_SOURCES) $(GLAD_OUT) $(GLFW_OUT) $(TRACY_OUT)

.PHONY: clean_ghrantos
clean_ghrantos:
	@$(ECHO) "$(ACTION_PREFIX)"
	-$(RM) $(GHRANTOS_OBJECTS)
	-$(RM) $(GHRANTOS_OUT)
	@$(ECHO) "$(ACTION_SUFFIX)"

.PHONY: test_ghrantos
test_ghrantos:

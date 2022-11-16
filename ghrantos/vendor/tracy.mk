TRACY_SOURCES = $(GHRANTOS_DIR)/ghrantos/vendor/tracy/public/TracyClient.cpp
TRACY_OBJECTS = $(TRACY_SOURCES:.cpp=$(OBJECT_SUFFIX))

TRACY_OUT = $(GHRANTOS_DIR)/lib/$(LIB_PREFIX)tracy$(STATIC_LIB_SUFFIX)

GLOBAL_CFLAGS += -DTRACY_ENABLE
GLOBAL_C3_PREPROCESSOR_FLAGS += -DTRACY_ENABLE

$(TRACY_OUT): CFLAGS = $(TRACY_INTERNAL_CFLAGS) -Wno-deprecated-declarations
$(TRACY_OUT): LFLAGS =
$(TRACY_OUT): LIBDIRS =
$(TRACY_OUT): $(TRACY_OBJECTS) | $(GHRANTOS_DIR)/lib

.PHONY: tracy
tracy: $(TRACY_OUT)

.PHONY: test_tracy
test_tracy:

.PHONY: clean_tracy
clean_tracy:
	@$(ECHO) "$(ACTION_PREFIX)"
	-$(RM) $(TRACY_OBJECTS)
	-$(RM) $(TRACY_OUT)
	@$(ECHO) "$(ACTION_SUFFIX)"
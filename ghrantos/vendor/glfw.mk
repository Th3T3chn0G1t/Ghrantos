GLFW_SOURCES = $(wildcard $(GHRANTOS_DIR)/ghrantos/vendor/GLFW/src/*.c)
GLFW_OBJC_SOURCES = $(wildcard $(GHRANTOS_DIR)/ghrantos/vendor/GLFW/src/*.m)
GLFW_OBJECTS = $(GLFW_SOURCES:.c=$(OBJECT_SUFFIX)) $(GLFW_OBJC_SOURCES:.m=$(OBJECT_SUFFIX))

GLFW_OUT = $(GHRANTOS_DIR)/lib/$(LIB_PREFIX)glfw$(STATIC_LIB_SUFFIX)

GLFW_FRAMEWORKS = -framework Carbon -framework Cocoa -framework IOKit -framework CoreFoundation
GLFW_LFLAGS = $(GLFW_FRAMEWORKS) -lobjc

ifeq ($(PLATFORM),LINUX)
GLFW_INTERNAL_CFLAGS += -D_GLFW_X11
else
ifeq ($(PLATFORM),OSX)
GLFW_INTERNAL_CFLAGS += -D_GLFW_COCOA
else
ifeq ($(PLATFORM),WINDOWS)
GLFW_INTERNAL_CFLAGS += -D_GLFW_WIN32
endif
endif
endif
$(GLFW_OUT): CFLAGS = $(GLFW_INTERNAL_CFLAGS) $(GLFW_FRAMEWORKS)
$(GLFW_OUT): OBJCFLAGS =
$(GLFW_OUT): LFLAGS =
$(GLFW_OUT): LIBDIRS =
$(GLFW_OUT): $(GLFW_OBJECTS) | $(GHRANTOS_DIR)/lib

.PHONY: glfw
glfw: $(GLFW_OUT)

.PHONY: test_glfw
test_glfw:

.PHONY: clean_glfw
clean_glfw:
	@$(ECHO) "$(ACTION_PREFIX)"
	-$(RM) $(GLFW_OBJECTS)
	-$(RM) $(GLFW_OUT)
	@$(ECHO) "$(ACTION_SUFFIX)"

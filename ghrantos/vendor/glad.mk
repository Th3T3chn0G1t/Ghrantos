GLAD_HEADERS = $(GHRANTOS_DIR)/tmp/include
GLAD_GENERATED = $(GHRANTOS_DIR)/tmp/src/gl.c
GLAD_OBJECTS = $(GLAD_GENERATED:.c=$(OBJECT_SUFFIX))
GLAD_OUT = $(GHRANTOS_DIR)/lib/$(LIB_PREFIX)glad$(STATIC_LIB_SUFFIX)

$(GLAD_HEADERS) $(GLAD_GENERATED): | $(GHRANTOS_DIR)/tmp
	@$(ECHO) "$(ACTION_PREFIX)"
	$(CD) $(GHRANTOS_DIR)/ghrantos/vendor/glad2 && $(PYTHON3) setup.py build
	$(CD) $(GHRANTOS_DIR)/ghrantos/vendor/glad2 && $(PYTHON3) -m glad --api gl:core --out-path $(subst $(eval) ,,$(foreach component,$(subst /, ,$(dir $(GHRANTOS_DIR)/ghrantos/vendor/glad2)),../))$(GHRANTOS_DIR)/tmp/ c --debug
	@$(ECHO) "$(ACTION_SUFFIX)"

$(GLAD_OBJECTS): | $(GLAD_GENERATED)

$(GLAD_OUT): CFLAGS = -I$(GHRANTOS_DIR)/tmp/include
$(GLAD_OUT): LFLAGS =
$(GLAD_OUT): LIBDIRS =
$(GLAD_OUT): $(GLAD_OBJECTS) | $(GHRANTOS_DIR)/lib

.PHONY: glad
glad: $(GLAD_OUT)

.PHONY: test_glad
test_glad:

.PHONY: clean_glad
clean_glad:
	@$(ECHO) "$(ACTION_PREFIX)"
	-$(RM) $(GLAD_OBJECTS)
	-$(RM) $(GLAD_GENERATED)
	-$(RM) $(GLAD_OUT)
	@$(ECHO) "$(ACTION_SUFFIX)"

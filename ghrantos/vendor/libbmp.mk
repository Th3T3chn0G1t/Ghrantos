LIBBMP_SOURCES = $(wildcard $(GHRANTOS_DIR)/ghrantos/vendor/libbmp/*.c)
LIBBMP_OBJECTS = $(LIBBMP_SOURCES:.c=$(OBJECT_SUFFIX))
LIBBMP_OUT = $(GHRANTOS_DIR)/lib/$(LIB_PREFIX)bmp$(STATIC_LIB_SUFFIX)

$(LIBBMP_OUT): CFLAGS = -I$(GHRANTOS_DIR)/tmp/include -Wno-absolute-value
$(LIBBMP_OUT): LFLAGS =
$(LIBBMP_OUT): LIBDIRS =
$(LIBBMP_OUT): $(LIBBMP_OBJECTS) | $(GHRANTOS_DIR)/lib

.PHONY: libbmp
libbmp: $(LIBBMP_OUT)

.PHONY: test_libbmp
test_libbmp:

.PHONY: clean_libbmp
clean_libbmp:
	@$(ECHO) "$(ACTION_PREFIX)"
	-$(RM) $(LIBBMP_OBJECTS)
	-$(RM) $(LIBBMP_OUT)
	@$(ECHO) "$(ACTION_SUFFIX)"

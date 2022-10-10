include $(GHRANTOS_DIR)/ghrantos/vendor/glad.mk
include $(GHRANTOS_DIR)/ghrantos/vendor/libbmp.mk

GHRANTOS_C3FLAGS =
GHRANTOS_LFLAGS =

GHRANTOS_SOURCES = $(wildcard $(GHRANTOS_DIR)/ghrantos/*.c3)
GHRANTOS_OBJECTS = $(GHRANTOS_SOURCES:.c3=$(OBJECT_SUFFIX))

GHRANTOS_OUT = $(GHRANTOS_DIR)/ghrantos$(EXECUTABLE_SUFFIX)

.PHONY: ghrantos
ghrantos: $(GHRANTOS_OUT)

GL_FUNDAMENTAL_TYPES = float|int|double|short|uint64|sync|uint|sizei|enum|boolean|uint64EXT|ubyte|byte|halfNV|ushort|int64EXT|intptr|fixed|vdpauSurfaceNV|handleARB|bitfield|int64|char|sizeiptr|clampf|charARB|eglClientBufferEXT|intptrARB|sizeiptrARB|eglImageOES|clampd
GLFW_FUNDAMENTAL_TYPES = window|glproc|gamepadstate|joystickfun|errorfun|monitor|monitorfun|vidmode|gammaramp|image|windowposfun|windowsizefun|windowclosefun|windowrefreshfun|windowfocusfun|windowiconifyfun|windowmaximizefun|framebuffersizefun|windowcontentscalefun|cursor|keyfun|charfun|charmodsfun|mousebuttonfun|cursorposfun|cursorenterfun|scrollfun|dropfun
GLAD_FUNDAMENTAL_TYPES = precallback|postcallback|apiproc|loadfunc|userptrloadfunc
BMP_FUNDAMENTAL_TYPES = error|header|pixel|header|img

$(GHRANTOS_OUT): C3FLAGS = $(GHRANTOS_C3FLAGS)
$(GHRANTOS_OUT): C3_PREPROCESSOR_FLAGS = -I$(GHRANTOS_DIR)/ghrantos/include -I$(GENSTONE_DIR)/genstone/gencore/include -I$(GHRANTOS_DIR)/tmp/include -I$(GHRANTOS_DIR)/ghrantos/vendor/libbmp
$(GHRANTOS_OUT): ADDITIONAL_C2C3_PASS = \
									    $(PERL) -pe 's/\bPFN(\w+)PROC/C_PFN\1PROC_t/g' \
									  | $(PERL) -pe 's/\bC___GLsync_t\b/void/g' \
									  | $(PERL) -pe 's/\bGL(\w+)PROC(\w*)\b/C_GL\1PROC\2_t/g' \
									  | $(PERL) -pe 's/\bGL($(GL_FUNDAMENTAL_TYPES))\b/C_GL\1_t/g' \
									  | $(PERL) -pe 's/\bGLAD($(GLAD_FUNDAMENTAL_TYPES))\b/C_GLAD\1_t/g' \
									  | $(PERL) -pe 's/\bGLFW($(GLFW_FUNDAMENTAL_TYPES))\b/C_GLFW\1_t/g' \
									  | $(PERL) -0777pe 's/enum C_khronos_boolean_enum_t {[\w\s=,]+}/enum C_khronos_boolean_enum_t : int {KHRONOS_FALSE, KHRONOS_TRUE}/gs' \
									  | $(PERL) -pe 's/^extern C_PFNGL([A-Z]+)PROC_t g_glad_debug_gl(\w+);$$/extern C_PFNGL\1PROC_t glad_debug_gl\2;/g' \
									  | $(PERL) -pe 's/\bbmp_($(BMP_FUNDAMENTAL_TYPES))\b/C_bmp_\1_t/g' \
									  | $(PERL) -pe 's/\} C_bmp_($(BMP_FUNDAMENTAL_TYPES))_t;/}/g' \
									  | $(PERL) -pe 's/\bC__bmp_($(BMP_FUNDAMENTAL_TYPES))_t\b/C_bmp_\1_t/g' \
									  | $(PERL) -pe 's/^enum C_bmp_($(BMP_FUNDAMENTAL_TYPES))_t\s+([^\{:])/C_bmp_\1_t \2/g' \
									  | $(PERL) -0777pe 's/enum C_bmp_error_t \{BMP_FILE_NOT_OPENED,\s*(([A-Z_]+,?\s*)+)}//gs' \
									  | $(PERL) -pe 's/^(\w+) bmp_(\w+)\s*\(/extern fn \1 bmp_\2(/g'
$(GHRANTOS_OUT): LFLAGS = $(GHRANTOS_LFLAGS) $(GEN_CORE_LFLAGS) -lglad -lbmp
$(GHRANTOS_OUT): LIBDIRS = $(GEN_CORE_LIBDIRS) $(GHRANTOS_DIR)/lib
$(GHRANTOS_OUT): $(GHRANTOS_OBJECTS) $(LIBBMP_OUT)

$(GHRANTOS_OBJECTS): $(GLAD_OUT)

.PHONY: clean_ghrantos
clean_ghrantos:
	@$(ECHO) "$(ACTION_PREFIX)"
	-$(RM) $(GHRANTOS_OBJECTS)
	-$(RM) $(GHRANTOS_OUT)
	@$(ECHO) "$(ACTION_SUFFIX)"

.PHONY: test_ghrantos
test_ghrantos:

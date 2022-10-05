#include <ghrantos/ghrantos.h>
#define GHRANTOS_FS_IMPL
#include <ghrantos/fs.h>

#include <genstring.h>
#include <genmemory.h>

fn void GhrantosFSHandle_t.init(GhrantosFSHandle_t* handle, char* path) {
    @ghrantos_tooling_frame() {
        gen_filesystem_handle_open(path, GEN_STRING_NO_BOUNDS, &handle.handle).ensure();
    };
}

fn void GhrantosFSHandle_t.deinit(GhrantosFSHandle_t* handle) {
    @ghrantos_tooling_frame() {
        gen_filesystem_handle_close(&handle.handle).ensure();
    };
}

fn char* GhrantosFSHandle_t.read_all(GhrantosFSHandle_t* handle) {
    @ghrantos_tooling_frame() {
        size_t length = 0;
        gen_filesystem_handle_file_size(&handle.handle, &length).ensure();
        char* data = null;
        gen_memory_allocate_zeroed((void**) &data, length + 1, char.sizeof).ensure();
        gen_filesystem_handle_file_read(&handle.handle, 0, length, data).ensure();
        GHRANTOS_TOOLED_RETURN(data);
    };
}
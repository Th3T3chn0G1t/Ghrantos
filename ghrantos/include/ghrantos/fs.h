#pragma once

#include <ghrantos/ghrantos.h>

#define GEN_FILESYSTEM_FORCE_UNIX GEN_ENABLED
#define _SSIZE_T
#define _SYS_STAT_H_
#include <genfilesystem.h>
#undef _SYS_STAT_H_
define C3_block_def_mknod = void;
#include <sys/stat.h>

struct GhrantosFSHandle_t {
    gen_filesystem_handle_t handle;
}

#ifndef GHRANTOS_FS_IMPL
extern void GhrantosFSHandle_t.init(GhrantosFSHandle_t* handle, char* path) @extname("fs_C_GhrantosFSHandle_t_init");
extern void GhrantosFSHandle_t.deinit(GhrantosFSHandle_t* handle) @extname("fs_C_GhrantosFSHandle_t_deinit");
extern GhrantosByteBuffer_t GhrantosFSHandle_t.read_all(GhrantosFSHandle_t* handle) @extname("fs_C_GhrantosFSHandle_t_read_all");
#endif

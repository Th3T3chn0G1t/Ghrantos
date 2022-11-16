// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos::fs;

import ghrantos;

#include <genstring.h>
#include <genmemory.h>
#include <genfilesystem.h>

struct GhrantosFSHandle_t {
    C_gen_filesystem_handle_t handle;
}

fn void GhrantosFSHandle_t.init(GhrantosFSHandle_t* handle, char* path) {
    @ghrantos_tooling_frame() {
        genfilesystem::c_gen_filesystem_handle_open(path, GHRANTOS_STRING_NO_BOUNDS, &handle.handle).ensure();
    };
}

fn void GhrantosFSHandle_t.deinit(GhrantosFSHandle_t* handle) {
    @ghrantos_tooling_frame() {
        genfilesystem::c_gen_filesystem_handle_close(&handle.handle).ensure();
    };
}

fn GhrantosByteBuffer_t GhrantosFSHandle_t.read_all(GhrantosFSHandle_t* handle) {
    @ghrantos_tooling_frame() {
        GhrantosByteBuffer_t buffer = {};

        usz length = 0;
        genfilesystem::c_gen_filesystem_handle_file_size(&handle.handle, &length).ensure();
        buffer.reserve(length + 1);
        buffer.entries[length] = '\0';
        genfilesystem::c_gen_filesystem_handle_file_read(&handle.handle, 0, length, buffer.entries).ensure();

        GHRANTOS_TOOLED_RETURN(buffer);
    };
}

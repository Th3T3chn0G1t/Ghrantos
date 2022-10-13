// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#include <ghrantos/ghrantos.h>
#include <ghrantos/graphics.h>
#define GHRANTOS_SURFACE_IMPL
#include <ghrantos/surface.h>

fn void GhrantosSurface_t.init(GhrantosSurface_t* surface, GhrantosWindow_t* window) {
    @ghrantos_tooling_frame() {};
}

fn void GhrantosSurface_t.deinit(GhrantosSurface_t* surface) {
    @ghrantos_tooling_frame() {};
}

fn void GhrantosSurface_t.clear(GhrantosSurface_t* surface, float[4] color) {
    @ghrantos_tooling_frame() {
        glClearColor(color[0], color[1], color[2], color[3]);
        glClear(GL_COLOR_BUFFER_BIT);
    };
}

fn void GhrantosSurface_t.draw(GhrantosSurface_t* surface, GhrantosDrawMode_t mode, uint vertices, uint instances) {
    @ghrantos_tooling_frame() {
        switch(mode) {
            case NORMAL: glDrawArraysInstanced(GL_TRIANGLES, 0, vertices, instances);
            case INDEXED: glDrawElementsInstanced(GL_TRIANGLES, vertices, GL_UNSIGNED_INT, null, instances);
        }
    };
}

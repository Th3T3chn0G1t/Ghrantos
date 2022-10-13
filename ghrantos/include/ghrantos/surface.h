// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#pragma once

#include <ghrantos/ghrantos.h>
#include <ghrantos/window.h>

enum GhrantosDrawMode_t {
    NORMAL,
    INDEXED
}

struct GhrantosSurface_t {
    char reserve;
}

#ifndef GHRANTOS_SURFACE_IMPL
extern void GhrantosSurface_t.init(GhrantosSurface_t* surface, GhrantosWindow_t* window) @extname("surface_C_GhrantosSurface_t_init");
extern void GhrantosSurface_t.deinit(GhrantosSurface_t* surface) @extname("surface_C_GhrantosSurface_t_deinit");
extern void GhrantosSurface_t.clear(GhrantosSurface_t* surface, float[4] color) @extname("surface_C_GhrantosSurface_t_clear");
extern void GhrantosSurface_t.draw(GhrantosSurface_t* surface, GhrantosDrawMode_t mode, uint vertices, uint instances) @extname("surface_C_GhrantosSurface_t_draw");
#endif

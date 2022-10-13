// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#pragma once

#include <ghrantos/ghrantos.h>

struct GhrantosTransform2D_t {
    float[<2>] translation;
    float[<2>] scale;
    float rotation;
}

#ifndef GHRANTOS_TRANSFORM2D_IMPL
extern float[<4>][4] GhrantosTransform2D_t.mat(GhrantosTransform2D_t* transform2d, bool invert = false) @extname("transform2d_C_GhrantosTransform2D_t_mat");
#endif

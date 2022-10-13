// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#include <ghrantos/ghrantos.h>
#include <ghrantos/math.h>
#define GHRANTOS_TRANSFORM2D_IMPL
#include <ghrantos/transform2d.h>

fn float[<4>][4] GhrantosTransform2D_t.mat(GhrantosTransform2D_t* transform2d, bool invert) {
    @ghrantos_tooling_frame() {
        float[<4>][4] ret = {};
        ret.ident();

        float[<3>] translation = {transform2d.translation[0], transform2d.translation[1], 0.0};
        float[<3>] scale = {transform2d.scale[0], transform2d.scale[1], 1.0};
        float[<3>] axis = {0.0, 0.0, 1.0};

        if(invert) {
            translation.invert();
            ret.translate(&translation);
            ret.scale(&scale);
            ret.rotate(&axis, transform2d.rotation);
        }
        else {
            ret.translate(&translation);
            ret.scale(&scale);
            ret.rotate(&axis, transform2d.rotation);
        }

        GHRANTOS_TOOLED_RETURN(ret);
    };
}

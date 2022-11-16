// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos::transform2d;

import ghrantos;
import ghrantos::math;

struct GhrantosTransform2D_t {
    float[<2>] translation;
    float[<2>] scale;
    float rotation;
}

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

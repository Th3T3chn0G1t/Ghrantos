// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos::math;

import std::math;

// TODO: Fix math procs to use full initializer lists

macro float float[<*>].sum(float[<*>]* vec) {
    float ret = 0.0;
    foreach(e : vec) {
        ret += e;
    }
    return ret;
}

macro void float[<*>].mul(float[<*>]* vec, float s) {
    *vec = vec.mul_to(s);
}

macro void float[<*>].invert(float[<*>]* vec) {
    for(usz i = 0; i < vec.len; ++i) {
        vec[i] = -vec[i];
    }
}

macro float[<*>] float[<*>].mul_to(float[<*>]* vec, float s) {
    $typeof(*vec) ret = *vec;
    for(usz i = 0; i < ret.len; ++i) {
        ret[i] *= s;
    }
    return ret;
}

macro void float[<4>][4].ident(float[<4>][4]* mat) {
    *mat = {};
    for(usz i = 0; i < mat.len; ++i) {
        mat[i][i] = 1.0;
    }
}

macro void float[<4>][4].mul(float[<4>][4]* a, float[<4>][4]* b) {
    *a = a.mul_to(b);
}

macro float[<4>][4] float[<4>][4].mul_to(float[<4>][4]* a, float[<4>][4]* b) {
    return a.mul_to_n(b, a.len);
}

macro float[<4>][4] float[<4>][4].mul_to_n(float[<4>][4]* a, float[<4>][4]* b, usz n) {
    float[<4>][4] ret = {};
    for(usz i = 0; i < a.len; ++i) {
        for(usz j = 0; j < a.len; ++j) {
            for(usz k = 0; k < a.len; ++k) {
                if(i < n && j < n && k < n) {
                    ret[i][j] += a[k][j] * b[i][k];
                }
                else {
                    ret[i][j] = a[i][j];
                }
            }
        }
    }
    return ret;
}

macro void float[<4>][4].translate(float[<4>][4]* mat, float[<*>]* translation) {
    for(usz i = 0; i < translation.len; ++i) {
        mat[translation.len] += mat[i].mul_to(translation[i]);
    }
}

macro void float[<4>][4].scale(float[<4>][4]* mat, float[<*>]* scale) {
    for(usz i = 0; i < scale.len; ++i) {
        mat[i].mul(scale[i]);
    }
}

macro void float[<4>][4].rotate(float[<4>][4]* mat, float[<3>]* axis, float radians) {
    float cosr = (float) $$cos(radians);
    float sinr = (float) $$sin(radians);
    float x = axis[0];
    float y = axis[1];
    float z = axis[2];

    float[<4>][4] rot = {};
    rot.ident();
    rot[0] = {
        cosr + (x * x) * (float) (1.0 - cosr),
        (x * y) * (float) (1.0 - cosr) - (z * sinr),
        (x * z) * (float) (1.0 - cosr) + (y * sinr),
        0.0
    };

    rot[1] = {
        (y * x) * (float) (1.0 - cosr) + (z * sinr),
        cosr + (y * y) * (float) (1.0 - cosr),
        (y * z) * (float) (1.0 - cosr) - (x * sinr),
        0.0
    };

    rot[2] = {
        (z * x) * (float) (1.0 - cosr) - (y * sinr),
        (z * y) * (float) (1.0 - cosr) + (x * sinr),
        cosr + (z * z) * (float) (1.0 - cosr),
        0.0
    };

    // float[<4>][4] rot = {
    //     {
    //         cosr + (x * x) * (float) (1.0 - cosr),
    //         (x * y) * (float) (1.0 - cosr) - (z * sinr),
    //         (x * z) * (float) (1.0 - cosr) + (y * sinr),
    //         0.0
    //     },
    //     {
    //         (y * x) * (float) (1.0 - cosr) + (z * sinr),
    //         cosr + (y * y) * (float) (1.0 - cosr),
    //         (y * z) * (float) (1.0 - cosr) - (x * sinr),
    //         0.0
    //     },
    //     {
    //         (z * x) * (float) (1.0 - cosr) - (y * sinr),
    //         (z * y) * (float) (1.0 - cosr) + (x * sinr),
    //         cosr + (z * z) * (float) (1.0 - cosr),
    //         0.0
    //     },
    //     {
    //         0.0,
    //         0.0,
    //         0.0,
    //         1.0
    //     }
    // };

    mat.mul(&rot);
}

macro void float[<4>][4].ortho(float[<4>][4]* mat, float near, float far, float left, float right, float top, float bottom) {
    *mat = {};
    
    float r_l = (float) 1.0 / (right - left);
    float t_b = (float) 1.0 / (top - bottom);
    float f_n = (float) -1.0 / (far - near);

    mat[0][0] = 2.0 * r_l;
    mat[1][1] = 2.0 * t_b;
    mat[2][2] = -f_n;
    mat[3][0] = -(right + left) * r_l;
    mat[3][1] = -(top + bottom) * t_b;
    mat[3][2] = near * f_n;
    mat[3][3] = 1.0;
}



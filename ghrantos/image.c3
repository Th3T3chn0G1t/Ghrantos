// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos::image;

import ghrantos;

#include <genmemory.h>
#include <libbmp.h>

define GhrantosImageData_t = List<C_bmp_pixel_t>;

struct GhrantosImage_t {
    usz width;
    usz height;
    GhrantosImageData_t data;
}

fn void C_bmp_error_t.ensure(C_bmp_error_t error) {
    if(error == BMP_OK) return;

    C_gen_error_type_t error_type = GEN_ERROR_UNKNOWN;
    char* errname = null;
    switch(error) {
        case BMP_FILE_NOT_OPENED:
            error_type = GEN_ERROR_BAD_OPERATION;
            errname = "BMP_FILE_NOT_OPENED";
        case BMP_HEADER_NOT_INITIALIZED:
            error_type = GEN_ERROR_INVALID_PARAMETER;
            errname = "BMP_HEADER_NOT_INITIALIZED";
        case BMP_INVALID_FILE:
            error_type = GEN_ERROR_INVALID_PARAMETER;
            errname = "BMP_INVALID_FILE";
        case BMP_BAD_HEADER:
            error_type = GEN_ERROR_BAD_CONTENT;
            errname = "BMP_BAD_HEADER";
        case BMP_CONTENT_CUT_SHORT:
            error_type = GEN_ERROR_TOO_SHORT;
            errname = "BMP_CONTENT_CUT_SHORT";
        case BMP_ERROR:
            error_type = GEN_ERROR_UNKNOWN;
            errname = "BMP_ERROR";
    }

    gencommon::c_gen_error_attach_backtrace_formatted(error_type, $$LINE, "BMP Error %si: `%t`", error, errname).ensure();
}

fn void GhrantosImage_t.init(GhrantosImage_t* image, char* path) {
    @ghrantos_tooling_frame() {
        image.data = {};

        C_bmp_img_t bmp = {};
        libbmp::c_bmp_img_read(&bmp, path).ensure();

        image.width = bmp.img_header.biWidth;
        image.height = bmp.img_header.biHeight;

        image.data.reserve(image.width * image.height);

        for(usz y = 0; y < image.height; ++y) {
            for(usz x = 0; x < image.width; ++x) {
                bmp_pixel_t* pixel = &bmp.img_pixels[image.height - (y + 1)][x];
                image.data.append(*(GhrantosPixel_t*) pixel);
            }
        }

        bmp_img_free(&bmp);
    };
}

fn void GhrantosImage_t.deinit(GhrantosImage_t* image) {
    @ghrantos_tooling_frame() {
        image.data.free();
    };
}


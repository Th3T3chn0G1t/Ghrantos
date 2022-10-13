// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#include <ghrantos/ghrantos.h>
#define GHRANTOS_IMAGE_IMPL
#include <ghrantos/image.h>

#include <genmemory.h>

define FILE_t = void;
#include <libbmp.h>

define bmp_error_t = int;
C3_const bmp_error_t BMP_FILE_NOT_OPENED = -6;
C3_const bmp_error_t BMP_HEADER_NOT_INITIALIZED = -5;
C3_const bmp_error_t BMP_INVALID_FILE = -4;
C3_const bmp_error_t BMP_BAD_HEADER = -3;
C3_const bmp_error_t BMP_CONTENT_CUT_SHORT = -2;
C3_const bmp_error_t BMP_ERROR = -1;
C3_const bmp_error_t BMP_OK = 0;

fn void bmp_error_t.ensure(bmp_error_t error) {
    if(error == BMP_OK) return;

    gen_error_type_t error_type = GEN_ERROR_UNKNOWN;
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

    gen_error_attach_backtrace_formatted(error_type, $$LINE, "BMP Error %si: `%t`", error, errname).ensure();
}

fn void GhrantosImage_t.init(GhrantosImage_t* image, char* path) {
    @ghrantos_tooling_frame() {
        image.data = {};

        bmp_img_t bmp = {};
        bmp_img_read(&bmp, path).ensure();

        image.width = bmp.img_header.biWidth;
        image.height = bmp.img_header.biHeight;

        image.data.reserve(image.width * image.height);

        for(size_t y = 0; y < image.height; ++y) {
            for(size_t x = 0; x < image.width; ++x) {
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


#pragma once

#include <ghrantos/ghrantos.h>

struct GhrantosPixel_t {
    char b;
	char g;
	char r;
}

define GhrantosImageData_t = List<GhrantosPixel_t>;

struct GhrantosImage_t {
    size_t width;
    size_t height;
    GhrantosImageData_t data;
}

#ifndef GHRANTOS_IMAGE_IMPL
extern void GhrantosImageData_t.reserve(GhrantosImageData_t* data, size_t size) @extname("image_C_GhrantosImageData_t_reserve");

extern void GhrantosImage_t.init(GhrantosImage_t* image, char* path) @extname("image_C_GhrantosImage_t_init");
extern void GhrantosImage_t.deinit(GhrantosImage_t* image) @extname("image_C_GhrantosImage_t_deinit");
#endif

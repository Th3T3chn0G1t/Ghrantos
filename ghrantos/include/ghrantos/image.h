#pragma once

#include <ghrantos/ghrantos.h>

struct GhrantosImage_t {
    size_t width;
    size_t height;
    char* data;
};

#ifndef GHRANTOS_IMAGE_IMPL
extern void GhrantosImage_t.init(GhrantosImage_t* image, char* path) @extname("image_C_GhrantosImage_t_init");
extern void GhrantosImage_t.deinit(GhrantosImage_t* image) @extname("image_C_GhrantosImage_t_deinit");
#endif

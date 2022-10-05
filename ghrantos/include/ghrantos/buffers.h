#pragma once

#include <ghrantos/ghrantos.h>

struct GhrantosVertex_t {
    float[3] position;
    float[3] color;
    float[2] uv;
};

struct GhrantosVAO_t {
    uint handle;
}

struct GhrantosVBO_t {
    uint handle;
}

struct GhrantosIBO_t {
    uint handle;
}

#ifndef GHRANTOS_BUFFERS_IMPL
extern void GhrantosVAO_t.init(GhrantosVAO_t* vao) @extname("buffers_C_GhrantosVAO_t_init");
extern void GhrantosVAO_t.deinit(GhrantosVAO_t* vao) @extname("buffers_C_GhrantosVAO_t_deinit");
extern void GhrantosVAO_t.bind(GhrantosVAO_t* vao) @extname("buffers_C_GhrantosVAO_t_bind");
extern void GhrantosVAO_t.setup_buffer_attribs(GhrantosVAO_t* vao) @extname("buffers_C_GhrantosVAO_t_setup_buffer_attribs");

extern void GhrantosVBO_t.init(GhrantosVBO_t* vbo, GhrantosVertex_t* vertices, size_t vertices_size, uint usage) @extname("buffers_C_GhrantosVBO_t_init");
extern void GhrantosVBO_t.deinit(GhrantosVBO_t* vbo) @extname("buffers_C_GhrantosVBO_t_deinit");
extern void GhrantosVBO_t.bind(GhrantosVBO_t* vbo) @extname("buffers_C_GhrantosVBO_t_bind");
#endif

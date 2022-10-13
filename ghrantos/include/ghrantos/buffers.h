// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#pragma once

#include <ghrantos/ghrantos.h>

enum GhrantosBufferUsage_t {
    STATIC_READ,
    STATIC_DRAW,

    DYNAMIC_READ,
    DYNAMIC_DRAW
}

struct GhrantosVAO_t {
    uint handle;
}

struct GhrantosVBO_t {
    uint handle;
}

struct GhrantosIBO_t {
    uint handle;
}

macro void GhrantosVAO_t.setup_buffer_attribs(GhrantosVAO_t* vao, $T_vertex_type, uint divisor) {
    @ghrantos_tooling_frame() {
        size_t offset = 0;

        $foreach($i, $field : $T_vertex_type.membersof):
            var $gltype = 0;
            var $attribproc = 0;
            $switch($field.typeid.inner):
                $case ichar: $gltype = GL_BYTE;
                $case char: $gltype = GL_UNSIGNED_BYTE;
                $case short: $gltype = GL_SHORT;
                $case ushort: $gltype = GL_UNSIGNED_SHORT;
                $case int: $gltype = GL_INT;
                $case uint: $gltype = GL_UNSIGNED_INT;
                $case float16:
                    $gltype = GL_HALF_FLOAT;
                    $attribproc = 1;
                $case float:
                    $gltype = GL_FLOAT;
                    $attribproc = 1;
                $case double:
                    $gltype = GL_DOUBLE;
                    $attribproc = 2;
            $endswitch;
            
            $if($attribproc == 0):
                glVertexAttribIPointer($i, $field.typeid.len, $gltype, $T_vertex_type.sizeof, (void*) offset);
            $elif($attribproc == 1):
                glVertexAttribPointer($i, $field.typeid.len, $gltype, false, $T_vertex_type.sizeof, (void*) offset);
            $else:
                glVertexAttribLPointer($i, $field.typeid.len, $gltype, $T_vertex_type.sizeof, (void*) offset);
            $endif;

            glEnableVertexAttribArray($i);
            glVertexAttribDivisor($i, divisor);
            offset += $field.sizeof;
        $endforeach
    };
}

#ifndef GHRANTOS_BUFFERS_IMPL
extern uint GhrantosBufferUsage_t.glusage(GhrantosBufferUsage_t usage) @extname("buffers_C_GhrantosBufferUsage_t_glusage");

extern void GhrantosVAO_t.init(GhrantosVAO_t* vao) @extname("buffers_C_GhrantosVAO_t_init");
extern void GhrantosVAO_t.deinit(GhrantosVAO_t* vao) @extname("buffers_C_GhrantosVAO_t_deinit");
extern void GhrantosVAO_t.bind(GhrantosVAO_t* vao) @extname("buffers_C_GhrantosVAO_t_bind");

extern void GhrantosVBO_t.init(GhrantosVBO_t* vbo, void* vertices, size_t vertices_size, GhrantosBufferUsage_t usage) @extname("buffers_C_GhrantosVBO_t_init");
extern void GhrantosVBO_t.deinit(GhrantosVBO_t* vbo) @extname("buffers_C_GhrantosVBO_t_deinit");
extern void GhrantosVBO_t.bind(GhrantosVBO_t* vbo) @extname("buffers_C_GhrantosVBO_t_bind");

extern void GhrantosIBO_t.init(GhrantosIBO_t* ibo, uint* indices, size_t indices_size, GhrantosBufferUsage_t usage) @extname("buffers_C_GhrantosIBO_t_init");
extern void GhrantosIBO_t.deinit(GhrantosIBO_t* ibo) @extname("buffers_C_GhrantosIBO_t_deinit");
extern void GhrantosIBO_t.bind(GhrantosIBO_t* ibo) @extname("buffers_C_GhrantosIBO_t_bind");
#endif

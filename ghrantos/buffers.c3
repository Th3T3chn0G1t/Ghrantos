// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos::buffers;

import ghrantos;
import ghrantos::graphics;

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
        usz offset = 0;

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

fn uint GhrantosBufferUsage_t.glusage(GhrantosBufferUsage_t usage) {
    @ghrantos_tooling_frame() {
        switch(usage) {
            case STATIC_READ: GHRANTOS_TOOLED_RETURN(GL_STATIC_READ);
            case STATIC_DRAW: GHRANTOS_TOOLED_RETURN(GL_STATIC_DRAW);
            
            case DYNAMIC_READ: GHRANTOS_TOOLED_RETURN(GL_DYNAMIC_READ);
            case DYNAMIC_DRAW: GHRANTOS_TOOLED_RETURN(GL_DYNAMIC_DRAW);
        }
        GHRANTOS_TOOLED_RETURN(0);
    };
}

fn void GhrantosVAO_t.init(GhrantosVAO_t* vao) {
    @ghrantos_tooling_frame() {
        glGenVertexArrays(1, &vao.handle);
    };
}

fn void GhrantosVAO_t.deinit(GhrantosVAO_t* vao) {
    @ghrantos_tooling_frame() {
        glDeleteVertexArrays(1, &vao.handle);
    };
}

fn void GhrantosVAO_t.bind(GhrantosVAO_t* vao) {
    @ghrantos_tooling_frame() {
        glBindVertexArray(vao.handle);
    };
}

fn void GhrantosVBO_t.init(GhrantosVBO_t* vbo, void* vertices, usz vertices_size, GhrantosBufferUsage_t usage) {
    @ghrantos_tooling_frame() {
        glGenBuffers(1, &vbo.handle); 
        vbo.bind();
        glBufferData(GL_ARRAY_BUFFER, vertices_size, vertices, usage.glusage());
    };
}

fn void GhrantosVBO_t.deinit(GhrantosVBO_t* vbo) {
    @ghrantos_tooling_frame() {
        glDeleteBuffers(1, &vbo.handle);
    };
}

fn void GhrantosVBO_t.bind(GhrantosVBO_t* vbo) {
    @ghrantos_tooling_frame() {
        glBindBuffer(GL_ARRAY_BUFFER, vbo.handle);
    };
}

fn void GhrantosIBO_t.init(GhrantosIBO_t* ibo, uint* indices, usz indices_size, GhrantosBufferUsage_t usage) {
    @ghrantos_tooling_frame() {
        glGenBuffers(1, &ibo.handle);
        ibo.bind();
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices_size, indices, usage.glusage());
    };
}

fn void GhrantosIBO_t.deinit(GhrantosIBO_t* ibo) {
    @ghrantos_tooling_frame() {
        glDeleteBuffers(1, &ibo.handle);
    };
}

fn void GhrantosIBO_t.bind(GhrantosIBO_t* ibo) {
    @ghrantos_tooling_frame() {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo.handle);
    };
}



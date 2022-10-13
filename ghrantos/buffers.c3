// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#include <ghrantos/ghrantos.h>
#include <ghrantos/graphics.h>
#define GHRANTOS_BUFFERS_IMPL
#include <ghrantos/buffers.h>

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

fn void GhrantosVBO_t.init(GhrantosVBO_t* vbo, void* vertices, size_t vertices_size, GhrantosBufferUsage_t usage) {
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

fn void GhrantosIBO_t.init(GhrantosIBO_t* ibo, uint* indices, size_t indices_size, GhrantosBufferUsage_t usage) {
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



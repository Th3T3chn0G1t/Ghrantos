#include <ghrantos/ghrantos.h>
#include <ghrantos/window.h>
#define GHRANTOS_BUFFERS_IMPL
#include <ghrantos/buffers.h>

fn void GhrantosVAO_t.init(GhrantosVAO_t* vao) {
    @ghrantos_tooling_frame() {
        glGenVertexArrays(1, &vao.handle);
    };
}

fn void GhrantosVAO_t.setup_buffer_attribs(GhrantosVAO_t* vao) {
    @ghrantos_tooling_frame() {
        // TODO: Generate from GhrantosVertex_t.fields
        size_t offset = 0;
        
        glVertexAttribPointer(0, GhrantosVertex_t.position.len, GL_FLOAT, GL_FALSE, GhrantosVertex_t.sizeof, (void*) offset);
        glEnableVertexAttribArray(0);
        offset += GhrantosVertex_t.position.sizeof;

        glVertexAttribPointer(1, GhrantosVertex_t.color.len, GL_FLOAT, GL_FALSE, GhrantosVertex_t.sizeof, (void*) offset);
        glEnableVertexAttribArray(1);
        offset += GhrantosVertex_t.color.sizeof;

        glVertexAttribPointer(2, GhrantosVertex_t.uv.len, GL_FLOAT, GL_FALSE, GhrantosVertex_t.sizeof, (void*) offset);
        glEnableVertexAttribArray(2);
        offset += GhrantosVertex_t.uv.sizeof;
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

fn void GhrantosVBO_t.init(GhrantosVBO_t* vbo, GhrantosVertex_t* vertices, size_t vertices_size, uint usage) {
    @ghrantos_tooling_frame() {
        glGenBuffers(1, &vbo.handle); 
        vbo.bind();
        glBufferData(GL_ARRAY_BUFFER, vertices_size, vertices, usage);
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

fn void GhrantosIBO_t.init(GhrantosIBO_t* ibo, uint* indices, size_t indices_size, uint usage) {
    @ghrantos_tooling_frame() {
        glGenBuffers(1, &ibo.handle);
        ibo.bind();
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices_size, indices, usage);
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



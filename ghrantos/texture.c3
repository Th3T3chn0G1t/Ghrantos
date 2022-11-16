// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos::texture;

import ghrantos;
import ghrantos::graphics;
import ghrantos::image;

struct GhrantosTexture_t {
    uint handle;
}

fn void GhrantosTexture_t.init(GhrantosTexture_t* texture, GhrantosImage_t* image) {
    @ghrantos_tooling_frame() {
        glGenTextures(1, &texture.handle);
        glBindTexture(GL_TEXTURE_2D, texture.handle);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8, (int) image.width, (int) image.height, 0, GL_BGR, GL_UNSIGNED_BYTE, image.data.entries);
    };
}

fn void GhrantosTexture_t.deinit(GhrantosTexture_t* texture) {
    @ghrantos_tooling_frame() {
        glDeleteTextures(1, &texture.handle);
    };
}

fn void GhrantosTexture_t.bind(GhrantosTexture_t* texture, uint slot) {
    @ghrantos_tooling_frame() {
        glActiveTexture(GL_TEXTURE0 + slot);
        glBindTexture(GL_TEXTURE_2D, texture.handle);
    };
}

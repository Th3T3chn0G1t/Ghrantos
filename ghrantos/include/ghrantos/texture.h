// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#pragma once

#include <ghrantos/ghrantos.h>
#include <ghrantos/image.h>

struct GhrantosTexture_t {
    uint handle;
};

#ifndef GHRANTOS_TEXTURE_IMPL
extern void GhrantosTexture_t.init(GhrantosTexture_t* texture, GhrantosImage_t* image) @extname("texture_C_GhrantosTexture_t_init");
extern void GhrantosTexture_t.deinit(GhrantosTexture_t* texture) @extname("texture_C_GhrantosTexture_t_deinit");
extern void GhrantosTexture_t.bind(GhrantosTexture_t* texture, uint slot) @extname("texture_C_GhrantosTexture_t_bind");
#endif

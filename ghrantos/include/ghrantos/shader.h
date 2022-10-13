// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#pragma once

#include <ghrantos/ghrantos.h>

enum GhrantosShaderStageType_t {
    VERTEX,
    FRAGMENT
}

struct GhrantosShaderStage_t {
    uint handle;
    GhrantosShaderStageType_t stage;
}

define GhrantosUniformMap_t = HashMap<char*, int>;

struct GhrantosShaderProgram_t {
    uint handle;

    GhrantosUniformMap_t uniform_locations;
}

macro void GhrantosShaderProgram_t.uniform(GhrantosShaderProgram_t* program, char* name, value) {
    int! loc = program.uniform_locations.get(name);
    if(catch err = loc) {
        program.uniform_locations.set(name, glGetUniformLocation(program.handle, name));
    }
    program.bind();
    $switch($typeof(value)):
        $case double:
            glUniform1f(loc, (float) value);
        $case float:
            glUniform1f(loc, value);
        $case uint:
            glUniform1ui(loc, value);
        $case int:
            glUniform1i(loc, value);
        $case float[<4>][4]:
            glUniformMatrix4fv(loc, 1, false, (float*) &value);
    $endswitch;
}

#ifndef GHRANTOS_SHADER_IMPL
extern uint GhrantosShaderStageType_t.gltype(GhrantosShaderStageType_t stage_type) @extname("shader_C_GhrantosShaderStageType_t_gltype");

extern void GhrantosShaderStage_t.init(GhrantosShaderStage_t* stage, char* path, GhrantosShaderStageType_t stage_type) @extname("shader_C_GhrantosShaderStage_t_init");
extern void GhrantosShaderStage_t.deinit(GhrantosShaderStage_t* stage) @extname("shader_C_GhrantosShaderStage_t_deinit");

extern void GhrantosShaderProgram_t.init(GhrantosShaderProgram_t* program, GhrantosShaderStage_t*... stages) @extname("shader_C_GhrantosShaderProgram_t_init");
extern void GhrantosShaderProgram_t.deinit(GhrantosShaderProgram_t* program) @extname("shader_C_GhrantosShaderProgram_t_deinit");
extern void GhrantosShaderProgram_t.bind(GhrantosShaderProgram_t* program) @extname("shader_C_GhrantosShaderProgram_t_bind");
#endif

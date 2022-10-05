#pragma once

#include <ghrantos/ghrantos.h>

struct GhrantosShaderStage_t {
    uint handle;
    uint stage;
    char* source;
}

struct GhrantosShaderProgram_t {
    uint handle;

    uint stages_count;
    GhrantosShaderStage_t** stages;
}

#ifndef GHRANTOS_SHADER_IMPL
extern void GhrantosShaderStage_t.init(GhrantosShaderStage_t* stage, char* path, uint stage_type) @extname("shader_C_GhrantosShaderStage_t_init");
extern void GhrantosShaderStage_t.deinit(GhrantosShaderStage_t* stage) @extname("shader_C_GhrantosShaderStage_t_deinit");

extern void GhrantosShaderProgram_t.init(GhrantosShaderProgram_t* program, GhrantosShaderStage_t*... stages) @extname("shader_C_GhrantosShaderProgram_t_init");
extern void GhrantosShaderProgram_t.deinit(GhrantosShaderProgram_t* program) @extname("shader_C_GhrantosShaderProgram_t_deinit");
extern void GhrantosShaderProgram_t.bind(GhrantosShaderProgram_t* program) @extname("shader_C_GhrantosShaderProgram_t_bind");
#endif

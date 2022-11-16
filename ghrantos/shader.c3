// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos::shader;

import ghrantos;
import ghrantos::graphics;
import ghrantos::fs;

import std::map;

#include <genmemory.h>

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

fn uint GhrantosShaderStageType_t.gltype(GhrantosShaderStageType_t stage_type) {
    @ghrantos_tooling_frame() {
        switch(stage_type) {
            case VERTEX: GHRANTOS_TOOLED_RETURN(GL_VERTEX_SHADER);
            case FRAGMENT: GHRANTOS_TOOLED_RETURN(GL_FRAGMENT_SHADER);
        }
        GHRANTOS_TOOLED_RETURN(0);
    };
}

fn void GhrantosShaderStage_t.init(GhrantosShaderStage_t* stage, char* path, GhrantosShaderStageType_t stage_type) {
    @ghrantos_tooling_frame() {
        GhrantosFSHandle_t handle = {};
        handle.init(path);
        GhrantosByteBuffer_t source = handle.read_all();
        handle.deinit();

        stage.stage = stage_type;

        stage.handle = glCreateShader(stage_type.gltype());
        glShaderSource(stage.handle, 1, &source.entries, null);
        glCompileShader(stage.handle);

        int result = 0;
        glGetShaderiv(stage.handle, GL_COMPILE_STATUS, &result);
        if(!result) {
            int length = 0;
            glGetShaderiv(stage.handle, GL_INFO_LOG_LENGTH, &length);

            char* log = null;
            // TODO: Replace with list
            gen_memory_allocate_zeroed((void**) &log, length, char.sizeof).ensure();

            glGetShaderInfoLog(stage.handle, length, null, log);

            gen_error_attach_backtrace_formatted(GEN_ERROR_BAD_OPERATION, $$LINE, "Failed to compile shader `%t`:`%t`", path, log).ensure();
        }

        source.free();
    };
}

fn void GhrantosShaderStage_t.deinit(GhrantosShaderStage_t* stage) {
    @ghrantos_tooling_frame() {
        glDeleteShader(stage.handle);
    };
}


fn void GhrantosShaderProgram_t.init(GhrantosShaderProgram_t* program, GhrantosShaderStage_t*... stages) {
    @ghrantos_tooling_frame() {
        program.handle = glCreateProgram();

        foreach(i, stage : stages) {
            glAttachShader(program.handle, stage.handle);
        }
        glLinkProgram(program.handle);

        int result = 0;
        glGetProgramiv(program.handle, GL_LINK_STATUS, &result);
        if(!result) {
            int length = 0;
            glGetProgramiv(program.handle, GL_INFO_LOG_LENGTH, &length);

            char* log = null;
            // TODO: Replace with list
            gen_memory_allocate_zeroed((void**) &log, length, char.sizeof);

            glGetProgramInfoLog(program.handle, length, null, log);

            gen_error_attach_backtrace_formatted(GEN_ERROR_BAD_OPERATION, $$LINE, "Failed to link shader program: `%t`", log).ensure();
        }
    };
}

fn void GhrantosShaderProgram_t.deinit(GhrantosShaderProgram_t* program) {
    @ghrantos_tooling_frame() {
        glDeleteProgram(program.handle);
        program.uniform_locations.destroy();
    };
}

fn void GhrantosShaderProgram_t.bind(GhrantosShaderProgram_t* program) {
    @ghrantos_tooling_frame() {
        glUseProgram(program.handle);
    };
}

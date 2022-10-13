// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#include <ghrantos/ghrantos.h>
#define GHRANTOS_WINDOW_IMPL
#include <ghrantos/window.h>

#include <genstring.h>

static initialize {
    glfwSetErrorCallback(&ghrantos_glfw_error_callback);
    gladSetGLPostCallback(&ghrantos_glad_callback);
    glfwInit();
}

fn void ghrantos_nil_glad_callback(void* ret, char* name, GLADapiproc_t apiproc, int len_args, ...) {}

fn void ghrantos_glad_callback(void* ret, char* name, GLADapiproc_t apiproc, int len_args, ...) {
    @ghrantos_tooling_frame() {
        gladSetGLPostCallback(&ghrantos_nil_glad_callback);
        int error = glGetError();
        gladSetGLPostCallback(&ghrantos_glad_callback);

        char* errname = null;
        switch(error) {
            case GL_NO_ERROR: GHRANTOS_TOOLED_RETURN();
            case GL_INVALID_ENUM: errname = "GL_INVALID_ENUM";
            case GL_INVALID_VALUE: errname = "GL_INVALID_VALUE";
            case GL_INVALID_OPERATION: errname = "GL_INVALID_OPERATION";
            case GL_INVALID_FRAMEBUFFER_OPERATION: errname = "GL_INVALID_FRAMEBUFFER_OPERATION";
            case GL_OUT_OF_MEMORY: errname = "GL_OUT_OF_MEMORY";
            case GL_STACK_UNDERFLOW: errname = "GL_STACK_UNDERFLOW";
            case GL_STACK_OVERFLOW: errname = "GL_STACK_OVERFLOW";
        }

        gen_error_attach_backtrace_formatted(GEN_ERROR_BAD_OPERATION, $$LINE, "GL Error %si: `%t` in %t()", error, errname, name).ensure();
    };
}

fn void ghrantos_glfw_error_callback(int errcode, char* message) {
    @ghrantos_tooling_frame() {
        gen_error_attach_backtrace_formatted(GEN_ERROR_BAD_OPERATION, $$LINE, "GLFW Error %si: \"%t\"", errcode, message).ensure();
    };
}

fn void ghrantos_glfw_resize_callback(GLFWwindow* glfw_window, int width, int height) {
    @ghrantos_tooling_frame() {
        GhrantosWindow_t* window = glfwGetWindowUserPointer(glfw_window);
        glViewport(0, 0, width, height);
        window.resize_callback((size_t) width, (size_t) height, window.passthrough);
    };
}

fn void GhrantosWindow_t.init(GhrantosWindow_t* window, size_t width, size_t height, char* title) {
    @ghrantos_tooling_frame() {
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
#if C3_GEN_PLATFORM == GEN_OSX
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

        window.glfw_window = glfwCreateWindow((int) width, (int) height, title, null, null);
        glfwSetWindowUserPointer(window.glfw_window, window);
        glfwMakeContextCurrent(window.glfw_window);

        glfwSetFramebufferSizeCallback(window.glfw_window, &ghrantos_glfw_resize_callback);

        int version = gladLoadGL((GLADloadfunc_t) &glfwGetProcAddress);
        gen_log_formatted(GEN_LOG_LEVEL_INFO, GHRANTOS_APP_NAME, "Initialized OpenGL %ui.%ui", GLAD_VERSION_MAJOR(version), GLAD_VERSION_MINOR(version));

        glViewport(0, 0, (int) width, (int) height);
    };
}

fn bool GhrantosWindow_t.should_close(GhrantosWindow_t* window) {
    @ghrantos_tooling_frame() {
        GHRANTOS_TOOLED_RETURN(glfwWindowShouldClose(window.glfw_window));
    };
}

fn void GhrantosWindow_t.update(GhrantosWindow_t* window) {
    @ghrantos_tooling_frame() {
        glfwSwapBuffers(window.glfw_window);
        glfwPollEvents();
    };
}

fn bool GhrantosWindow_t.get_key_state(GhrantosWindow_t* window, int key) {
    @ghrantos_tooling_frame() {
        GHRANTOS_TOOLED_RETURN(glfwGetKey(window.glfw_window, key) == GLFW_PRESS);
    };
}

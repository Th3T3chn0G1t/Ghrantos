#pragma once

#include <ghrantos/ghrantos.h>

#include <glad/gl.h>
#include <GLFW/glfw3.h>

struct GhrantosWindow_t {
    GLFWwindow_t* glfw_window;
}

#ifndef GHRANTOS_WINDOW_IMPL
extern void GhrantosWindow_t.init(GhrantosWindow_t* window, size_t width, size_t height, char* title) @extname("window_C_GhrantosWindow_t_init");
extern bool GhrantosWindow_t.should_close(GhrantosWindow_t* window) @extname("window_C_GhrantosWindow_t_should_close");
extern void GhrantosWindow_t.update(GhrantosWindow_t* window) @extname("window_C_GhrantosWindow_t_update");
extern bool GhrantosWindow_t.get_key_state(GhrantosWindow_t* window, int key) @extname("window_C_GhrantosWindow_t_get_key_state");
#endif

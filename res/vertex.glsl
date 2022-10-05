#version 330 core

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 color;
layout(location = 2) in vec2 uv;

out vec3 vertex_color;
out vec2 vertex_uv;

void main() {
    gl_Position = vec4(position, 1.0);
    vertex_color = color;
    vertex_uv = uv;
}

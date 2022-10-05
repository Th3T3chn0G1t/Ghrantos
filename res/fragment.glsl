#version 330 core

in vec3 vertex_color;
in vec2 vertex_uv;

uniform sampler2D uniform_texture;

out vec4 color;

void main() {
    color = texture(uniform_texture, vertex_uv) * vec4(vertex_color, 1.0f);
}

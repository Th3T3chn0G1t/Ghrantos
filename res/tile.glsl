#version 410 core

layout(location = 0) in uint id;

uniform mat4 uniform_pv;
uniform mat4 uniform_model;

out vec3 vertex_color;
out vec2 vertex_uv;

void main() {
    float tile_extent = 0.25;

    int index = gl_InstanceID;
    int vertex = gl_VertexID % 6;

    float x_raw = tile_extent * index;

    vec3 positions[] = vec3[](
        vec3(x_raw, 0.0, 0.0),
        vec3(x_raw + tile_extent, 0.0, 0.0),
        vec3(x_raw + tile_extent, tile_extent, 0.0),
        vec3(x_raw + tile_extent, tile_extent, 0.0),
        vec3(x_raw, tile_extent, 0.0),
        vec3(x_raw, 0.0, 0.0)
    );

    vec2 uvs[] = vec2[](
        vec2(0.0, 0.0),
        vec2(1.0, 0.0),
        vec2(1.0, 1.0),
        vec2(1.0, 1.0),
        vec2(0.0, 1.0),
        vec2(0.0, 0.0)
    );

    gl_Position = uniform_pv * uniform_model * vec4(positions[vertex], 1.0);
    if(id == 1) {
        vertex_color = vec3(1.0, 1.0, 1.0);
    }
    else {
        vertex_color = vec3(1.0, 0.0, 0.0);
    }
    vertex_uv = uvs[vertex];
}

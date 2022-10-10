#version 410 core

layout(location = 0) in uint id;

uniform float uniform_atlas_element_extent;
uniform float uniform_tile_extent;

uniform mat4 uniform_pv;
uniform mat4 uniform_model;

out vec3 vertex_color;
out vec2 vertex_uv;

void main() {
    int index = gl_InstanceID;
    int vertex = gl_VertexID % 6;

    float x_raw = uniform_tile_extent * index;

    vec2 positions[] = vec2[](
        vec2(x_raw, 0.0),
        vec2(x_raw + uniform_tile_extent, 0.0),
        vec2(x_raw + uniform_tile_extent, uniform_tile_extent),
        vec2(x_raw + uniform_tile_extent, uniform_tile_extent),
        vec2(x_raw, uniform_tile_extent),
        vec2(x_raw, 0.0)
    );

    float atlas_offset = id * uniform_atlas_element_extent;
    float atlas_floor = floor(atlas_offset);
    float atlas_x = atlas_offset - atlas_floor;
    float atlas_y = atlas_floor * uniform_atlas_element_extent;

    vec2 uvs[] = vec2[](
        vec2(atlas_x, atlas_y),
        vec2(atlas_x + uniform_atlas_element_extent, atlas_y),
        vec2(atlas_x + uniform_atlas_element_extent, atlas_y + uniform_atlas_element_extent),
        vec2(atlas_x + uniform_atlas_element_extent, atlas_y + uniform_atlas_element_extent),
        vec2(atlas_x, atlas_y + uniform_atlas_element_extent),
        vec2(atlas_x, atlas_y)
    );

    gl_Position = uniform_pv * uniform_model * vec4(positions[vertex], 0.0, 1.0);

    vertex_color = vec3(1.0, 1.0, 1.0);

    vertex_uv = uvs[vertex];
}

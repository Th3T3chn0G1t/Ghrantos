#version 410 core

layout(location = 0) in uint id;

uniform float uniform_atlas_element_extent;
uniform float uniform_tile_extent;

uniform mat4 uniform_pv;
uniform mat4 uniform_model;

uniform uint uniform_tilemap_width;

out vec3 vertex_color;
out vec2 vertex_uv;

void main() {
    int index = gl_InstanceID;
    int vertex = gl_VertexID % 6;

    float x_raw = uniform_tile_extent * (index % uniform_tilemap_width);
    float y_raw = -uniform_tile_extent * (index / uniform_tilemap_width);

    vec2 positions[] = vec2[](
        vec2(x_raw, y_raw),
        vec2(x_raw + uniform_tile_extent, y_raw),
        vec2(x_raw + uniform_tile_extent, y_raw + uniform_tile_extent),
        vec2(x_raw + uniform_tile_extent, y_raw + uniform_tile_extent),
        vec2(x_raw, y_raw + uniform_tile_extent),
        vec2(x_raw, y_raw)
    );

    float atlas_offset = id * uniform_atlas_element_extent;
    float atlas_floor = floor(atlas_offset);
    float atlas_x = atlas_offset - atlas_floor;
    float atlas_y = 1.0 - ((atlas_floor + 1) * uniform_atlas_element_extent);

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

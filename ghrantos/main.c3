#include <ghrantos/ghrantos.h>
#include <ghrantos/graphics.h>
#include <ghrantos/window.h>
#include <ghrantos/surface.h>
#include <ghrantos/shader.h>
#include <ghrantos/fs.h>
#include <ghrantos/buffers.h>
#include <ghrantos/image.h>
#include <ghrantos/texture.h>
#include <ghrantos/math.h>
#include <ghrantos/transform2d.h>

#include <genmemory.h>

extern int printf(char* format, ...);

struct GhrantosVertex_t @packed {
    float[<3>] position;
    float[<3>] color;
    float[<2>] uv;
}

struct GhrantosTile_t @packed {
    uint[1] id;
}

void ghrantos_resize_projection(size_t width, size_t height, void* passthrough) {
    float[<4>][4]* projection = passthrough;

    float aspect_ratio = width / height;
    projection.ortho(0.1, 100.0, -aspect_ratio, aspect_ratio, 1.0, -1.0);
}

fn void main() {
    @ghrantos_tooling_frame() {
        io::println("Hello, C3 stdlib!");
        gen_log(GEN_LOG_LEVEL_DEBUG, GHRANTOS_APP_NAME, "Hello, Genstone!");

        GhrantosWindow_t window = {};
        float window_width = 640;
        float window_height = 480;
        window.init((size_t) window_width, (size_t) window_height, GHRANTOS_APP_NAME);

        GhrantosSurface_t surface = {};
        surface.init(&window);

        GhrantosVertex_t[*] vertices = {
            {{-0.5, -0.5, 0.0}, {1.0, 1.0, 1.0}, {0.0, 0.0}},
            {{ 0.5, -0.5, 0.0}, {1.0, 1.0, 1.0}, {1.0, 0.0}},
            {{ 0.5,  0.5, 0.0}, {1.0, 1.0, 1.0}, {1.0, 1.0}},
            {{-0.5,  0.5, 0.0}, {1.0, 1.0, 1.0}, {0.0, 1.0}}
        };

        uint[*] indices = {
            0, 1, 2,
            2, 3, 0
        };

        int[*] map = {
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            -1,87,88,88,88,88,88,88,89,-1,
            -1,107,108,108,108,108,108,108,109,-1,
            -1,107,108,108,128,128,108,108,109,-1,
            -1,107,108,109,-1,6,107,108,109,-1,
            -1,107,108,109,248,36,107,108,109,-1,
            -1,107,108,108,88,88,108,108,109,-1,
            -1,107,108,108,108,108,108,108,109,-1,
            -1,127,128,128,128,128,128,128,129,-1,
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        };

        uint map_width = 10;

        uint atlas_element_extent = 16;

        GhrantosImage_t tilemap_image = {};
        tilemap_image.init("res/monochrome_tilemap_packed.bmp");

        uint atlas_extent = atlas_element_extent / (uint) tilemap_image.width;
        uint atlas_element_count = atlas_extent * atlas_extent;

        GhrantosTexture_t tilemap = {};
        tilemap.init(&tilemap_image);

        GhrantosTile_t* tiles = null;
        size_t tiles_len = map.len;
        // size_t tiles_len = 100;
        gen_memory_allocate_zeroed((void**) &tiles, tiles_len, sizeof(GhrantosTile_t));
        foreach(i, tile : map) {
            // Tilemaps seem to be read from the bottom-left corner LTR upwards for some reason
            // This can probably be fixed in shader land but this works for now and is static so
            // Probably more performant.
            if(tile == -1) {
                tiles[i] = GhrantosTile_t{{0}};
            }
            else {
                tiles[i] = GhrantosTile_t{{tile}};
            }
        }
        // for(size_t i = 0; i < tiles_len; ++i) {
        //     tiles[i] = GhrantosTile_t{{(uint) i}};
        // }

        GhrantosShaderStage_t vertex = {};
        vertex.init("res/vertex.glsl", VERTEX);

        GhrantosShaderStage_t fragment = {};
        fragment.init("res/fragment.glsl", FRAGMENT);

        GhrantosShaderProgram_t program = {};
        program.init(&vertex, &fragment);

        GhrantosShaderStage_t tile_vertex = {};
        tile_vertex.init("res/tile.glsl", VERTEX);

        GhrantosShaderStage_t tile_fragment = {};
        tile_fragment.init("res/fragment.glsl", FRAGMENT);

        GhrantosShaderProgram_t tile_program = {};
        tile_program.init(&tile_vertex, &tile_fragment);

        GhrantosVAO_t vao = {};
        vao.init();
        vao.bind();

        GhrantosVBO_t vbo = {};
        vbo.init(&vertices, $sizeof(vertices), STATIC_DRAW);

        GhrantosIBO_t ibo = {};
        ibo.init(&indices, $sizeof(indices), STATIC_DRAW);

        vao.setup_buffer_attribs(GhrantosVertex_t, 0);

        GhrantosVAO_t tile_vao = {};
        tile_vao.init();
        tile_vao.bind();

        GhrantosVBO_t tile_vbo = {};
        tile_vbo.init(tiles, tiles_len * sizeof(GhrantosTile_t), STATIC_DRAW);

        vao.setup_buffer_attribs(GhrantosTile_t, 1);

        GhrantosImage_t image = {};
        image.init("res/test.bmp");

        GhrantosTexture_t texture = {};
        texture.init(&image);

        image.deinit();

        GhrantosTransform2D_t tile = {{0.25, -0.75}, {1.0, 1.0}, 0.0};
        GhrantosTransform2D_t sprite = {{0.25, 0.25}, {0.5, 0.5}, 3.1415 / 4.0};
        GhrantosTransform2D_t camera = {{0.0, 0.0}, {1.0, 1.0}, 0.0};
        float[<4>][4] projection = {};
        projection.ident();

        float aspect_ratio = window_width / window_height;
        projection.ortho(0.1, 100.0, -aspect_ratio, aspect_ratio, 1.0, -1.0);

        window.resize_callback = &ghrantos_resize_projection;
        window.passthrough = &projection;

        while (!window.should_close()) {
            if(window.get_key_state(GLFW_KEY_ESCAPE)) {
                GHRANTOS_TOOLED_RETURN();
            }

            float[<3>] cam_translate = {};
            float speed = 0.1;
            if(window.get_key_state(GLFW_KEY_W)) {
                camera.translation[1] += speed;
            }
            if(window.get_key_state(GLFW_KEY_S)) {
                camera.translation[1] -= speed;
            }
            if(window.get_key_state(GLFW_KEY_A)) {
                camera.translation[0] -= speed;
            }
            if(window.get_key_state(GLFW_KEY_D)) {
                camera.translation[0] += speed;
            }

            sprite.rotation += 0.1;

            float[4] clear_color = {0.4, 0.4, 0.4, 1.0};
            surface.clear(clear_color);

            float[<4>][4] pv = {};
            {
                pv.ident();
                pv.mul(&projection);
                float[<4>][4] view = camera.mat(true);
                pv.mul(&view);
            }

            {
                program.bind();

                texture.bind(0);
                program.uniform("uniform_texture", 0);

                program.uniform("uniform_pv", pv);
                program.uniform("uniform_model", sprite.mat());

                vao.bind();
                ibo.bind();

                surface.draw(INDEXED, indices.len, 1);
            }
            
            {
                tile_program.bind();

                tilemap.bind(0);
                tile_program.uniform("uniform_texture", 0);

                tile_program.uniform("uniform_pv", pv);
                tile_program.uniform("uniform_model", tile.mat());

                tile_program.uniform("uniform_atlas_element_extent", (float) atlas_element_extent / (float) tilemap_image.width);
                tile_program.uniform("uniform_tile_extent", 0.25);

                tile_program.uniform("uniform_tilemap_width", map_width);

                tile_vao.bind();
                
                surface.draw(NORMAL, 6, (uint) tiles_len);
            }
            
            window.update();
        }
    };
}

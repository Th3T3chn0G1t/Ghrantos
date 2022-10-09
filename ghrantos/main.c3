#include <ghrantos/ghrantos.h>
#include <ghrantos/window.h>
#include <ghrantos/shader.h>
#include <ghrantos/fs.h>
#include <ghrantos/buffers.h>
#include <ghrantos/image.h>
#include <ghrantos/texture.h>
#include <ghrantos/math.h>

#include <genmemory.h>

extern int printf(char* format, ...);

struct GhrantosVertex_t @packed {
    float[<3>] position;
    float[<3>] color;
    float[<2>] uv;
}

enum GhrantosTileID_t {
    EMPTY,
    WALL
}

struct GhrantosTile_t @packed {
    uint[1] id;
}

fn void main() {
    @ghrantos_tooling_frame() {
        gen_log(GEN_LOG_LEVEL_DEBUG, GHRANTOS_APP_NAME, "Hello, Genstone!");

        GhrantosWindow_t window = {};
        float window_width = 640;
        float window_height = 480;
        window.init((size_t) window_width, (size_t) window_height, GHRANTOS_APP_NAME);

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

        GhrantosTile_t[*] tiles = {
            {{GhrantosTileID_t.WALL}}, {{GhrantosTileID_t.EMPTY}},
            {{GhrantosTileID_t.WALL}}, {{GhrantosTileID_t.WALL}},
            {{GhrantosTileID_t.EMPTY}}, {{GhrantosTileID_t.WALL}},
            {{GhrantosTileID_t.EMPTY}}, {{GhrantosTileID_t.EMPTY}}
        };

        GhrantosShaderStage_t vertex = {};
        vertex.init("res/vertex.glsl", GL_VERTEX_SHADER);

        GhrantosShaderStage_t fragment = {};
        fragment.init("res/fragment.glsl", GL_FRAGMENT_SHADER);

        GhrantosShaderProgram_t program = {};
        program.init(&vertex, &fragment);
        int uniform_texture = glGetUniformLocation(program.handle, "uniform_texture");
        int uniform_pv = glGetUniformLocation(program.handle, "uniform_pv");
        int uniform_model = glGetUniformLocation(program.handle, "uniform_model");

        GhrantosShaderStage_t tile_vertex = {};
        tile_vertex.init("res/tile.glsl", GL_VERTEX_SHADER);

        GhrantosShaderStage_t tile_fragment = {};
        tile_fragment.init("res/fragment.glsl", GL_FRAGMENT_SHADER);

        GhrantosShaderProgram_t tile_program = {};
        tile_program.init(&tile_vertex, &tile_fragment);
        int tile_uniform_texture = glGetUniformLocation(tile_program.handle, "uniform_texture");
        int tile_uniform_pv = glGetUniformLocation(tile_program.handle, "uniform_pv");
        int tile_uniform_model = glGetUniformLocation(tile_program.handle, "uniform_model");

        GhrantosVAO_t vao = {};
        vao.init();
        vao.bind();

        GhrantosVBO_t vbo = {};
        vbo.init(&vertices, $sizeof(vertices), GL_STATIC_DRAW);

        GhrantosIBO_t ibo = {};
        ibo.init(&indices, $sizeof(indices), GL_STATIC_DRAW);

        vao.setup_buffer_attribs(GhrantosVertex_t, 0);

        GhrantosVAO_t tile_vao = {};
        tile_vao.init();
        tile_vao.bind();

        GhrantosVBO_t tile_vbo = {};
        tile_vbo.init(&tiles, $sizeof(tiles), GL_STATIC_DRAW);

        vao.setup_buffer_attribs(GhrantosTile_t, 1);

        GhrantosImage_t image = {};
        image.init("res/test.bmp");

        GhrantosTexture_t texture = {};
        texture.init(&image);

        image.deinit();

        float[<4>][4] tile_model = {};
        tile_model.ident();

        float[<4>][4] model = {};
        model.ident();
        float[<4>][4] view = {};
        view.ident();
        float[<4>][4] projection = {};
        projection.ident();

        float[<*>] translation = {0.25, 0.25, 0.25};
        float[<*>] scale = {0.5, 0.5, 0.5};
        float[<*>] rotate_z = {0.0, 0.0, 1.0};
        model.translate(&translation);
        model.scale(&scale);
        model.rotate(&rotate_z, 3.1415 / 4);

        float[<*>] tile_translation = {0.0, -0.75, 0.25};
        tile_model.translate(&tile_translation);

        float aspect_ratio = window_width / window_height;
        projection.ortho(0.1, 100.0, -aspect_ratio, aspect_ratio, 1.0, -1.0);

        float[<4>][4] pv = {};
        pv.ident();
        pv.mul(&projection);
        pv.mul(&view);

        while (!window.should_close()) {
            if(window.get_key_state(GLFW_KEY_ESCAPE)) {
                GHRANTOS_TOOLED_RETURN();
            }

            float[<3>] cam_translate = {};
            float speed = 0.1;
            if(window.get_key_state(GLFW_KEY_W)) {
                cam_translate = {0.0, -speed, 0.0};
            }
            if(window.get_key_state(GLFW_KEY_S)) {
                cam_translate = {0.0, speed, 0.0};
            }
            if(window.get_key_state(GLFW_KEY_A)) {
                cam_translate = {speed, 0.0, 0.0};
            }
            if(window.get_key_state(GLFW_KEY_D)) {
                cam_translate = {-speed, 0.0, 0.0};
            }
            view.translate(&cam_translate);

            model.rotate(&rotate_z, 0.1);

            glClearColor(0.4, 0.4, 0.4, 1.0);
            glClear(GL_COLOR_BUFFER_BIT);

            program.bind();
            texture.bind(0);
            glUniform1i(uniform_texture, 0);
            pv.ident();
            pv.mul(&projection);
            pv.mul(&view);
            glUniformMatrix4fv(uniform_pv, 1, false, (float*) &pv);
            glUniformMatrix4fv(uniform_model, 1, false, (float*) &model);
            vao.bind();
            ibo.bind();
            glDrawElements(GL_TRIANGLES, indices.len, GL_UNSIGNED_INT, null);

            tile_program.bind();
            texture.bind(0);
            glUniform1i(tile_uniform_texture, 0);
            pv.ident();
            pv.mul(&projection);
            pv.mul(&view);
            glUniformMatrix4fv(tile_uniform_pv, 1, false, (float*) &pv);
            glUniformMatrix4fv(tile_uniform_model, 1, false, (float*) &tile_model);
            tile_vao.bind();

            glDrawArraysInstanced(GL_TRIANGLES, 0, 6, tiles.len);

            window.update();
        }
    };
}

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

        GhrantosShaderStage_t vertex = {};
        vertex.init("res/vertex.glsl", GL_VERTEX_SHADER);

        GhrantosShaderStage_t fragment = {};
        fragment.init("res/fragment.glsl", GL_FRAGMENT_SHADER);

        GhrantosShaderProgram_t program = {};
        program.init(&vertex, &fragment);
        int uniform_texture = glGetUniformLocation(program.handle, "uniform_texture");
        int uniform_pvm = glGetUniformLocation(program.handle, "uniform_pvm");

        GhrantosVAO_t vao = {};
        vao.init();
        vao.bind();

        GhrantosVBO_t vbo = {};
        vbo.init(&vertices, $sizeof(vertices), GL_STATIC_DRAW);

        GhrantosIBO_t ibo = {};
        ibo.init(&indices, $sizeof(indices), GL_STATIC_DRAW);

        vao.setup_buffer_attribs();

        GhrantosImage_t image = {};
        image.init("res/test.bmp");

        GhrantosTexture_t texture = {};
        texture.init(&image);

        image.deinit();

        // foreach(v : a) {
        //     printf("%f %f %f %f\n", v[0], v[1], v[2], v[3]);
        // }

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

        float aspect_ratio = window_width / window_height;
        projection.ortho(0.1, 100.0, -aspect_ratio, aspect_ratio, 1.0, -1.0);

        float[<4>][4] pvm = {};
        pvm.ident();
        pvm.mul(&projection);
        pvm.mul(&view);
        pvm.mul(&model);

        while (!window.should_close()) {
            model.rotate(&rotate_z, 0.1);

            glClearColor(0.4, 0.4, 0.4, 1.0);
            glClear(GL_COLOR_BUFFER_BIT);

            program.bind();
            texture.bind(0);
            glUniform1i(uniform_texture, 0);
            pvm.ident();
            pvm.mul(&projection);
            pvm.mul(&view);
            pvm.mul(&model);
            glUniformMatrix4fv(uniform_pvm, 1, false, (float*) &pvm);
            vao.bind();
            ibo.bind();
            glDrawElements(GL_TRIANGLES, indices.len, GL_UNSIGNED_INT, null);

            if(window.get_key_state(GLFW_KEY_ESCAPE)) {
                GHRANTOS_TOOLED_RETURN();
            }

            window.update();
        }
    };
}

#include <ghrantos/ghrantos.h>
#include <ghrantos/window.h>
#include <ghrantos/shader.h>
#include <ghrantos/fs.h>
#include <ghrantos/buffers.h>
#include <ghrantos/image.h>

#include <genmemory.h>

fn void main() {
    @ghrantos_tooling_frame() {
        gen_log(GEN_LOG_LEVEL_DEBUG, GHRANTOS_APP_NAME, "Hello, Genstone!");

        GhrantosWindow_t window = {};
        window.init(640, 480, GHRANTOS_APP_NAME);

        GhrantosVertex_t[*] vertices = {
            {{-0.5, -0.5, 0.0}, {1.0, 1.0, 1.0}, {0.0, 0.0}},
            {{ 0.5, -0.5, 0.0}, {1.0, 1.0, 1.0}, {1.0, 0.0}},
            {{ 0.0,  0.5, 0.0}, {1.0, 1.0, 1.0}, {0.5, 1.0}}
        };

        GhrantosShaderStage_t vertex = {};
        vertex.init("res/vertex.glsl", GL_VERTEX_SHADER);

        GhrantosShaderStage_t fragment = {};
        fragment.init("res/fragment.glsl", GL_FRAGMENT_SHADER);

        GhrantosShaderProgram_t program = {};
        program.init(&vertex, &fragment);
        int uniform_shader = glGetUniformLocation(program.handle, "uniform_shader");

        GhrantosVAO_t vao = {};
        vao.init();
        vao.bind();

        GhrantosVBO_t vbo = {};
        vbo.init(&vertices, $sizeof(vertices), GL_STATIC_DRAW);

        vao.setup_buffer_attribs();

        GhrantosImage_t image = {};
        image.init("res/test.bmp");

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);

        uint texture = 0;
        glGenTextures(1, &texture);
        glBindTexture(GL_TEXTURE_2D, texture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8, (int) image.width, (int) image.height, 0, GL_BGR, GL_UNSIGNED_BYTE, image.data);
        glGenerateMipmap(GL_TEXTURE_2D);

        image.deinit();

        while (!window.should_close()) {
            glClearColor(0.4, 0.4, 0.4, 1.0);
            glClear(GL_COLOR_BUFFER_BIT);

            program.bind();
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, texture);
            glUniform1i(uniform_shader, 0);
            vao.bind();
            glDrawArrays(GL_TRIANGLES, 0, 3);

            if(window.get_key_state(GLFW_KEY_ESCAPE)) {
                GHRANTOS_TOOLED_RETURN();
            }

            window.update();
        }
    };
}

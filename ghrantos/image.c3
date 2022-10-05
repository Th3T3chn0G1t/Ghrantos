#include <ghrantos/ghrantos.h>
#define GHRANTOS_IMAGE_IMPL
#include <ghrantos/image.h>

#include <genmemory.h>

define FILE_t = void;
#include <libbmp.h>

define bmp_error_t = int;
C3_const bmp_error_t BMP_FILE_NOT_OPENED = -4;
C3_const bmp_error_t BMP_HEADER_NOT_INITIALIZED = -3;
C3_const bmp_error_t BMP_INVALID_FILE = -2;
C3_const bmp_error_t BMP_ERROR = -1;
C3_const bmp_error_t BMP_OK = 0;

fn void bmp_error_t.ensure(bmp_error_t error) {
    if(error == BMP_OK) return;

    gen_error_type_t error_type = GEN_ERROR_UNKNOWN;
    char* errname = null;
    switch(error) {
        case BMP_FILE_NOT_OPENED: error_type = GEN_ERROR_BAD_OPERATION;
        case BMP_HEADER_NOT_INITIALIZED: error_type = GEN_ERROR_INVALID_PARAMETER;
        case BMP_INVALID_FILE: error_type = GEN_ERROR_INVALID_PARAMETER;
        case BMP_ERROR: error_type = GEN_ERROR_UNKNOWN;
    }

    gen_error_attach_backtrace_formatted(error_type, $$LINE, "BMP Error %ui: `%t`", error, errname).ensure();
}

fn void GhrantosImage_t.init(GhrantosImage_t* image, char* path) {
    @ghrantos_tooling_frame() {
        bmp_img_t bmp = {};
        bmp_img_read(&bmp, path).ensure();

        image.width = bmp.img_header.biWidth;
        image.height = bmp.img_header.biHeight;

        gen_memory_allocate_zeroed((void**) &image.data, image.width * image.height, bmp_pixel_t.sizeof).ensure();

        for(size_t y = 0; y < image.height; ++y) {
            for(size_t x = 0; x < image.width; ++x) {
                bmp_pixel_t pixel = bmp.img_pixels[image.height - (y + 1)][x];
                ((bmp_pixel_t*) image.data)[x + y * image.width] = pixel;
            }
        }

        bmp_img_free(&bmp);
    };
}

fn void GhrantosImage_t.deinit(GhrantosImage_t* image) {
    @ghrantos_tooling_frame() {
        gen_memory_free((void**) &image.data).ensure();
    };
}


#define GHRANTOS_IMPL
#include <ghrantos/ghrantos.h>

fn void gen_error_t.ensure(gen_error_t* error) {
    if(!error) return;
    gen_error_print(GHRANTOS_APP_NAME, error, GEN_ERROR_SEVERITY_FATAL);
    gen_error_abort();
}

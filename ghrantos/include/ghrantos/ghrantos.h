#pragma once

#include <gencommon.h>
#include <genlog.h>

#define GHRANTOS_APP_NAME "c3-application"
#define GHRANTOS_FATAL_ERRORS true

#define GHRANTOS_TOOLED_RETURN(value) {gen_tooling_pop().ensure(); return value;}

macro @ghrantos_tooling_frame(;@body()) {
    // $assert(0, $$FUNC);
    gen_tooling_push($$FUNC, (void*) GHRANTOS_APP_NAME /* &$eval($$FUNC) */, $$FILE).ensure();
    @body();
    gen_tooling_pop().ensure();
}

#ifndef GHRANTOS_IMPL
extern void gen_error_t.ensure(gen_error_t* error) @extname("ghrantos_C_gen_error_t_ensure");
#endif

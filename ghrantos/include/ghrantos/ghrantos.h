#pragma once

import std::io;
import std::map;
import std::math;
import std::array::list;

#include <gencommon.h>
#include <genlog.h>

#define GHRANTOS_APP_NAME "c3-application"
#define GHRANTOS_FATAL_ERRORS true

#define GHRANTOS_TOOLED_RETURN(value) {gen_tooling_pop().ensure(); return value;}

define GhrantosByteBuffer_t = List<char>;

macro @ghrantos_tooling_frame(;@body()) {
    gen_tooling_push($$FUNC, (void*) &$$FUNCTION, $$FILE).ensure();
    @body();
    gen_tooling_pop().ensure();
}

macro ghrantos_list_reserve(list, type_size, size) {
    usz aligned_size = math::next_power_of_2(size);

    if(!list.capacity) {
        list.entries = malloc(type_size * aligned_size);
    }
    else {
        list.entries = realloc(list.entries, type_size * aligned_size);
    }
    list.capacity = aligned_size;
}

#ifndef GHRANTOS_IMPL
extern void GhrantosByteBuffer_t.reserve(GhrantosByteBuffer_t* buffer, size_t size);
extern void gen_error_t.ensure(gen_error_t* error) @extname("ghrantos_C_gen_error_t_ensure");
#endif

// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

module ghrantos;

import std::array::list;

#include <gencommon.h>
#include <genlog.h>

const char[*] GHRANTOS_APP_NAME = "c3-application";
const usz GHRANTOS_STRING_NO_BOUNDS = usz.max;

define GhrantosByteBuffer_t = List<char>;

macro @ghrantos_tooling_frame(;@body()) {
    gen_tooling_push($$FUNC, (void*) &$$FUNCTION, $$FILE).ensure();
    @body();
    gen_tooling_pop().ensure();
}

fn void C_gen_error_t.ensure(C_gen_error_t* error) {
    if(!error) return;
    gen_error_print(GHRANTOS_APP_NAME, error, GEN_ERROR_SEVERITY_FATAL);
    gen_error_abort();
}

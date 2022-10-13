// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

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

#ifndef GHRANTOS_IMPL
extern void gen_error_t.ensure(gen_error_t* error) @extname("ghrantos_C_gen_error_t_ensure");
#endif

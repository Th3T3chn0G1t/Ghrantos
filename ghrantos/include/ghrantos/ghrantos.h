// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2022 Emily "TTG" Banerjee <prs.ttg+ghrantos@pm.me>

#pragma once

#define GHRANTOS_TOOLED_RETURN(value) {gen_tooling_pop().ensure(); return value;}

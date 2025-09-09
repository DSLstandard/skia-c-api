/*
 * Copyright 2019 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */


#include "skia_capi/sk_types.h"
#include "skia_capi/sk_general.h"

#include "common_include_pch.hpp"

static inline const SkRefCnt* AsRefCnt(const sk_refcnt_t* t) {
    return reinterpret_cast<const SkRefCnt*>(t);
}
static inline const SkNVRefCnt<void*>* AsNVRefCnt(const sk_nvrefcnt_t* t) {
    return reinterpret_cast<const SkNVRefCnt<void*>*>(t);
}

// ref counting

bool sk_refcnt_unique(const sk_refcnt_t* refcnt) {
    return AsRefCnt(refcnt)->unique();
}
void sk_refcnt_safe_ref(sk_refcnt_t* refcnt) {
    SkSafeRef(AsRefCnt(refcnt));
}
void sk_refcnt_safe_unref(sk_refcnt_t* refcnt) {
    SkSafeUnref(AsRefCnt(refcnt));
}

bool sk_nvrefcnt_unique(const sk_nvrefcnt_t* refcnt) {
    return AsNVRefCnt(refcnt)->unique();
}
void sk_nvrefcnt_safe_ref(sk_nvrefcnt_t* refcnt) {
    SkSafeRef(AsNVRefCnt(refcnt));
}
void sk_nvrefcnt_safe_unref(sk_nvrefcnt_t* refcnt) {
    SkSafeUnref(AsNVRefCnt(refcnt));
}

// library information

int sk_version_get_milestone(void) {
    return SK_MILESTONE;
}

int sk_version_get_increment(void) {
    return SK_C_INCREMENT;
}

const char* sk_version_get_string(void) {
    const char* str = SK_TO_STRING(SK_MILESTONE) "." SK_TO_STRING(SK_C_INCREMENT);
    return str;
}

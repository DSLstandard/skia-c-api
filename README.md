# skia-c-api

A Skia (milestone: m129) API for C, and a fork of https://github.com/mono/skia with the following changes:

- Added additional (but very incomplete) C APIs for modules like SkUnicode, SkParagraph, & SkSVG.
- Modified to build an external shared/static C library that interfaces with Skia.

This project was originally a part of https://github.com/DSLstandard/hs-skia,
but it is now unused in hs-skia. To not be wasteful, the project sources have
been extracted to form a standalone Git project for others to use.

To build the shared & static libraries of @skia-c-api@, run:
```console
$ nix develop  # if you have Nix, this pulls in cmake, ninja, clang, and skia (with modules skparagraph, skunicode, & sksvg enabled)
$ mkdir -p build/
$ cd build/
$ cmake -G Ninja ..
$ ninja
$ ls libskia*   # Check outputs
libskia_capi_shared.so  libskia_capi_static.a
```


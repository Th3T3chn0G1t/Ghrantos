# TODO

- Integrate GLFW for build
- Window/GL teardown/deinit
- Write own BMP reader impl
- Change so `window.h` is no longer the source for OpenGL API decl.
- Transparency with a mask color
- Fix `math.h` to use fixed array initializers
- Reduce vertex attributes to neccesary to improve bandwidth usage (i.e. `vec2` for pos over `vec3` + uchar layer, does 
depth test cost perf? Cut vertex colors - do vertex outputs cost perf?)
- Inject method for avoiding double hash on shader uniform cache map
- Integrate Tracy allocation tracking with C3 Allocators

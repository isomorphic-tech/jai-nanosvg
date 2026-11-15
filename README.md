# jai-nanosvg

Jai bindings for [nanosvg](https://github.com/memononen/nanosvg), a small SVG parser and rasterizer.

The headers in `include/` are from nanosvg commit `239e102`. Nanosvg uses a zlib license, which we included at `include/LICENSE.txt`.

## Installation

Copy this folder into your modules folder as `Nanosvg` and `#import "Nanosvg";`.

The library is statically linked.

Prebuilt bindings and the static library are included for Windows x64.
On Linux and macOS, run `jai generate.jai` to get the bindings and static library, but this hasn't been tested yet.

If you don't plan to run `generate.jai` you can delete it and the `include` folder.

## Usage

The API is the same as the C one:

```jai
image := nsvgParseFromFile("logo.svg", "px", 96);
defer nsvgDelete(image);

rast := nsvgCreateRasterizer();
defer nsvgDeleteRasterizer(rast);

w := image.width.(s32);
h := image.height.(s32);
pixels := NewArray(w * h * 4, u8); // RGBA, not premultiplied
nsvgRasterize(rast, image, 0, 0, 1, pixels.data, w, h, w * 4);
```

See `example/example.jai`, which rasterizes the Isomorphic logo and writes it to a PNG:

```
jai example/example.jai
example/example
```

## Generating

```
jai generate.jai
```

This compiles `include/nanosvg.c` into a static library and generates statically linked bindings for the current platform into `bindings/<os>/`. On Windows it needs Visual Studio (Build Tools) installed. On Linux and macOS it uses the system C compiler.

## License

The bindings are MIT (see `LICENSE`). nanosvg itself is zlib (see `include/LICENSE.txt`).

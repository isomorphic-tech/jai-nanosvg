// Parses the isomorphic logo, rasterizes it to RGBA pixels and writes it out as a PNG.
//
//   jai example/example.jai
//   example/example

#import "Basic";
#import "String";
#import "System";
#import "stb_image_write";
#import,file "../module.jai";

SCALE :: 2.0;

main :: () {

    dir := path_strip_filename(get_path_of_running_executable());
    svg_path := path_join(dir, "isomorphic_logo.svg", separator="/",, temp);
    png_path := path_join(dir, "isomorphic_logo.png", separator="/",, temp);

    image := nsvgParseFromFile(temp_c_string(svg_path), "px", 96);
    assert(image != null, "failed to parse %", svg_path);
    defer nsvgDelete(image);

    shape_count := 0;
    shape := image.shapes;
    while shape {
        shape_count += 1;
        shape = shape.next;
    }
    print("parsed %: %x%, % shapes\n", svg_path, image.width, image.height, shape_count);

    w := (image.width  * SCALE).(s32);
    h := (image.height * SCALE).(s32);
    pixels := NewArray(w * h * 4, u8);
    defer array_free(pixels);

    rast := nsvgCreateRasterizer();
    defer nsvgDeleteRasterizer(rast);
    nsvgRasterize(rast, image, 0, 0, SCALE, pixels.data, w, h, w * 4);

    covered := 0;
    for i: 0..w*h-1 {

        if pixels[i*4 + 3] > 0 {
            covered += 1;
        }
    }

    print("rasterized %x% pixels, % have alpha > 0\n", w, h, covered);
    assert(covered > 0, "rasterized image is empty");

    ok := stbi_write_png(temp_c_string(png_path), w, h, 4, pixels.data, w * 4);
    assert(ok != 0, "failed to write %", png_path);
    print("wrote %\n", png_path);
}

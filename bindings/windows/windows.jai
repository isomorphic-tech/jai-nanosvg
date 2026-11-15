//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



/* Example Usage:
// Load SVG
NSVGimage* image;
image = nsvgParseFromFile("test.svg", "px", 96);
printf("size: %f x %f\n", image->width, image->height);
// Use...
for (NSVGshape *shape = image->shapes; shape != NULL; shape = shape->next) {
for (NSVGpath *path = shape->paths; path != NULL; path = path->next) {
for (int i = 0; i < path->npts-1; i += 3) {
float* p = &path->pts[i*2];
drawCubicBez(p[0],p[1], p[2],p[3], p[4],p[5], p[6],p[7]);
}
}
}
// Delete
nsvgDelete(image);
*/
NSVGpaintType :: enum s32 {
    UNDEF           :: -1;
    NONE            :: 0;
    COLOR           :: 1;
    LINEAR_GRADIENT :: 2;
    RADIAL_GRADIENT :: 3;

    NSVG_PAINT_UNDEF           :: UNDEF;
    NSVG_PAINT_NONE            :: NONE;
    NSVG_PAINT_COLOR           :: COLOR;
    NSVG_PAINT_LINEAR_GRADIENT :: LINEAR_GRADIENT;
    NSVG_PAINT_RADIAL_GRADIENT :: RADIAL_GRADIENT;
}

NSVGspreadType :: enum s32 {
    PAD     :: 0;
    REFLECT :: 1;
    REPEAT  :: 2;

    NSVG_SPREAD_PAD     :: PAD;
    NSVG_SPREAD_REFLECT :: REFLECT;
    NSVG_SPREAD_REPEAT  :: REPEAT;
}

NSVGlineJoin :: enum s32 {
    MITER :: 0;
    ROUND :: 1;
    BEVEL :: 2;

    NSVG_JOIN_MITER :: MITER;
    NSVG_JOIN_ROUND :: ROUND;
    NSVG_JOIN_BEVEL :: BEVEL;
}

NSVGlineCap :: enum s32 {
    BUTT   :: 0;
    ROUND  :: 1;
    SQUARE :: 2;

    NSVG_CAP_BUTT   :: BUTT;
    NSVG_CAP_ROUND  :: ROUND;
    NSVG_CAP_SQUARE :: SQUARE;
}

NSVGfillRule :: enum s32 {
    NONZERO :: 0;
    EVENODD :: 1;

    NSVG_FILLRULE_NONZERO :: NONZERO;
    NSVG_FILLRULE_EVENODD :: EVENODD;
}

NSVGflags :: enum s32 {
    NSVG_FLAGS_VISIBLE :: 1;
}

NSVGpaintOrder :: enum s32 {
    FILL    :: 0;
    MARKERS :: 1;
    STROKE  :: 2;

    NSVG_PAINT_FILL    :: FILL;
    NSVG_PAINT_MARKERS :: MARKERS;
    NSVG_PAINT_STROKE  :: STROKE;
}

NSVGgradientStop :: struct {
    color:  u32;
    offset: float;
}

NSVGgradient :: struct {
    xform:  [6] float;
    spread: u8;
    fx:     float;
    fy:     float;
    nstops: s32;
    stops:  [1] NSVGgradientStop;
}

NSVGpaint :: struct {
    type: s8;
    struct {
        gradient: *NSVGgradient; // largest member, moved to the start of the struct/union to support #overlay.

        #overlay (gradient) color: u32;
    }
}

NSVGpath :: struct {
    pts:    *float; // Cubic bezier points: x0,y0, [cpx1,cpx1,cpx2,cpy2,x1,y1], ...
    npts:   s32; // Total number of bezier points.
    closed: u8; // Flag indicating if shapes should be treated as closed.
    bounds: [4] float; // Tight bounding box of the shape [minx,miny,maxx,maxy].
    next:   *NSVGpath; // Pointer to next path, or NULL if last element.
}

NSVGshape :: struct {
    id:               [64] u8; // Optional 'id' attr of the shape or its group
    fill:             NSVGpaint; // Fill paint
    stroke:           NSVGpaint; // Stroke paint
    opacity:          float; // Opacity of the shape.
    strokeWidth:      float; // Stroke width (scaled).
    strokeDashOffset: float; // Stroke dash offset (scaled).
    strokeDashArray:  [8] float; // Stroke dash array (scaled).
    strokeDashCount:  u8; // Number of dash values in dash array.
    strokeLineJoin:   u8; // Stroke join type.
    strokeLineCap:    u8; // Stroke cap type.
    miterLimit:       float; // Miter limit
    fillRule:         u8; // Fill rule, see NSVGfillRule.
    paintOrder:       u8; // Encoded paint order (3×2-bit fields) see NSVGpaintOrder
    flags:            u8; // Logical or of NSVG_FLAGS_* flags
    bounds:           [4] float; // Tight bounding box of the shape [minx,miny,maxx,maxy].
    fillGradient:     [64] u8; // Optional 'id' of fill gradient
    strokeGradient:   [64] u8; // Optional 'id' of stroke gradient
    xform:            [6] float; // Root transformation for fill/stroke gradient
    paths:            *NSVGpath; // Linked list of paths in the image.
    next:             *NSVGshape; // Pointer to next shape, or NULL if last element.
}

NSVGimage :: struct {
    width:  float; // Width of the image.
    height: float; // Height of the image.
    shapes: *NSVGshape; // Linked list of shapes in the image.
}

// Parses SVG file from a file, returns SVG image as paths.
nsvgParseFromFile :: (filename: *u8, units: *u8, dpi: float) -> *NSVGimage #foreign nanosvg;

// Parses SVG file from a null terminated string, returns SVG image as paths.
// Important note: changes the string.
nsvgParse :: (input: *u8, units: *u8, dpi: float) -> *NSVGimage #foreign nanosvg;

// Duplicates a path.
nsvgDuplicatePath :: (p: *NSVGpath) -> *NSVGpath #foreign nanosvg;

// Deletes an image.
nsvgDelete :: (image: *NSVGimage) -> void #foreign nanosvg;

NSVGrasterizer :: struct {}

// Allocated rasterizer context.
nsvgCreateRasterizer :: () -> *NSVGrasterizer #foreign nanosvg;

// Rasterizes SVG image, returns RGBA image (non-premultiplied alpha)
//   r - pointer to rasterizer context
//   image - pointer to image to rasterize
//   tx,ty - image offset (applied after scaling)
//   scale - image scale
//   dst - pointer to destination image data, 4 bytes per pixel (RGBA)
//   w - width of the image to render
//   h - height of the image to render
//   stride - number of bytes per scaleline in the destination buffer
nsvgRasterize :: (r: *NSVGrasterizer, image: *NSVGimage, tx: float, ty: float, scale: float, dst: *u8, w: s32, h: s32, stride: s32) -> void #foreign nanosvg;

// Deletes rasterizer context.
nsvgDeleteRasterizer :: (unknown0: *NSVGrasterizer) -> void #foreign nanosvg;

#scope_file

#import "Basic"; // For assert


#run {
    {
        info := type_info(NSVGgradientStop);
        for info.members {
            if it.name == {
                case "color";
                    assert(it.offset_in_bytes == 0, "NSVGgradientStop.color has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGgradientStop.color has unexpected size % instead of 4", it.type.runtime_size);
                case "offset";
                    assert(it.offset_in_bytes == 4, "NSVGgradientStop.offset has unexpected offset % instead of 4", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGgradientStop.offset has unexpected size % instead of 4", it.type.runtime_size);
            }
        }
        assert(size_of(NSVGgradientStop) == 8, "NSVGgradientStop has size % instead of 8", size_of(NSVGgradientStop));
    }

    {
        info := type_info(NSVGgradient);
        for info.members {
            if it.name == {
                case "xform";
                    assert(it.offset_in_bytes == 0, "NSVGgradient.xform has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 24, "NSVGgradient.xform has unexpected size % instead of 24", it.type.runtime_size);
                case "spread";
                    assert(it.offset_in_bytes == 24, "NSVGgradient.spread has unexpected offset % instead of 24", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGgradient.spread has unexpected size % instead of 1", it.type.runtime_size);
                case "fx";
                    assert(it.offset_in_bytes == 28, "NSVGgradient.fx has unexpected offset % instead of 28", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGgradient.fx has unexpected size % instead of 4", it.type.runtime_size);
                case "fy";
                    assert(it.offset_in_bytes == 32, "NSVGgradient.fy has unexpected offset % instead of 32", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGgradient.fy has unexpected size % instead of 4", it.type.runtime_size);
                case "nstops";
                    assert(it.offset_in_bytes == 36, "NSVGgradient.nstops has unexpected offset % instead of 36", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGgradient.nstops has unexpected size % instead of 4", it.type.runtime_size);
                case "stops";
                    assert(it.offset_in_bytes == 40, "NSVGgradient.stops has unexpected offset % instead of 40", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "NSVGgradient.stops has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(NSVGgradient) == 48, "NSVGgradient has size % instead of 48", size_of(NSVGgradient));
    }

    {
        info := type_info(NSVGpaint);
        for info.members {
            if it.name == {
                case "type";
                    assert(it.offset_in_bytes == 0, "NSVGpaint.type has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGpaint.type has unexpected size % instead of 1", it.type.runtime_size);
            }
        }
        assert(size_of(NSVGpaint) == 16, "NSVGpaint has size % instead of 16", size_of(NSVGpaint));
    }

    {
        info := type_info(NSVGpath);
        for info.members {
            if it.name == {
                case "pts";
                    assert(it.offset_in_bytes == 0, "NSVGpath.pts has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "NSVGpath.pts has unexpected size % instead of 8", it.type.runtime_size);
                case "npts";
                    assert(it.offset_in_bytes == 8, "NSVGpath.npts has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGpath.npts has unexpected size % instead of 4", it.type.runtime_size);
                case "closed";
                    assert(it.offset_in_bytes == 12, "NSVGpath.closed has unexpected offset % instead of 12", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGpath.closed has unexpected size % instead of 1", it.type.runtime_size);
                case "bounds";
                    assert(it.offset_in_bytes == 16, "NSVGpath.bounds has unexpected offset % instead of 16", it.offset_in_bytes);
                    assert(it.type.runtime_size == 16, "NSVGpath.bounds has unexpected size % instead of 16", it.type.runtime_size);
                case "next";
                    assert(it.offset_in_bytes == 32, "NSVGpath.next has unexpected offset % instead of 32", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "NSVGpath.next has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(NSVGpath) == 40, "NSVGpath has size % instead of 40", size_of(NSVGpath));
    }

    {
        info := type_info(NSVGshape);
        for info.members {
            if it.name == {
                case "id";
                    assert(it.offset_in_bytes == 0, "NSVGshape.id has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 64, "NSVGshape.id has unexpected size % instead of 64", it.type.runtime_size);
                case "fill";
                    assert(it.offset_in_bytes == 64, "NSVGshape.fill has unexpected offset % instead of 64", it.offset_in_bytes);
                    assert(it.type.runtime_size == 16, "NSVGshape.fill has unexpected size % instead of 16", it.type.runtime_size);
                case "stroke";
                    assert(it.offset_in_bytes == 80, "NSVGshape.stroke has unexpected offset % instead of 80", it.offset_in_bytes);
                    assert(it.type.runtime_size == 16, "NSVGshape.stroke has unexpected size % instead of 16", it.type.runtime_size);
                case "opacity";
                    assert(it.offset_in_bytes == 96, "NSVGshape.opacity has unexpected offset % instead of 96", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGshape.opacity has unexpected size % instead of 4", it.type.runtime_size);
                case "strokeWidth";
                    assert(it.offset_in_bytes == 100, "NSVGshape.strokeWidth has unexpected offset % instead of 100", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGshape.strokeWidth has unexpected size % instead of 4", it.type.runtime_size);
                case "strokeDashOffset";
                    assert(it.offset_in_bytes == 104, "NSVGshape.strokeDashOffset has unexpected offset % instead of 104", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGshape.strokeDashOffset has unexpected size % instead of 4", it.type.runtime_size);
                case "strokeDashArray";
                    assert(it.offset_in_bytes == 108, "NSVGshape.strokeDashArray has unexpected offset % instead of 108", it.offset_in_bytes);
                    assert(it.type.runtime_size == 32, "NSVGshape.strokeDashArray has unexpected size % instead of 32", it.type.runtime_size);
                case "strokeDashCount";
                    assert(it.offset_in_bytes == 140, "NSVGshape.strokeDashCount has unexpected offset % instead of 140", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGshape.strokeDashCount has unexpected size % instead of 1", it.type.runtime_size);
                case "strokeLineJoin";
                    assert(it.offset_in_bytes == 141, "NSVGshape.strokeLineJoin has unexpected offset % instead of 141", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGshape.strokeLineJoin has unexpected size % instead of 1", it.type.runtime_size);
                case "strokeLineCap";
                    assert(it.offset_in_bytes == 142, "NSVGshape.strokeLineCap has unexpected offset % instead of 142", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGshape.strokeLineCap has unexpected size % instead of 1", it.type.runtime_size);
                case "miterLimit";
                    assert(it.offset_in_bytes == 144, "NSVGshape.miterLimit has unexpected offset % instead of 144", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGshape.miterLimit has unexpected size % instead of 4", it.type.runtime_size);
                case "fillRule";
                    assert(it.offset_in_bytes == 148, "NSVGshape.fillRule has unexpected offset % instead of 148", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGshape.fillRule has unexpected size % instead of 1", it.type.runtime_size);
                case "paintOrder";
                    assert(it.offset_in_bytes == 149, "NSVGshape.paintOrder has unexpected offset % instead of 149", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGshape.paintOrder has unexpected size % instead of 1", it.type.runtime_size);
                case "flags";
                    assert(it.offset_in_bytes == 150, "NSVGshape.flags has unexpected offset % instead of 150", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "NSVGshape.flags has unexpected size % instead of 1", it.type.runtime_size);
                case "bounds";
                    assert(it.offset_in_bytes == 152, "NSVGshape.bounds has unexpected offset % instead of 152", it.offset_in_bytes);
                    assert(it.type.runtime_size == 16, "NSVGshape.bounds has unexpected size % instead of 16", it.type.runtime_size);
                case "fillGradient";
                    assert(it.offset_in_bytes == 168, "NSVGshape.fillGradient has unexpected offset % instead of 168", it.offset_in_bytes);
                    assert(it.type.runtime_size == 64, "NSVGshape.fillGradient has unexpected size % instead of 64", it.type.runtime_size);
                case "strokeGradient";
                    assert(it.offset_in_bytes == 232, "NSVGshape.strokeGradient has unexpected offset % instead of 232", it.offset_in_bytes);
                    assert(it.type.runtime_size == 64, "NSVGshape.strokeGradient has unexpected size % instead of 64", it.type.runtime_size);
                case "xform";
                    assert(it.offset_in_bytes == 296, "NSVGshape.xform has unexpected offset % instead of 296", it.offset_in_bytes);
                    assert(it.type.runtime_size == 24, "NSVGshape.xform has unexpected size % instead of 24", it.type.runtime_size);
                case "paths";
                    assert(it.offset_in_bytes == 320, "NSVGshape.paths has unexpected offset % instead of 320", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "NSVGshape.paths has unexpected size % instead of 8", it.type.runtime_size);
                case "next";
                    assert(it.offset_in_bytes == 328, "NSVGshape.next has unexpected offset % instead of 328", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "NSVGshape.next has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(NSVGshape) == 336, "NSVGshape has size % instead of 336", size_of(NSVGshape));
    }

    {
        info := type_info(NSVGimage);
        for info.members {
            if it.name == {
                case "width";
                    assert(it.offset_in_bytes == 0, "NSVGimage.width has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGimage.width has unexpected size % instead of 4", it.type.runtime_size);
                case "height";
                    assert(it.offset_in_bytes == 4, "NSVGimage.height has unexpected offset % instead of 4", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "NSVGimage.height has unexpected size % instead of 4", it.type.runtime_size);
                case "shapes";
                    assert(it.offset_in_bytes == 8, "NSVGimage.shapes has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "NSVGimage.shapes has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(NSVGimage) == 16, "NSVGimage has size % instead of 16", size_of(NSVGimage));
    }
}

nanosvg :: #library,no_dll "x64/nanosvg";
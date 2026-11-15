#run build();

build :: () {

    set_build_options_dc(.{do_output=false});

    if !build_library() || !generate_bindings() {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

LIB_NAME :: "nanosvg";

#if OS == .WINDOWS {

    #if CPU != .X64
        #assert false "only x64 is supported for windows. You might be able to add support for your CPU though.";

    LIB_DIRECTORY   :: "bindings/windows/x64";
    OUTPUT_FILENAME :: "bindings/windows/windows.jai";
    FOOTER          :: "nanosvg :: #library,no_dll \"x64/nanosvg\";";

} else #if OS == .LINUX {

    LIB_DIRECTORY   :: "bindings/linux";
    OUTPUT_FILENAME :: "bindings/linux/linux.jai";
    FOOTER          :: "nanosvg :: #library,no_dll \"nanosvg\";";

} else #if OS == .MACOS {

    LIB_DIRECTORY   :: "bindings/macos";
    OUTPUT_FILENAME :: "bindings/macos/macos.jai";
    FOOTER          :: "nanosvg :: #library,no_dll \"nanosvg\";";

} else {
    #assert false "this OS is currently unsupported. You might be able to add support for it though!";
}

// nanosvg is header-only, so we compile the implementation (include/nanosvg.c) into a static library.
build_library :: () -> bool {

    make_directory_if_it_does_not_exist(LIB_DIRECTORY, recursive = true);

    extra: [..] string;
    #if OS == .WINDOWS  array_add(*extra, "/wd4244"); // nanosvg mixes float and double a lot.
    else                array_add(*extra, "-fPIC");

    return build_cpp_static_lib(tprint("%/%", LIB_DIRECTORY, LIB_NAME), "include/nanosvg.c", extra = extra);
}

generate_bindings :: () -> bool {

    opts: Generate_Bindings_Options;

    {
        using opts;

        footer = FOOTER;
        generate_library_declarations = false;

        array_add(*library_search_paths, LIB_DIRECTORY);
        array_add(*libraries, .{filename = LIB_NAME});
        array_add(*include_paths, "include");
        array_add(*source_files, "include/nanosvg.h", "include/nanosvgrast.h");

        auto_detect_enum_prefixes = true;
        generate_compile_time_struct_checks = true;
    }

    return generate_bindings(opts, OUTPUT_FILENAME);
}

#scope_file

#import "Basic";
#import "Compiler";
#import "BuildCpp";
#import "Bindings_Generator";
#import "File";

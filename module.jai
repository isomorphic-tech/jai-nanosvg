#if OS == .WINDOWS {
    #load "bindings/windows/windows.jai";
} else #if OS == .LINUX {
    libm :: #system_library,link_always "libm";
    #load "bindings/linux/linux.jai";
} else #if OS == .MACOS {
    #load "bindings/macos/macos.jai";
} else {
    #assert false "nanosvg bindings don't support this OS, yet.";
}

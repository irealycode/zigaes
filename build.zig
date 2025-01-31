const std = @import("std");
const Builder = std.Build;

pub fn build(b: *Builder) void {
    const lib = b.addStaticLibrary(.{
        .name = "zigaes",
        .root_source_file = b.path("src/AES.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    b.installArtifact(lib);
    // lib.install();
}
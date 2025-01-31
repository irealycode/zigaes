const std = @import("std");
const Builder = std.Build;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // const lib = b.addStaticLibrary(.{
    //     .name = "zigaes",
    //     .root_source_file = b.path("src/AES.zig"),
    //     .target = b.standardTargetOptions(.{}),
    //     .optimize = b.standardOptimizeOption(.{}),
    // });

    const dep_opts = .{ .target = target, .optimize = optimize };
    _ = dep_opts;
    _ = b.addModule("zigaes", .{
        .root_source_file = b.path("src/AES.zig")
    });

    // b.installArtifact(lib);
    // lib.install();
}
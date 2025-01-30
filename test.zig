const aes = @import("AES.zig");
const std = @import("std");

pub fn main() !void{
    const pt : []const u8  =  "thisIsPlainTextToTestThisThing10";
    const key : []const u8  = "rhe82kd8hrius9dn";
    const enc = try aes.aesEncrypt(pt,key);
    for(enc) |e|{
        aes.displayOne(e);
    }
    const dec = try aes.aesDecrypt(enc,key);
    std.debug.print("result: {s}\n",.{dec});
}

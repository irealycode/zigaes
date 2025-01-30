const aes = @import("AES.zig");
const std = @import("std");

pub fn main() !void{
    const pt : []const u8  =  "thisIsPlainTextToTestThisThing10";
    const key : []const u8  = "rhe82kd8hrius9dn";
    const enc = try aes.aesEncrypt(pt,key,256);
    for(enc) |e|{
        aes.displayOne(e);
    }
    const s = try aes.asString(enc);
    const r = try aes.asNotString(s);
    const dec = try aes.aesDecrypt(enc,key,256);
    std.debug.print("result: {x}\n",.{dec});
    for(r) |e|{
        aes.displayOne(e);
    }
}

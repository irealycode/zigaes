const aes = @import("AES.zig");


pub fn main() !void{
    const pt : []const u8  =  "thisIsPlainTextToTestThisThing10";
    const key : []const u8  = "rhe82kd8hrius9dn";
    const enc = try aes.aesEncrypt(pt,key);
    for(enc) |e|{
        aes.displayOne(e);
    }
}

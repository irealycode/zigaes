const std = @import("std");

pub fn devideString(data: []const u8) [4][4]u8{
    // const data = "thisisaverylongkeythatdoesnotfit";
    var devidedKey : [4][4]u8 = .{[4]u8{0x00,0x00,0x00,0x00},[4]u8{0x00,0x00,0x00,0x00},[4]u8{0x00,0x00,0x00,0x00},[4]u8{0x00,0x00,0x00,0x00}};
    var y:usize = 0;
    for(0.., data) |i, byte| {
        if ((i % 4)==0) y=0;
        devidedKey[i / 4][y] = byte;
        if (i == 15) break;
        y += 1;
    }

    return devidedKey;
}    


pub fn main() void{
    
}



test "devideString" {
    const key : []const u8 = "verystrongkey101asdasfsfa";
    const data = devideString(key);
    for(data) |bytes| {
        std.debug.print("0x",.{});
        for(bytes) |byte|{
            std.debug.print("{x}", .{byte});
        }
        std.debug.print("\n",.{});
    }
}

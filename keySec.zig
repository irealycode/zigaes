const std = @import("std");

pub fn devideKey(data: []const u8) [4][4]u8{
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

pub fn rotWord(data: [4]u8,cycles: usize) [4]u8{
    var rotatedWord : [4]u8 = data;
    for (0..cycles) |_|{
        const temp : u8 = rotatedWord[0];
        rotatedWord[0] = rotatedWord[1];
        rotatedWord[1] = rotatedWord[2];
        rotatedWord[2] = rotatedWord[3];
        rotatedWord[3] = temp;
    }
    return rotatedWord;
}


pub fn subChar(data: u8) u8{
    const SBox = [256]u8{
        0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
        0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
        0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
        0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
        0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
        0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
        0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
        0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
        0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
        0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
        0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
        0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
        0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
        0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
        0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
        0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
        0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
        0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
        0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
        0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
        0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
        0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
        0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
        0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
        0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
        0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
        0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
        0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
        0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
        0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
        0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
        0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
    };
    const col : u8 = ((data >> 4) << 4);
    const row : u8 = ((data << 4) >> 4);
    return SBox[col + row];
}

pub fn subWord(data: [4]u8) [4]u8{
    var word : [4]u8 = undefined;
    for(0..4) |i|{
        word[i] = subChar(data[i]);
    }
    return word;
}

pub fn subMatrix(data: [4][4]u8) [4][4]u8{
    var r : [4][4]u8 = undefined;
    for(0..4) |i|{
        r[i] = subWord(data[i]);
    }
    return r;
}

pub fn rCon(row: u8) u8{
    // std.debug.print("{d}\n",.{row});
    var r : u16 = 0x01;
    for(1..(row)) |_|{
        r = r * 0x02;
        if (r > 0xff) {
            r = (r ^ 0x11B) % 255;
        }
    }
    return @truncate(r);
}

pub fn xorWordandValue(data : [4]u8,value : u8) [4]u8{
    var r : [4]u8 = undefined;
    for (data,0..) |word, i| {
        r[i] = word ^ value;
    }
    return r;
}

pub fn xorWordToValue(data : [4]u8) u8{
    var r : u8 = data[0];
    for (1..4) |i| {
        r = data[i] ^ r;
    }
    return r;
}

pub fn xorWords(data : [4]u8,second : [4]u8) [4]u8{
    var r : [4]u8 = data;
    for (data,0..) |word, i| {
        r[i] = word ^ second[i];
    }
    return r;
}

pub fn displayKey(data : [44][4]u8) void{
    std.debug.print("expanded key: ",.{});
    for(data,0..) |bytes,i| {
        if (i%4 == 0) std.debug.print("\n",.{});
        for(bytes) |byte|{
            std.debug.print("{x:0>2}", .{byte});
        }
        std.debug.print(" ",.{});
    }
    std.debug.print("\n",.{});
}

pub fn displayMatrix(data : [4][4]u8) void{
    
    for(data) |bytes|{
        for(bytes) |byte|{
            std.debug.print("{x:0>2} ", .{byte});
        }
        std.debug.print("\n", .{});
    }
}

pub fn displayOne(data : [4]u8) void{
    for(data) |byte|{
        std.debug.print("{x:0>2}", .{byte});
    }
    std.debug.print("\n",.{});
}

pub fn assembleWord(data : [4][4]u8) [44][4]u8{
    var full_word : [44][4]u8 = undefined;
    for(0..4) |i|{
        full_word[i] = data[i];
    }
    for(4..44) |i|{
        if((i % 4) == 0){
            full_word[i] = xorWords(xorWords(subWord(rotWord(full_word[i - 1],1)),[4]u8{rCon(@intCast(i / 4)), 0x00, 0x00, 0x00}),full_word[i - 4]);
        }
        else{
            full_word[i] = xorWords(full_word[i - 1],full_word[i - 4]);
        } 
    }
    return full_word;
}

pub fn expandKey(data : []const u8) [44][4]u8{
    return assembleWord(devideKey(data));
}

// 72686538326b6438687269757339646e -> rhe82kd8hrius9dn
pub fn main() void{
    // const key : []const u8 = "1212121212121212";
    
    displayKey(expandKey("rhe82kd8hrius9dn"));
}



test "devideKey" {
    std.debug.print("DevideKey\n", .{});
    const key : []const u8 = "rhe82kd8hrius9dn";
    const data = devideKey(key);
    for(data) |bytes| {
        std.debug.print("0x",.{});
        for(bytes) |byte|{
            std.debug.print("{x}", .{byte});
        }
        std.debug.print("\n",.{});
    }
}


test "rotWord" {
    std.debug.print("RotWord\n", .{});
    const key : []const u8 = "rhe82kd8hrius9dn";
    var devidedKey = devideKey(key);
    devidedKey[0] = rotWord(devidedKey[0],1);
    for(devidedKey) |bytes| {
        std.debug.print("0x",.{});
        for(bytes) |byte|{
            std.debug.print("{x}", .{byte});
        }
        std.debug.print("\n",.{});
    }
}

test "subWord"{
    const t : u8 = 0x4F;
    const key : []const u8 = "rhe82kd8hrius9dn";
    const devidedKey = devideKey(key);
    std.debug.print("SubWord\n", .{});
    std.debug.print("0x{x}\n", .{subChar(t)});
    for(devidedKey[3]) |byte| {
        std.debug.print("{x}",.{byte});
    }
    std.debug.print("\n",.{});
    for(subWord(devidedKey[3])) |byte| {
        std.debug.print("{x:0>2}",.{byte});
    }
    std.debug.print("\n",.{});
}
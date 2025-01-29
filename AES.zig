const std = @import("std");
const ks = @import("keySec.zig");




fn displayWord(data : [][16]u8) void{
    for(data) |bytes| {
        for(bytes,0..) |byte,y|{
            if (y%4 == 0) std.debug.print(" ",.{});
            std.debug.print("{x:0>2}", .{byte});
            
        }
        std.debug.print("\n",.{});
    }
}

fn displayOne(data : [16]u8) void{
    for(data) |byte|{
        std.debug.print("{x:0>2}", .{byte});
    }
    std.debug.print("\n",.{});
}


fn devideText(data : []const u8) ![][16]u8{
    var l : usize = (data.len/16);
    if (data.len % 16 != 0) l +=1;
    const allocc = std.heap.page_allocator;
    var devided = try allocc.alloc([16]u8,l);
    var m : usize = 0;
    for(0..l) |i|{
        var row : [16]u8 = undefined;
        for(0..16) |x|{
            if(m < data.len) row[x] = data[m]
            else row[x] = 0;
            m += 1;
        }
        devided[i] = row;
    }
    return devided;
}

fn matixConvert(data : [16]u8) [4][4]u8{
    var r : [4][4]u8 = undefined;
    var l : usize = 0;
    for (0..4) |i|{
        for(0..4) |y|{
            r[i][y] = data[l];
            l += 1;
        }
    }
    return r;
}

fn getKeyByRow(data : [44][4]u8,row : usize) [4][4]u8{ // row 1 -> 11
    var r : [4][4]u8 = undefined;
    for (row*4..(row*4 + 4),0..) |i,y|{
        r[y] = data[i];
    }
    return r;
}

fn xorMatrix(data : [4][4]u8,second : [4][4]u8) [4][4]u8{
    var xored : [4][4]u8 = undefined;
    for(0..4) |i|{
        for(0..4) |y|{
            xored[i][y] = data[i][y] ^ second[i][y];
        }
    }
    return xored;
}

fn addRoundKey(wordByte : [16]u8,key : [44][4]u8,round:usize) [4][4]u8{
    return xorMatrix(matixConvert(wordByte),getKeyByRow(key,round));
}



pub fn main() !void {
    const pt : []const u8  = "1212121212121212121212121212121212";
    const key : []const u8  = "rhe82kd8hrius9dn";
    const expandedKey =  ks.expandKey(key);
    const devidedText = try devideText(pt);
    // displayWord(dw);
    ks.displayMatrix(addRoundKey(devidedText[0],expandedKey,0));
    // ks.displayMatrix(getKeyByRow(expandedKey,0));

}
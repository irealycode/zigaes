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
        std.debug.print("{x:0>2} ", .{byte});
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

fn matixDeConvert(data : [4][4]u8) [16]u8{
    var r : [16]u8 = undefined;
    var l : usize = 0;
    for (0..4) |i|{
        for(0..4) |y|{
            r[l] = data[i][y];
            l += 1;
        }
    }
    return r;
}

fn getKeyByRow(data : [44][4]u8,row : usize) [4][4]u8{ // row 0 -> 10
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

fn addRoundKey(wordByte : [4][4]u8,key : [44][4]u8,round:usize) [4][4]u8{ // round 0 -> 10
    return xorMatrix(wordByte,getKeyByRow(key,round));
}

fn gMul(data : u8,g : u8) u8{
    if(g == 0x02){
        var mul : u16 = @as(u16,data) << 1;
        if (mul >= 0x100) mul = (mul ^ 0x1b) & 0xff;
        return @truncate(mul);
    }else if(g == 0x01) return data
    else {
        return gMul(data,0x02) ^ data;
    }
}


fn mixColumns(data : [4][4]u8) [4][4]u8{
    
    var r : [4][4]u8 = undefined;
    for(0..4) |i|{
        r[0][i] = gMul(data[i][0], 0x02) ^ gMul(data[i][1], 0x03) ^ gMul(data[i][2], 0x01) ^ gMul(data[i][3], 0x01);
        r[1][i] = gMul(data[i][0], 0x01) ^ gMul(data[i][1], 0x02) ^ gMul(data[i][2], 0x03) ^ gMul(data[i][3], 0x01);
        r[2][i] = gMul(data[i][0], 0x01) ^ gMul(data[i][1], 0x01) ^ gMul(data[i][2], 0x02) ^ gMul(data[i][3], 0x03);
        r[3][i] = gMul(data[i][0], 0x03) ^ gMul(data[i][1], 0x01) ^ gMul(data[i][2], 0x01) ^ gMul(data[i][3], 0x02);
    }
    return transMatrix(r);
}

fn transMatrix(data: [4][4]u8) [4][4]u8{
    var r : [4][4]u8 = undefined;
    for(0..4) |i|{
        for(0..4) |y|{
            r[i][y] = data[y][i];
        }
    }
    return r;
}

fn shiftRows(data: [4][4]u8) [4][4]u8{
    var r : [4][4]u8 = transMatrix(data);
    for(0..4) |y|{
        r[y] = ks.rotWord(r[y],y);
    }
    return transMatrix(r);
}

fn rounds(roundedText : [4][4]u8,key : [44][4]u8) [4][4]u8{
    var r : [4][4]u8 = roundedText;
    for(1..10) |i| {
        r = ks.subMatrix(r);
        r = shiftRows(r);
        r = mixColumns(r);
        r = addRoundKey(r,key,i);
        // std.debug.print("round {d}:\n",.{i});
        // ks.displayMatrix(r);
    }
    return r;
}

fn finalRound(roundedText : [4][4]u8,key : [44][4]u8) [4][4]u8{
    var r : [4][4]u8 = roundedText;
    r = ks.subMatrix(r);
    r = shiftRows(r);
    r = addRoundKey(r,key,10);
    // std.debug.print("round {d}:\n",.{10});
    // ks.displayMatrix(r);
    return r;
}




pub fn aesEncrypt(pt : []const u8,key : []const u8) ![][16]u8{
    const allocc = std.heap.page_allocator;
    const expandedKey =  ks.expandKey(key);
    const devidedText = try devideText(pt);
    var encrypted = try allocc.alloc([16]u8,devidedText.len);
    for(devidedText,0..) |text,i|{
        const rk = addRoundKey(matixConvert(text),expandedKey,0);
        const mainRounds = rounds(rk,expandedKey);
        encrypted[i] = matixDeConvert(finalRound(mainRounds,expandedKey));
    }
    return encrypted;
}

pub fn main() !void {
    const pt : []const u8  =  "thisIsPlainTextToTestThisThing10";
    const key : []const u8  = "rhe82kd8hrius9dn";
    const enc = try aesEncrypt(pt,key);
    for(enc) |e|{
        displayOne(e);
    }
    // ks.displayMatrix(getKeyByRow(expandedKey,0));
}
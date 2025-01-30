# AES Encryption Algorithm in Zig

This project aims to implement the AES (Advanced Encryption Standard) encryption algorithm from scratch, along with all the underlying algorithms it uses. The implementation is written in **Zig**, a programming language known for its performance, safety, and simplicity.

## Project Overview

The goal of this project is to:

- Recreate the AES encryption algorithm from the ground up.
- Implement all associated cryptographic algorithms in Zig.
- Ensure clarity, performance, and correctness in the codebase.

## Features

- **AES Encryption Algorithm**: Full implementation of the core encryption and decryption algorithm.
- **Sub-Algorithms**: Includes all algorithms and utilities needed for the EAS encryption (e.g., key scheduling, side-ways shifting, etc.).
- **Written in Zig**: Utilizing the Zig programming language to ensure efficient and reliable cryptographic operations.

## Present day

- **AES-128** ✔
- **AES-192** ✔ _but with 16-bits key repetition_
- **AES-256** ✔ _but with 16-bits key repetition_

## Tests
### Encryption
```zig
const aes = @import("AES.zig");
const pt : []const u8  =  "thisIsPlainTextToTestThisThing10";
const key : []const u8  = "rhe82kd8hrius9dn";
const enc = try aes.aesEncrypt(pt,key,128); // -> ![][16]u8
const str = try aes.asString(enc); // -> ![]u8
```
**returns**
```hex
HEX
89 1f 58 07 c2 48 36 7c c9 b8 1f 92 3c 22 25 5a 
59 1f 67 3b 73 78 75 50 b1 8d 2d 91 0f c2 bc f3
```
### Decryption

```zig
const aes = @import("AES.zig");
const pt : []const u8  =  "thisIsPlainTextToTestThisThing10";
const key : []const u8  = "rhe82kd8hrius9dn";
const enc = try aes.aesEncrypt(pt,key,256); 
const dec = try aes.aesDecrypt(enc,key,256); // -> ![]u8
```
**returns**
```
STRING
"thisIsPlainTextToTestThisThing10"
```
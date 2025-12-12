const std = @import("std");
const mem = std.mem;
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

const input = @embedFile("input.txt");
// const input =
//     \\.......S.......
//     \\...............
//     \\.......^.......
//     \\...............
//     \\......^.^......
//     \\...............
//     \\.....^.^.^.....
//     \\...............
//     \\....^.^...^....
//     \\...............
//     \\...^.^...^.^...
//     \\...............
//     \\..^...^.....^..
//     \\...............
//     \\.^.^.^.^.^...^.
//     \\...............
// ;

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, input, '\n');
        var curr = try alloc.alloc(u64, lines[0].len);
        for (curr) |*c| c.* = 0;
        for (lines[0], 0..) |l, i| {
            if (l == 'S') curr[i] = 1;
        }

        var p: u64 = 0;
        for (lines[1..]) |i| {
            for (0..curr.len) |col| {
                if (curr[col] > 0 and i[col] == '^') {
                    p += 1;
                    curr[col - 1] += curr[col];
                    curr[col + 1] += curr[col];
                    curr[col] = 0;
                }
            }
        }
        return p;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, input, '\n');
        var curr = try alloc.alloc(u64, lines[0].len);
        for (curr) |*c| c.* = 0;
        for (lines[0], 0..) |l, i| {
            if (l == 'S') curr[i] = 1;
        }

        var p: u64 = 1;
        for (lines[1..]) |i| {
            for (0..curr.len) |col| {
                if (curr[col] > 0 and i[col] == '^') {
                    p += curr[col];
                    curr[col - 1] += curr[col];
                    curr[col + 1] += curr[col];
                    curr[col] = 0;
                }
            }
        }
        return p;
    }
};

const std = @import("std");
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

const input = @embedFile("input.txt");

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        _ = alloc;
        return 100000;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        _ = alloc;
        return 0;
    }
};

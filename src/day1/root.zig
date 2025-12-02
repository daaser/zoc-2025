const std = @import("std");
const util = @import("../util.zig");
const Allocator = std.mem.Allocator;
const input = @embedFile("input.txt");
// const input = "L680\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82";

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        var password: u64 = 0;
        const lines = try util.splitByte(alloc, input, '\n');
        var dialPos: i64 = 50;
        for (lines) |line| {
            const dir = line[0];
            var rotation = try std.fmt.parseInt(i64, line[1..], 10);
            if (dir == 'L') {
                rotation = -rotation;
            }
            dialPos = @mod(dialPos + rotation, 100);
            if (dialPos == 0) {
                password += 1;
            }
        }
        return password;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        var password: u64 = 0;
        const lines = try util.splitByte(alloc, input, '\n');
        var dialPos: i64 = 50;
        for (lines) |line| {
            const dir = line[0];
            var rotation = try std.fmt.parseInt(i64, line[1..], 10);
            if (dir == 'L') {
                rotation = -rotation;
            }

            const newPos = dialPos + rotation;

            const zeroHits = @divTrunc(newPos, 100);

            password += @abs(zeroHits);
            if (newPos <= 0 and dialPos != 0) {
                password += 1;
            }

            dialPos = @mod(newPos, 100);
        }
        return password;
    }
};

const std = @import("std");
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

const input = @embedFile("input.txt");

pub fn isRepeatedTwice(n: usize) bool {
    if (n == 0) {
        return false;
    }
    const ds = util.digits(n);
    const k = ds / 2;
    const base = std.math.pow(usize, 10, k);
    const hi = n / base;
    const lo = n % base;
    return hi == lo;
}

pub fn isRepeatedAtLeastTwice(n: usize) bool {
    const ds = util.digits(n);
    inline for (1..6) |pattern_len| {
        if (ds % pattern_len == 0) {
            const pattern_count: u8 = @intCast(@divExact(ds, pattern_len));
            if (pattern_count > 1) {
                const pattern = util.slice(n, 0, @intCast(pattern_len), ds);
                if (matchesPattern(
                    n,
                    ds,
                    pattern,
                    pattern_len,
                    pattern_count,
                )) return true;
            }
        }
    }
    return false;
}

pub fn matchesPattern(n: u64, ds: u8, pattern: u64, pattern_len: u8, pattern_count: u8) bool {
    for (1..pattern_count) |pi| {
        const target = util.slice(
            n,
            @intCast(pi * pattern_len),
            @intCast((pi + 1) * pattern_len),
            ds,
        );
        if (pattern != target) return false;
    }
    return true;
}

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        var invalidTotal: u64 = 0;
        const ranges = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), ',');
        for (ranges) |range| {
            const splitRange = try util.splitByte(alloc, range, '-');
            const start = try std.fmt.parseInt(u64, splitRange[0], 10);
            const end = try std.fmt.parseInt(u64, splitRange[1], 10);
            for (start..end + 1) |i| {
                if (isRepeatedTwice(i)) invalidTotal += @as(u64, i);
            }
        }
        return invalidTotal;
    }

    // 45283684555
    pub fn partTwo(alloc: Allocator) !u64 {
        var invalidTotal: u64 = 0;
        const ranges = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), ',');
        for (ranges) |range| {
            const splitRange = try util.splitByte(alloc, range, '-');
            const start = try std.fmt.parseInt(u64, splitRange[0], 10);
            const end = try std.fmt.parseInt(u64, splitRange[1], 10);
            for (start..end + 1) |i| {
                // invalidTotal += i;
                if (isRepeatedAtLeastTwice(i)) {
                    invalidTotal += @as(u64, i);
                }
            }
        }
        return invalidTotal;
    }
};

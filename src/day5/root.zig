const std = @import("std");
const mem = std.mem;
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

const input = @embedFile("input.txt");
// const input =
//     \\3-5
//     \\10-14
//     \\16-20
//     \\12-18
//     \\
//     \\1
//     \\5
//     \\8
//     \\11
//     \\17
//     \\32
// ;

fn Range(comptime T: type) type {
    return struct {
        const Self = @This();
        start: T = 0,
        end: T = 0,

        fn hasNumber(self: Self, number: T) bool {
            if (number >= self.start and number <= self.end) {
                return true;
            }
            return false;
        }

        pub fn init(start: T, end: T) Self {
            return .{
                .start = start,
                .end = end,
            };
        }

        pub fn total(self: Self) u64 {
            return self.end - self.start + 1;
        }
    };
}

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        var lines = mem.splitScalar(u8, std.mem.trim(u8, input, "\n"), '\n');
        var ranges: std.array_list.Aligned(Range(u64), null) = .empty;

        while (lines.next()) |line| {
            if (line.len == 0) break;
            const splitRange = try util.splitByte(alloc, line, '-');
            const start = try std.fmt.parseInt(u64, splitRange[0], 10);
            const end = try std.fmt.parseInt(u64, splitRange[1], 10);
            try ranges.append(alloc, Range(u64).init(start, end));
        }

        var totalFresh: u64 = 0;
        while (lines.next()) |line| {
            const id = try std.fmt.parseInt(u64, line, 10);
            for (ranges.items) |range| {
                if (range.hasNumber(id)) {
                    totalFresh += 1;
                    break;
                }
            }
        }
        return totalFresh;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        var lines = mem.splitScalar(u8, std.mem.trim(u8, input, "\n"), '\n');
        var ranges: std.array_list.Aligned(Range(u64), null) = .empty;

        while (lines.next()) |line| {
            if (line.len == 0) break;
            const splitRange = try util.splitByte(alloc, line, '-');
            const start = try std.fmt.parseInt(u64, splitRange[0], 10);
            const end = try std.fmt.parseInt(u64, splitRange[1], 10);
            try ranges.append(alloc, Range(u64).init(start, end));
        }

        std.mem.sort(Range(u64), ranges.items, {}, comptime asc_range);
        var newRanges: std.array_list.Aligned(Range(u64), null) = .empty;
        try newRanges.append(alloc, ranges.items[0]);
        for (1..ranges.items.len) |idx| {
            const current = ranges.items[idx];
            const j = newRanges.items.len - 1;
            if (current.start >= newRanges.items[j].start and current.start <= newRanges.items[j].end) {
                newRanges.items[j].end = @max(current.end, newRanges.items[j].end);
            } else {
                try newRanges.append(alloc, current);
            }
        }

        var totalFresh: u64 = 0;
        for (newRanges.items) |range| {
            totalFresh += range.total();
        }
        return totalFresh;
    }
};

pub fn asc_range(_: void, a: Range(u64), b: Range(u64)) bool {
    return a.start < b.start;
}

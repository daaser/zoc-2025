const std = @import("std");
const mem = std.mem;
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

// const input = @embedFile("input.txt");
const input =
    \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    \\[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    \\[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
;

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');
        for (lines) |line| {
            const lightIdx = mem.indexOf(u8, line, "]").?;
            const joltIdx = mem.indexOf(u8, line, "{").?;
            const lightDiagram = mem.trim(u8, line[0 .. lightIdx + 1], " ");
            const schematics = mem.trim(u8, line[lightIdx + 1 .. joltIdx], " ");
            std.debug.print("Light Diagram: {s}\n", .{lightDiagram});
            std.debug.print("Schematics: {s}\n", .{schematics});
        }
        return 100000;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        _ = alloc;
        return 0;
    }
};

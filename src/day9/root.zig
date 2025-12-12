const std = @import("std");
const mem = std.mem;
const math = std.math;
const parseInt = std.fmt.parseInt;
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

// const input = @embedFile("input.txt");
const input =
    \\7,1
    \\11,1
    \\11,7
    \\9,7
    \\9,5
    \\2,5
    \\2,3
    \\7,3
;

const Coord = struct {
    x: isize,
    y: isize,

    pub fn format(self: Coord, w: *std.io.Writer) std.io.Writer.Error!void {
        return try w.print("({d},{d})", .{ self.x, self.y });
    }
};

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, mem.trim(u8, input, "\n"), '\n');

        var coords = try alloc.alloc(Coord, lines.len);
        for (lines, 0..) |line, idx| {
            var it = mem.splitScalar(u8, line, ',');
            coords[idx] = Coord{
                .x = try parseInt(isize, it.next().?, 10),
                .y = try parseInt(isize, it.next().?, 10),
            };
        }

        var largest: u64 = 0;
        for (coords) |c1| {
            for (coords) |c2| {
                const area = @as(u64, @intCast(
                    @abs(c1.x - c2.x + 1) * @abs(c1.y - c2.y + 1),
                ));
                largest = @max(largest, area);
            }
        }

        return largest;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, mem.trim(u8, input, "\n"), '\n');

        var coords = try alloc.alloc(Coord, lines.len);
        for (lines, 0..) |line, idx| {
            var it = mem.splitScalar(u8, line, ',');
            coords[idx] = Coord{
                .x = try parseInt(isize, it.next().?, 10),
                .y = try parseInt(isize, it.next().?, 10),
            };
        }

        for (coords[1..], 1..) |c2, idx| {
            const c1 = coords[idx - 1];
            const side = @as(u64, @intCast(
                @abs(c1.x - c2.x + 1) * @abs(c1.y - c2.y + 1),
            ));
            std.debug.print("dist from {f} to {f} -> {d}\n", .{ c1, c2, side });
        }

        const largest: u64 = 0;
        // for (coords) |c1| {
        //     for (coords) |c2| {
        //         var contained = true;
        //         for (coords) |c3| {
        //             if (c3.x >= c1.x and c3.x <= c2.x and
        //                 c3.y >= c1.y and c3.y <= c2.y)
        //             {
        //                 contained = false;
        //                 break;
        //             }
        //         }
        //         if (contained) {
        //             const area = @as(u64, @intCast(
        //                 @abs(c1.x - c2.x + 1) * @abs(c1.y - c2.y + 1),
        //             ));
        //             largest = @max(largest, area);
        //         }
        //     }
        // }

        return largest;
    }
};

pub fn coordSort(_: void, a: Coord, b: Coord) bool {
    return a.x < b.x or (a.x == b.x and a.y < b.y);
}

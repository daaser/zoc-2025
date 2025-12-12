const std = @import("std");
const math = std.math;
const parseInt = std.fmt.parseInt;
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

// const input = @embedFile("input.txt");
const input =
    \\162,817,812
    \\57,618,57
    \\906,360,560
    \\592,479,940
    \\352,342,300
    \\466,668,158
    \\542,29,236
    \\431,825,988
    \\739,650,466
    \\52,470,668
    \\216,146,977
    \\819,987,18
    \\117,168,530
    \\805,96,715
    \\346,949,466
    \\970,615,88
    \\941,993,340
    \\862,61,35
    \\984,92,344
    \\425,690,689
;

const Point = struct {
    x: i64,
    y: i64,
    z: i64,
    closest: ?*Point,

    pub fn init() Point {
        return Point{
            .x = 0,
            .y = 0,
            .z = 0,
            .closest = null,
        };
    }

    pub fn from_str(s: []const u8) !Point {
        var it = std.mem.splitScalar(u8, s, ',');
        return Point{
            .x = try parseInt(i64, it.next().?, 10),
            .y = try parseInt(i64, it.next().?, 10),
            .z = try parseInt(i64, it.next().?, 10),
            .closest = null,
        };
    }

    pub fn format(self: Point, w: *std.io.Writer) std.io.Writer.Error!void {
        try w.print("({d},{d},{d})", .{ self.x, self.y, self.z });
    }

    pub fn dist_euclid(p: *const Point, q: *const Point) f64 {
        return @sqrt(
            math.pow(f64, @floatFromInt(@abs(p.x - q.x)), 2) +
                math.pow(f64, @floatFromInt(@abs(p.y - q.y)), 2) +
                math.pow(f64, @floatFromInt(@abs(p.z - q.z)), 2),
        );
    }
};

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        // const p = Point{ .x = 162, .y = 817, .z = 812 };
        // const q = Point{ .x = 425, .y = 690, .z = 689 };
        // std.debug.print("d(p, q) = {any}\n", .{dist_euclid(&p, &q)});

        const lines = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');
        var boxes = try alloc.alloc(Point, lines.len);
        for (lines, 0..) |line, idx| {
            boxes[idx] = try Point.from_str(line);
        }
        for (boxes, 0..) |*box1, idx| {
            var min = math.floatMax(f64);
            var minBox: ?*Point = null;
            for (boxes, 0..) |*box2, jdx| {
                if (idx == jdx) continue;
                const dist = box1.dist_euclid(box2);
                if (dist < min) {
                    min = dist;
                    minBox = box2;
                }
            }
            // std.debug.print("closest to {f} is {f}\n", .{ box1, minBox orelse &Point.init() });
        }
        return 100000;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        _ = alloc;
        return 0;
    }
};

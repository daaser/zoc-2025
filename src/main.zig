const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

pub fn printBox(alloc: Allocator, comptime name: []const u8, comptime T: type) !void {
    if (std.mem.eql(u8, name, "DAY 12")) {
        print("┏━━━━ {s: <6} ━━━━━━┓\n┃{d:<18}┃\n┃{d:<18}┃\n", .{
            name,
            try T.Day.partOne(alloc),
            try T.Day.partTwo(alloc),
        });
        print("┗━━━━━━━━━━━━━━━━━━┛\n", .{});
    } else {
        print("┏━━━━ {s: <6} ━━━━━━┓\n┃{d:<18}┃\n┃{d:<18}┃\n", .{
            name,
            try T.Day.partOne(alloc),
            try T.Day.partTwo(alloc),
        });
        print("┗━━━━━━━━━━━━━━━━━━┛\n\n", .{});
    }
}

pub fn main() !void {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    errdefer aa.deinit();
    const alloc = aa.allocator();

    try printBox(alloc, "DAY 1", @import("day1/root.zig"));
    try printBox(alloc, "DAY 2", @import("day2/root.zig"));
    try printBox(alloc, "DAY 3", @import("day3/root.zig"));
    try printBox(alloc, "DAY 4", @import("day4/root.zig"));
}

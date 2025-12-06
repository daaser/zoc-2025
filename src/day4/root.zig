const std = @import("std");
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

const input = @embedFile("input.txt");
// const input =
//     \\..@@.@@@@.
//     \\@@@.@.@.@@
//     \\@@@@@.@.@@
//     \\@.@@@@..@.
//     \\@@.@@@@.@@
//     \\.@@@@@@@.@
//     \\.@.@.@.@@@
//     \\@.@@@.@@@@
//     \\.@@@@@@@@.
//     \\@.@.@@@.@.
// ;

const Cell = enum { roll, empty, accessible };

const Dir = struct {
    x: isize,
    y: isize,
};

const dirs = [_]Dir{
    Dir{ .x = 0, .y = 1 },
    Dir{ .x = 1, .y = 1 },
    Dir{ .x = 1, .y = 0 },
    Dir{ .x = 1, .y = -1 },
    Dir{ .x = 0, .y = -1 },
    Dir{ .x = -1, .y = -1 },
    Dir{ .x = -1, .y = 0 },
    Dir{ .x = -1, .y = 1 },
};

fn countAccessible(grid: [][]Cell) u64 {
    var totalAccessible: u64 = 0;
    for (grid, 0..) |row, y| {
        for (row, 0..) |*cell, x| {
            switch (cell.*) {
                Cell.accessible, Cell.empty => continue,
                else => {},
            }

            var numRolls: u64 = 0;
            for (dirs) |dir| {
                const x_: usize = x +% @as(usize, @bitCast(@as(isize, dir.x)));
                const y_: usize = y +% @as(usize, @bitCast(@as(isize, dir.y)));

                if (x_ > grid[0].len - 1 or y_ > grid.len - 1) continue;

                if (grid[y_][x_] == Cell.roll or grid[y_][x_] == Cell.accessible)
                    numRolls += 1;
            }
            if (numRolls < 4) {
                cell.* = Cell.accessible;
                totalAccessible += 1;
            }
        }
    }
    return totalAccessible;
}

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        const rows = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');

        var grid: [][]Cell = undefined;
        grid = try alloc.alloc([]Cell, rows.len);
        for (rows, 0..) |row, idx| {
            grid[idx] = try alloc.alloc(Cell, row.len);
            for (grid[idx], row) |*c, r| {
                if (r == '@') {
                    c.* = Cell.roll;
                } else {
                    c.* = Cell.empty;
                }
            }
        }

        return countAccessible(grid);
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        const rows = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');

        var grid: [][]Cell = undefined;
        grid = try alloc.alloc([]Cell, rows.len);
        for (rows, 0..) |row, idx| {
            grid[idx] = try alloc.alloc(Cell, row.len);
            for (grid[idx], row) |*c, r| {
                if (r == '@') {
                    c.* = Cell.roll;
                } else {
                    c.* = Cell.empty;
                }
            }
        }
        var totalAccessible: u64 = 0;
        while (true) {
            const cc = countAccessible(grid);
            if (cc == 0) break;
            totalAccessible += cc;
            for (grid) |row| {
                for (row) |*cell| {
                    if (cell.* == Cell.accessible) cell.* = Cell.empty;
                }
            }
        }
        return totalAccessible;
    }
};

fn printGrid(grid: [][]Cell) void {
    for (grid) |row| {
        for (row) |cell| {
            std.debug.print("{s}", .{switch (cell) {
                Cell.empty => ".",
                Cell.roll => "@",
                Cell.accessible => "x",
            }});
        }
        std.debug.print("\n", .{});
    }
}

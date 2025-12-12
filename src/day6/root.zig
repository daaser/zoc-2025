const std = @import("std");
const mem = std.mem;
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

// const input = @embedFile("input.txt");
const input =
    \\123 328  51 64
    \\ 45 64  387 23
    \\  6 98  215 314
    \\*   +   *   +
;
// const input =
//     \\64
//     \\23
//     \\314
//     \\+
// ;

pub const Day = struct {
    // 5060053676136
    pub fn partOne(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');
        var rows: std.array_list.Aligned([]u64, null) = .empty;
        for (lines[0 .. lines.len - 1]) |line| {
            const row = try util.splitByte(alloc, mem.trim(u8, line, "\n"), ' ');
            const nums = try alloc.alloc(u64, row.len);
            for (row, nums) |num, *numRef| {
                numRef.* = try std.fmt.parseInt(u64, num, 10);
            }
            try rows.append(alloc, nums);
        }

        var grandTotal: u64 = 0;
        for (lines[lines.len - 1 ..]) |line| {
            const opRow = try util.splitByte(alloc, mem.trim(u8, line, "\n"), ' ');
            for (opRow, 0..) |op, idx| {
                const total = blk: switch (op[0]) {
                    '*' => {
                        var runningTotal: u64 = 1;
                        for (rows.items) |row| {
                            runningTotal *= row[idx];
                        }
                        break :blk runningTotal;
                    },
                    '+' => {
                        var runningTotal: u64 = 0;
                        for (rows.items) |row| {
                            runningTotal += row[idx];
                        }
                        break :blk runningTotal;
                    },
                    else => @panic("unreachable"),
                };
                grandTotal += total;
            }
        }
        return grandTotal;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');
        var rows: std.array_list.Aligned([]u64, null) = .empty;
        for (lines[0 .. lines.len - 1]) |line| {
            const row = try util.splitByte(alloc, mem.trim(u8, line, "\n"), ' ');
            const nums = try alloc.alloc(u64, row.len);
            var idx: usize = row.len - 1;
            var numIdx: usize = 0;
            while (idx < row.len) : (idx -%= 1) {
                const n = try std.fmt.parseInt(u64, row[idx], 10);
                const ds = util.digits(n);
                nums[numIdx] = n * util.powers[5 - ds];
                numIdx += 1;
            }
            try rows.append(alloc, nums);
        }
        // std.debug.print("{any}\n", .{rows});

        // var jdx: usize = 0;
        // while (jdx < rows.items[0].len) : (jdx += 1) {
        //     // var total: u64 = 0;
        //     var pow: u8 = 5;
        //     while (pow > 0) : (pow -= 1) {
        //         var idx: usize = 0;
        //         // var newNum: u64 = 0;
        //         var numStack: std.array_list.Aligned(u64, null) = .empty;
        //         while (idx < rows.items.len) : (idx += 1) {
        //             const x = rows.items[idx][jdx];
        //             const ds = util.digits(x);
        //             const n = util.slice(x, pow - 1, pow, ds);
        //             std.debug.print("x -> {d}   pow -> {d:<5}   digit -> {d}\n", .{ x, util.powers[pow - 1], n });
        //             try numStack.append(alloc, n);
        //         }
        //         std.debug.print("numStack -> {any}\n", .{numStack});
        //         var newNum: u64 = 0;
        //         var p: u64 = numStack.items.len;
        //         for (numStack.items) |n| {
        //             newNum += util.powers[p - 1] * n;
        //             p -= 1;
        //         }
        //         std.debug.print("newNum -> {d}\n\n", .{newNum});
        //     }
        //     std.debug.print("\n", .{});
        // }

        // var idx: usize = 0;
        // while (idx < rows.items.len) : (idx += 1) {
        //     const row = rows.items[idx];
        //     for (row, 0..) |_, jdx| {
        //         std.debug.print("{d} ", .{rows.items[idx][jdx]});
        //     }
        //     std.debug.print("\n", .{});
        // }
        return 0;
    }
};

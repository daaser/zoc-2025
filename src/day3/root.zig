const std = @import("std");
const Allocator = std.mem.Allocator;

const util = @import("../util.zig");

const input = @embedFile("input.txt");
// const input =
//     \\987654321111111
//     \\811111111111119
//     \\234234234234278
//     \\818181911112111
// ;

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        var totalJoltage: u64 = 0;
        const banks = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');
        for (banks) |bank| {
            var max: u64 = 0;
            for (bank, 1..) |battery1, idx1| {
                const joltage1 = battery1 - '0';
                for (bank[idx1..]) |battery2| {
                    const joltage2 = battery2 - '0';
                    const potentialTotal = (joltage1 * 10) + joltage2;
                    max = @max(max, potentialTotal);
                }
            }
            totalJoltage += max;
        }
        return totalJoltage;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        const banks = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');
        var max: u64 = 0;
        for (banks) |bank| {
            var maxList = std.array_list.Managed(u8).init(alloc);
            defer maxList.deinit();
            try maxList.ensureTotalCapacityPrecise(12);

            for (bank, 0..) |battery, idx| {
                const joltage = battery;
                while (maxList.getLastOrNull() != null and maxList.getLastOrNull().? < joltage) {
                    if (bank.len - idx + maxList.items.len <= 12) break;
                    _ = maxList.pop();
                }
                try maxList.append(joltage);
            }
            max += try std.fmt.parseInt(u64, maxList.items[0..12], 10);
        }
        return max;
    }
};

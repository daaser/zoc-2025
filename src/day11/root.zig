const std = @import("std");
const ArrayList = std.array_list.Aligned;
const StringHashMap = std.hash_map.StringHashMap;
const Allocator = std.mem.Allocator;
const eql = std.mem.eql;

const util = @import("../util.zig");

// const input = @embedFile("input.txt");
const input =
    \\aaa: you hhh
    \\you: bbb ccc
    \\bbb: ddd eee
    \\ccc: ddd eee fff
    \\ddd: ggg
    \\eee: out
    \\fff: out
    \\ggg: out
    \\hhh: ccc fff iii
    \\iii: out
;

const Device = struct {
    name: []const u8,
    edges: []Device,

    pub fn format(self: Device, w: *std.io.Writer) std.io.Writer.Error!void {
        try w.print("{s}\n", .{self.name});
        for (self.edges) |e| {
            std.debug.print("   {s}\n", .{e.name});
        }
    }
};

pub const Day = struct {
    pub fn partOne(alloc: Allocator) !u64 {
        const lines = try util.splitByte(alloc, std.mem.trim(u8, input, "\n"), '\n');
        var you: ?*const Device = null;
        var out: ?*const Device = null;
        var allDevices = StringHashMap(Device).init(alloc);
        for (lines) |line| {
            const parts = try util.splitByte(alloc, line, ':');
            const name = parts[0];
            const connDevices = try util.splitByte(alloc, std.mem.trim(u8, parts[1], " "), ' ');
            var edges = try alloc.alloc(Device, connDevices.len);
            for (connDevices, 0..) |device, idx| {
                const d = if (allDevices.contains(device)) allDevices.get(device).? else blk: {
                    const d = Device{
                        .name = device,
                        .edges = undefined,
                    };
                    try allDevices.put(device, d);
                    break :blk d;
                };
                edges[idx] = d;
            }
            const d = Device{
                .name = name,
                .edges = edges,
            };
            try allDevices.put(name, d);
            if (eql(u8, name, "you")) {
                you = &d;
            } else if (eql(u8, name, "out")) {
                out = &d;
            }
        }

        //std.debug.print("{f}\n", .{you.?});
        //var edges: ArrayList(*const Device, null) = .empty;
        //try edges.append(alloc, you.?);
        //while (edges.items.len > 0) {
        //    const edge = edges.pop() orelse break;
        //    std.debug.print("{s} -> ", .{edge.name});
        //    for (edge.edges) |e| {
        //        try edges.append(alloc, &e);
        //    }
        //}

        return 100000;
    }

    pub fn partTwo(alloc: Allocator) !u64 {
        _ = alloc;
        return 0;
    }
};

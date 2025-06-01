const std = @import("std");
const fmt = std.fmt;
const zbench = @import("zbench");

fn solve(limit: usize) usize {
    // Solution 1: Brute-force
    // var sum: usize = 0;
    // for (1..limit) |val| {
    //     if (val % 3 == 0 or val % 5 == 0) {
    //         sum += val;
    //     }
    // }
    // return sum;

    // Solution 2: Mathematics
    return sumDivisibleBy(limit, 3) + sumDivisibleBy(limit, 5) - sumDivisibleBy(limit, 15);
}

fn sumDivisibleBy(limit: usize, n: usize) usize {
    const p: usize = limit / n;
    return n * (p * (p + 1)) / 2;
}

test "base case" {
    const ans = solve(10);
    try std.testing.expectEqual(23, ans);
}

test "main case" {
    const ans = solve(1_000_000_000);
    try std.testing.expectEqual(233168, ans);
}

const P1Benchmark = struct {
    limit: usize,

    fn init(limit: usize) P1Benchmark {
        return .{ .limit = limit };
    }

    pub fn run(self: P1Benchmark, _: std.mem.Allocator) void {
        var result: usize = 0;
        for (0..100) |_| {
            result = solve(self.limit);
        }
    }
};

pub fn Benchmark() !void {
    const allocator = std.heap.page_allocator;
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(allocator, .{});
    defer bench.deinit();

    var limit: usize = 1;
    inline for (0..8) |_| {
        const name = try fmt.allocPrint(allocator, "P1 Benchmark {d}", .{limit});
        try bench.addParam(name, &P1Benchmark.init(limit), .{});
        limit *= 10;
    }

    try stdout.writeAll("\n");
    try zbench.prettyPrintHeader(stdout);
    var iter = try bench.iterator();
    while (try iter.next()) |step| switch (step) {
        .progress => |_| {},
        .result => |x| {
            defer x.deinit();
            try x.prettyPrint(allocator, stdout, true);
        },
    };
}

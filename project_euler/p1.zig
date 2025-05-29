const std = @import("std");

pub fn main() void {
    const input: usize = 1_000_000_000;

    const start = std.time.milliTimestamp();
    const ans = solve(input);
    const end = std.time.milliTimestamp();

    std.debug.print("Input: {}\nOutput: {}\nTime taken: {} ms\n", .{ input, ans, end - start });
}

fn solve(limit: usize) usize {
    var sum: usize = 0;
    for (1..limit) |val| {
        if (val % 3 == 0 or val % 5 == 0) {
            sum += val;
        }
    }
    return sum;
}

test "base case" {
    const ans = solve(10);
    try std.testing.expectEqual(23, ans);
}

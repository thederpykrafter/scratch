const std = @import("std");

//TODO: return shell_variable as string
pub fn getShellVar(shell_variable: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const env_map = try arena.allocator().create(std.process.EnvMap);
    env_map.* = try std.process.getEnvMap(arena.allocator());
    defer env_map.deinit(); // technically unnecessary when using ArenaAllocator

    const name = env_map.get(shell_variable) orelse ""; //TODO: fix if $HOME isnt set

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}\n", .{name});
}

pub fn isValidPath(path: []const u8) !void {
    var flag2 = true;
    _ = std.fs.cwd().openFile(path, .{}) catch |err| {
        flag2 = if (err == error.FileNotFound) false else true;
    };
    std.debug.print("{}\n", .{flag2});
}

pub fn main() !void {
    try isValidPath("/home/fuck");
    try isValidPath("Dev/");
    try getShellVar("HOME");
}

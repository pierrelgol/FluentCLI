const std = @import("std");
const Fluent = @import("fluent.zig");
const FluentCLI = @import("fluent_cli.zig").FluentCLI;


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        if (gpa.detectLeaks())
            @panic("Leaks detected!\n");
        _ = gpa.deinit();
    }
    const allocator = gpa.allocator();

    const stdout_handle = std.io.getStdOut();
    defer stdout_handle.close();
    const stdout = stdout_handle.writer();

    const stderr_handle = std.io.getStdErr();
    defer stderr_handle.close();
    const stderr = stderr_handle.writer();
    _ = stderr;

    const stdin_handle = std.io.getStdIn();
    defer stdin_handle.close();
    const stdin = stdin_handle.writer();
    _ = stdin;

    var path_buffer = try allocator.alloc(u8, std.fs.max_path_bytes);
    defer allocator.free(path_buffer);

    var file_buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(file_buffer);

    var arguments = try std.process.argsWithAllocator(allocator);
    defer arguments.deinit();

    // // This is the intended look and "usage" at the end
    // const argparse = FluentCLI("my_program");
    // const argvector = argparse.FluentCommandRegistry.init(allocator);
    // const help_command = argvector.addCommand()
    //         .setName("help")
    //         .setShort("-h")
    //         .setLong("--help")
    //         .setDesc("my_program: usage [command] ?[argument]")
    //         .setRegx("where I compute the regex to identify the command based on the short/long name i guess")
    //         .setOptionnal(true);


    if (arguments.skip()) {
        while (arguments.next()) |maybe_path| {
            var file_handle: std.fs.File = undefined;
            if (!std.fs.path.isAbsolute(maybe_path)) {
                const absolute_path = try std.fs.realpath(maybe_path, path_buffer[0..std.fs.max_path_bytes]);
                file_handle = try std.fs.openFileAbsolute(absolute_path, .{ .mode = .read_only });
            } else {
                file_handle = try std.fs.openFileAbsolute(maybe_path, .{ .mode = .read_only });
            }
            defer file_handle.close();
            while (true) {
                const bytes_read = try file_handle.read(file_buffer[0..4096]);
                try stdout.print("{s}", .{file_buffer[0..bytes_read]});
                if (bytes_read == 0) {
                    break;
                }
            }

        }
    }
}

const std = @import("std");
const testing = std.testing;

pub fn FluentCLI(name: []const u8) type {
    return struct {
        const program_name: []const u8 = name;

        pub const FluentArgument = struct {
            arg_name: []const u8,
            arg_desc: []const u8,
            is_required: bool,
            default_value: ?[]const u8,
            validator: ?fn (arg: []const u8) bool,
        };

        pub const FluentCommand = struct {
            flag_name: []const u8,
            flag_shrt: []const u8,
            flag_long: []const u8,
            flag_desc: []const u8,
            flag_args: []FluentArgument,
            is_optional: bool,
            callback: fn (@This(), anytype) bool,
        };

        pub const FluentCommandRegistry = struct {
            allocator: std.mem.Allocator,
            commands: []FluentCommand,
        };
    };
}

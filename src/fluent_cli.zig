const std = @import("std");
const testing = std.testing;

pub fn FluentCLI() type {
    return struct {
        const Self = @This();
        program_name: []const u8,

        pub fn init(program_name: []const u8) Self {
            return Self{
                .program_name = program_name,
            };
        }
    };
}

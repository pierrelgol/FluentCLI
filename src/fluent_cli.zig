const std = @import("std");
const testing = std.testing;

pub fn FluentCLI(name: []const u8) type {
    return struct {
        const program_name: []const u8 = name;

        pub const FluentArgument = struct {
            arg_name: []const u8,
            arg_desc: []const u8,
            arg_regx: []const u8,
            is_required: bool,
            default_value: ?[]const u8,
            validator: ?fn (arg: []const u8) bool,

            pub fn init() FluentArgument {
                return FluentArgument{
                    .arg_name = undefined,
                    .arg_desc = undefined,
                    .arg_regx = undefined,
                    .is_required = false,
                    .default_value = null,
                    .validator = null,
                };
            }

            pub fn setName(self: *FluentArgument, comptime arg_name: []const u8) *FluentArgument {
                self.arg_name = arg_name;
                return (self);
            }

            pub fn setDesc(self: *FluentArgument, comptime arg_desc: []const u8) *FluentArgument {
                self.arg_desc = arg_desc;
                return (self);
            }

            pub fn setRegx(self: *FluentArgument, comptime arg_regx: []const u8) *FluentArgument {
                self.arg_regx = arg_regx;
                return (self);
            }

            pub fn setDefault(self: *FluentArgument, comptime arg_default: []const u8) *FluentArgument {
                self.default_value = arg_default;
                return (self);
            }

            pub fn setRequired(self: *FluentArgument, is_required: bool) *FluentArgument {
                self.is_required = is_required;
                return (self);
            }

            pub fn setValidator(self: *FluentArgument, validator: fn (arg: []const u8) bool) *FluentArgument {
                self.validator = validator;
                return (self);
            }
        };

        pub const FluentCommand = struct {
            flag_name: []const u8,
            flag_shrt: []const u8,
            flag_long: []const u8,
            flag_desc: []const u8,
            flag_regx: []const u8,
            flag_args: []FluentArgument,
            is_optional: bool,
            callback: ?fn (self : *FluentCommand, receiver : anytype) bool,

            pub fn init() FluentCommand {
                return FluentCommand{
                    .flag_name = undefined,
                    .flag_shrt = undefined,
                    .flag_long = undefined,
                    .flag_desc = undefined,
                    .flag_regx = undefined,
                    .flag_args = undefined,
                    .is_optional = true,
                    .callback = null,
                };
            }

            pub fn setName(self: *FluentCommand, comptime flag_name: []const u8) *FluentCommand {
                self.flag_name = flag_name;
                return (self);
            }

            pub fn setShort(self: *FluentCommand, comptime flag_shrt: []const u8) *FluentCommand {
                self.flag_shrt = flag_shrt;
                return (self);
            }

            pub fn setLong(self: *FluentCommand, comptime flag_long: []const u8) *FluentCommand {
                self.flag_long = flag_long;
                return (self);
            }

            pub fn setDesc(self: *FluentCommand, comptime flag_desc: []const u8) *FluentCommand {
                self.flag_desc = flag_desc;
                return (self);
            }

            pub fn setRegx(self: *FluentCommand, comptime flag_regx: []const u8) *FluentCommand {
                self.flag_regx = flag_regx;
                return (self);
            }

            pub fn setOptionnal(self: *FluentCommand, optionnal: bool) *FluentCommand {
                self.is_optional = optionnal;
                return (self);
            }

            pub fn setCallback(self: *FluentCommand, callback: fn (cmd: *FluentCommand, receiver: anytype) bool) *FluentCommand {
                self.callback = callback;
                return (self);
            }

            pub fn addArgument(self: *FluentCommand, comptime arg: *FluentArgument) *FluentCommand {
                self.flag_args = self.flag_args ++ arg; //not correct yet but just for the sake of demo
                return (self);
            }
        };

        pub const FluentCommandRegistry = struct {
            allocator: std.mem.Allocator,
            commands: [32]FluentCommand,
            count : usize,

            pub fn init(allocator: std.mem.Allocator) FluentCommandRegistry {
                return FluentCommandRegistry{
                    .allocator = allocator,
                    .commands = [32]FluentCommand,
                    .count = 0,
                };
            }

            pub fn addCommand(self : *FluentCommandRegistry) *FluentCommand {
                defer self.count += 1;
                return (self.commands[self.count].init());
            }
        };
    };
}

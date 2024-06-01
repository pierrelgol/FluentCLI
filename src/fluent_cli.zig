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

            pub fn init(config : FluentArgument) FluentArgument {
                return FluentArgument{
                    .arg_name = config.arg_name,
                    .arg_desc = config.arg_desc,
                    .arg_regx = config.arg_regx,
                    .is_required = config.is_required,
                    .default_value = config.default_value,
                    .validator = config.validator,
                };
            }

        };

        pub const FluentCommand = struct {
            flag_name: []const u8,
            flag_shrt: []const u8,
            flag_long: []const u8,
            flag_desc: []const u8,
            flag_regx: []const u8,
            arg_count: usize,
            flag_args: []FluentArgument,
            is_optional: bool,
            callback: ?fn (self : *FluentCommand, receiver : anytype) bool,

            pub fn init(config : FluentCommand) FluentCommand {
                return FluentCommand{
                    .flag_name = config.flag_name,
                    .flag_shrt = config.flag_shrt,
                    .flag_long = config.flag_long,
                    .flag_desc = config.flag_desc,
                    .flag_regx = config.flag_regx,
                    .flag_args = config.flag_args,
                    .arg_count = config.arg_count,
                    .is_optional = config.is_optional,
                    .callback = config.callback,
                };
            }

            pub fn addArgument(self: *FluentCommand, config : FluentArgument) *FluentCommand {
                defer self.arg_count += 1;
                return (self.flag_args[self.arg_count].init(config));
            }
        };

        pub const FluentCommandRegistry = struct {
            commands: [32]FluentCommand,
            count : usize,

            pub fn init() FluentCommandRegistry {
                return FluentCommandRegistry{
                    .commands = [32]FluentCommand,
                    .count = 0,
                };
            }

            pub fn addCommand(self : *FluentCommandRegistry, config : FluentCommand) *FluentCommand {
                defer self.count += 1;
                return (self.commands[self.count].init(config));
            }
        };
    };
}

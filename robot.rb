#!/usr/bin/env ruby

require_relative "./lib/command_centre"

command_centre = CommandCentre.instance

if ARGV.length > 0
  command_centre.execute_from_file(ARGV[0])
end

command = STDIN.gets

while command
  command_centre.parse_and_execute(command)

  command = STDIN.gets
end

require 'singleton'

class Robot
  class CommandCentre
    include Singleton

    COMMANDS = %w(PLACE MOVE LEFT RIGHT REPORT)

    def parse_and_execute(command_string)
      command = Command.new(command_string.strip.upcase)
      return unless command.validate
      command.execute
    end

    ##
    # feature just for fun only for mac users
    def say(message)
      IO.popen(
        "say -v Ralph '#{message}'"
      ) if RbConfig::CONFIG['host_os'].match(/darwin|mac os/)
    end

    class Command
      attr_reader :command, :args, :robot

      def initialize(command_string)
        @command, @args = command_string.split(' ')
        @robot = Robot.instance
      end

      def execute
        return robot.place(args) if place?
        return robot.send(:"#{command.downcase}") if robot.table.placed?
        CommandCentre.instance.say('Does not compute, You must place me first')
      end

      def place?
        command == 'PLACE'
      end

      def validate
        COMMANDS.include?(command)
      end
    end
  end
end

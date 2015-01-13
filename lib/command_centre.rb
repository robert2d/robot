require 'singleton'
require_relative "robot"

class CommandCentre
  include Singleton

  class << self; attr_accessor :commands end
  @commands = %w(PLACE MOVE LEFT RIGHT REPORT)

  def parse_and_execute(command_string)
    command = Command.new(command_string.strip)
    return unless command.validate
    command.execute
  end

  def execute_from_file(file_path)
    commands = IO.readlines(file_path)
    commands.map(&:strip).each do |command_string|
      parse_and_execute(command_string) if !command_string.empty?
    end
  end

  ##
  # silly feature just for fun only for mac users
  def say(message)
    IO.popen("say -v Ralph '#{message}'") if RbConfig::CONFIG['host_os'].match /darwin|mac os/
  end

  class Command
    attr_reader :command, :args, :robot

    def initialize(command_string)
      @command, @args = command_string.split(' ')
      @robot = Robot.instance
    end

    def execute
      case command.upcase
      when "PLACE"
        robot.place(args)
      else
        if robot.table.placed?
          robot.send(:"#{command.downcase}")
        else
          return CommandCentre.instance.say("Does not compute, You must place me first")
        end
      end
    end

    def validate
      CommandCentre.commands.include? command.upcase
    end
  end

end

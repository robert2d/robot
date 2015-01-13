require 'singleton'
require_relative "table"
require_relative "command_centre"

class Robot
  include Singleton

  class <<self; attr_accessor :directions end
  @directions = {
    north: { x: 0, y: 1 },
    east: { x: 1, y: 0 },
    south: { x: 0, y: -1 },
    west: { x: -1, y: 0 }
  }

  attr_reader :table

  def initialize
    @table = Table.instance
  end

  ##
  # trys to move in current direction one place
  def move
    postition = new_position
    unless table.place(postition[:x], postition[:y])
      puts "Cannot move off the table"
      CommandCentre.instance.say("Does not compute, I will fall to my death")
    end
  end

  ##
  # fetches new coordinates and adds them to existing coords
  def new_position
    table.position.merge(move_coordinates) { |key, memo, value| memo + value }
  end

  def move_coordinates
    Robot.directions[self.direction]
  end

  ##
  # rotates compass faces and uses current face as index
  # to retrieve new direction
  def right
    self.direction = faces.rotate[face_index]
  end

  def left
    self.direction = faces.rotate(-1)[face_index]
  end

  def report
    CommandCentre.instance.say("My position is currently #{table.position[:x]}/
     by #{table.position[:y]} and facing #{direction}")
    puts "#{table.position[:x]}, #{table.position[:y]} #{direction.upcase}"
    puts display_string
  end

  def display_string
    arr = []
    25.times { arr << "X" }
    matrix = arr.each_slice(5).to_a
    arrow = { north: "^", east: ">", south: "v", west: "<" }[self.direction]
    matrix[table.position[:y]][table.position[:x]] = arrow
    matrix.reverse.map {|row| row.join(" ") }.join("\n")
  end

  def place(args)
    return unless args
    x, y, face = args.split(",")
    return unless x && y && face
    return unless table.place(x, y)
    self.direction = face.downcase.to_sym
  end

  def direction=(face)
    @direction = face if Robot.directions.keys.include?(face)
  end

  def direction
    @direction
  end

  private

  def faces
    Robot.directions.keys
  end

  def face_index
    faces.index(self.direction)
  end
end

require 'singleton'
require 'robot/table'
require 'robot/matrix'
require 'robot/command_centre'

class Robot
  include Singleton

  MOVEMENT_DIRECTIONS = {
    north: { x: 0, y: 1 },
    east: { x: 1, y: 0 },
    south: { x: 0, y: -1 },
    west: { x: -1, y: 0 }
  }

  attr_reader :table, :direction

  def initialize
    @table = Table.instance
  end

  ##
  # trys to move in current direction one place
  def move
    postition = new_position
    return if table.place(postition[:x], postition[:y])
    puts 'Cannot move off the table'
    CommandCentre.instance.say('Does not compute, I will fall to my death')
  end

  ##
  # rotates compass faces and uses current face as index
  # to retrieve new direction
  def right
    rotate(:right)
  end

  def left
    rotate(:left)
  end

  ##
  # outputs the x,y,position of the robot also includes a position matrix
  def report
    puts to_s
    puts Matrix.new(table.position, direction).to_s
    say_position
  end

  def to_s
    "#{table.position[:x]}, #{table.position[:y]} #{direction.upcase}"
  end

  def place(args)
    return unless args
    x, y, face = args.split(',')
    return unless x && y && face
    return unless table.place(x, y)
    self.direction = face.downcase.to_sym
  end

  private

  def say_position
    CommandCentre.instance.say("My position is currently #{table.position[:x]}/
     by #{table.position[:y]} and facing #{direction}")
  end

  ##
  # fetches new coordinates and adds them to existing coords
  def new_position
    table.position.merge(move_coordinates) { |_key, memo, value| memo + value }
  end

  def move_coordinates
    MOVEMENT_DIRECTIONS[direction]
  end

  def direction=(face)
    @direction = face if MOVEMENT_DIRECTIONS.keys.include?(face)
  end

  def rotate(direction)
    index = direction == :left ? -1 : 1
    self.direction = faces.rotate(index)[face_index]
  end

  def faces
    MOVEMENT_DIRECTIONS.keys
  end

  def face_index
    faces.index(direction)
  end
end

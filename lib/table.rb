require 'singleton'

class Table
  include Singleton

  attr_accessor :position
  attr_reader :width, :height

  def initialize
    @width = 4
    @height = 4
  end

  def place(x, y)
    position = { x: x.to_i, y: y.to_i }
    self.position = position if valid_position?(position)
  end

  def placed?
    !!self.position
  end

  def valid_position?(position)
    position[:x] <= width && position[:x] >= 0 && position[:y] <= height && position[:y] >= 0
  end
end

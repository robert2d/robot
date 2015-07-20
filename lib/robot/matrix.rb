class Robot
  class Matrix
    attr_reader :position, :direction
    attr_accessor :matrix

    DIRECTION_ARROWS = {
      north: '^',
      east: '>',
      south: 'v',
      west: '<'
    }

    def initialize(position, direction)
      @position = position
      @direction = direction
      @matrix = generate_matrix
    end

    ##
    # puts an arrow pointing in the direction of the current x,y of the robot
    # on a matrix and returns a string of the matrix
    def to_s
      set_current_position!
      matrix.reverse.map { |row| row.join(' ') }.join("\n")
    end

    private

    ##
    # sets the current position x,y coords to a directional arrow
    def set_current_position!
      matrix[
        position[:y]
      ][
        position[:x]
      ] = DIRECTION_ARROWS[direction]
    end

    ##
    # constructs a matrix of positions
    # Output:
    #  [
    #   ["X", "X", "X", "X", "X"],
    #   ["X", "X", "X", "X", "X"],
    #   ["X", "X", "X", "X", "X"],
    #   ["X", "X", "X", "X", "X"],
    #   ["X", "X", "X", "X", "X"]
    # ]
    def generate_matrix
      [].tap { |a| 25.times { a << 'X' } }.each_slice(5).to_a
    end
  end
end

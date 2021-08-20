require_relative "tile"

class Board
  def self.empty_grid
    Array.new(9) do
      Array.new(9) { Tile.new("E") }
    end
  end

  def initialize(grid = self.class.empty_grid)
    @grid = grid
  end

  def [](pos)
    x,y = pos
    grid[x][y]
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, index|
      print "#{index}"
      row.each { |tile| print " #{tile.value}"}
      print "\n"
    end
  end

  private
  attr_reader :grid
end
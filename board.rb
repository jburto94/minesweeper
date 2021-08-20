require_relative "tile"

class Board
  def self.empty_grid
    empty_grid = Array.new(9) do
      Array.new(9) { Tile.new("E") }
    end
  end

  def random_tile
    x = rand(9)
    y = rand(9)
    grid[x][y]
  end

  def plant_bombs
    num_bombs = rand(9..14)
    i = 0
    (0...num_bombs).each do
      tile = self.random_tile
      tile.value = "B"
    end
  end

  def initialize(grid = self.class.empty_grid)
    @grid = grid
    self.plant_bombs
  end

  def [](pos)
    x,y = pos
    grid[x][y]
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, index|
      print "#{index}"
      row.each { |tile| print " #{tile.to_s}"}
      print "\n"
    end
  end

  private
  attr_reader :grid
end
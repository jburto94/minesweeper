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
    p pos
    x,y = pos
    grid[x][y]
  end

  def get_pos
    puts "Select a squre you would like to reveal (ex. 2,1):"
    pos = gets.chomp.split(",").map { |num| num.to_i }
    while !self.valid_tile?(pos)
      puts "Select a squre you would like to reveal (ex. 2,1):"
      pos = gets.chomp.split(",").map { |num| num.to_i }
    end
    x,y = pos
    grid[x][y].turned = true
    p grid[x][y]
  end

  def valid_tile?(pos)
    x, y = pos
    if !(x.to_s =~ /\A[-+]?\d*\.?\d+\z/) || !(y.to_s =~ /\A[-+]?\d*\.?\d+\z/)
      return false
    end
    return false if x > 8 || y > 8 || x < 0 || y < 0
    return false if grid[x][y].turned?
    return true
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, index|
      print "#{index}"
      row.each { |tile| print " #{tile.to_s}"}
      print "\n"
    end
  end

  def play_round
    self.render
    self.get_pos
    self.render
  end

  private
  attr_reader :grid
end
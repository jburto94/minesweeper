require "byebug"
require_relative "tile"

class Board
  def self.empty_grid
    empty_grid = Array.new(9) do
      Array.new(9) { Tile.new("X") }
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

  def get_tile
    puts "Select a squre you would like to reveal (ex. 2,1):"
    pos = gets.chomp.split(",").map { |num| num.to_i }
    while !self.valid_tile?(pos)
      puts "Select a squre you would like to reveal (ex. 2,1):"
      pos = gets.chomp.split(",").map { |num| num.to_i }
    end
    flip_tile(pos)
  end

  def is_bomb?(pos)
    row, col = pos
    grid[row][col].value == "B"
  end

  def flip_tile(pos)
    x, y = pos
    grid[x][y].turned = true
    self.check_adjacent_tiles(pos)
  end

  def get_adjacent_tiles(pos)
    x, y = pos
    p "x: #{pos}"
    left = x - 1
    right = x + 1
    up = y - 1
    down = y + 1
    adjacent_tiles = [[left,y], [left,up], [x,up], [right,up], [right,y], [right,down], [x,down], [left,down]]
    adjacent_tiles.select { |tile| valid_tile?(tile) }
  end

  def check_adjacent_tiles(pos)
    adjacent_tiles = self.get_adjacent_tiles(pos)

    adjacent_tiles.each do |tile|
      return false if self.is_bomb?(tile)
    end

    self.display_bulk_tiles(adjacent_tiles)

    adjacent_tiles.each { |adjacent_tile| self.check_adjacent_tiles(adjacent_tile) }
  end

  def display_bulk_tiles(tiles)
    tiles.each do |tile|
      x,y = tile
      grid[x][y].turned = true
    end
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

  def bomb_shown?
    grid.each do |row|
      row.each { |tile| return true if tile.value == "B" && tile.turned? }
    end
    return false
  end

  def any_hidden_squares?
    grid.each do |row|
      row.each { |tile| return true if !tile.turned? }
    end
    return false
  end

  def show_full_board
    grid.each do |row|
      row.each { |tile| tile.turned = true }
    end
  end

  def terminate?
    if bomb_shown?
      self.show_full_board
    end
    return false if any_hidden_squares?
    self.show_full_board
    true
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
    self.get_tile
  end

  def run
    while !terminate?
      self.play_round
    end

    self.render
    p "END"
  end

  private
  attr_reader :grid
end
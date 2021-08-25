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
    num_bombs = rand(9..12)
    i = 0
    (0...num_bombs).each do
      tile = random_tile
      tile.value = "B"
    end
  end

  def initialize(grid = self.class.empty_grid)
    @grid = grid
    plant_bombs
  end

  def is_bomb?(pos)
    row, col = pos
    grid[row][col].value == "B"
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

  def valid_flag?(pos)
    x, y = pos
    if !(x.to_s =~ /\A[-+]?\d*\.?\d+\z/) || !(y.to_s =~ /\A[-+]?\d*\.?\d+\z/)
      return false
    end
    return false if x > 8 || y > 8 || x < 0 || y < 0
    grid[x][y].flagged?
  end

  def flip_tile(pos)
    x, y = pos
    grid[x][y].turned = true
    check_adjacent_tiles(pos)
  end

  def flag_tile(pos)
    x, y = pos
    grid[x][y].flagged = true
  end

  def unflag_tile(pos)
    x, y = pos
    grid[x][y].flagged = false
  end

  def get_adjacent_tiles(pos)
    x, y = pos
    left = x - 1
    right = x + 1
    up = y - 1
    down = y + 1
    adjacent_tiles = [[left,y], [left,up], [x,up], [right,up], [right,y], [right,down], [x,down], [left,down]]
    adjacent_tiles.select { |tile| valid_tile?(tile) }
  end

  def check_adjacent_tiles(pos)
    adjacent_tiles = get_adjacent_tiles(pos)

    check_adjacent_bombs(pos)

    adjacent_tiles.each do |tile|
      return false if is_bomb?(tile)
    end

    display_bulk_tiles(adjacent_tiles)

    adjacent_tiles.each { |adjacent_tile| check_adjacent_tiles(adjacent_tile) }
  end

  def check_adjacent_bombs(pos)
    x,y = pos
    count = 0
    adjacent_tiles = get_adjacent_tiles(pos)

    adjacent_tiles.each do |tile|
      count += 1 if is_bomb?(tile)
    end

    grid[x][y].border_bombs = count
  end

  def display_bulk_tiles(tiles)
    tiles.each do |tile|
      x,y = tile
      grid[x][y].turned = true
    end
  end

  def bomb_shown?
    grid.each do |row|
      row.each { |tile| return true if tile.value == "B" && tile.turned? }
    end
    return false
  end

  def any_hidden_squares?
    grid.each do |row|
      row.each { |tile| return true if !tile.turned? && tile.value != "B" }
    end
    return false
  end

  def show_full_board
    grid.each do |row|
      row.each { |tile| tile.turned = true }
    end
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
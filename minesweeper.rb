require "colorize"
require_relative "board"

class MineSweeper
  def initialize
    @board = Board.new
  end

  def get_input
    puts "Select a square you would like to reveal (ex. 2,1); to flag a tile enter 'flag' and to unflag a tile enter 'unflag':"
    input = gets.chomp
    if input == "flag"
      pos = parse_flag_position
      board.flag_tile(pos)
    elsif input == "unflag"
      pos = parse_unflag_position
      pos ? board.unflag_tile(pos) : get_input
    else
      pos = input.split(",").map { |num| num.to_i }
      parsed_pos = parse_position(pos)
      board.flip_tile(parsed_pos)
    end
  end

  def parse_flag_position
    puts "Select the tile you would like to flag (ex. 2,1):"
    pos = gets.chomp.split(",").map { |num| num.to_i }
    parse_position(pos)
  end

  def parse_unflag_position
    puts "Select the tile you would like to unflag (ex. 2,1):"
    pos = gets.chomp.split(",").map { |num| num.to_i }
    pos = nil if !board.valid_flag?(pos)
    pos
  end

  def parse_position(pos) 
    while !board.valid_tile?(pos)
      puts "Select a tile (ex. 2,1):"
      pos = gets.chomp.split(",").map { |num| num.to_i }
    end
    pos
  end

  def terminate?
    if board.bomb_shown?
      board.show_full_board
      puts "YOU HAVE LOST THE GAME".colorize(:red)
      return true
    end
    return false if board.any_hidden_squares?
    board.show_full_board
    puts "CONGRATULATIONS! YOU HAVE WON THE GAME!".colorize(:green)
    true
  end

  def play_round
    board.render
    get_input
  end

  def run
    while !terminate?
      play_round
    end

    board.render
  end

  private
  attr_reader :board
end
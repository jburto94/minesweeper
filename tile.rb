require "colorize"

class Tile
  attr_accessor :value, :border_bombs
  attr_writer :turned, :flagged

  def initialize(value)
    @value = value
    @turned = false
    @flagged = false
    @border_bombs = 0
  end

  def turned?
    @turned
  end

  def flagged?
    @flagged
  end

  def color
    flagged? ? :yellow :
    value == "B" ? :red :
    border_bombs != 0 ? :blue : :green
  end

  def to_s
    flagged? ? "F".colorize(self.color) :
      !@turned ? " " :
        border_bombs > 0 && value != "B" ? 
          border_bombs.to_s.colorize(self.color) : value.colorize(self.color)
  end
end
require "colorize"

class Tile
  attr_accessor :value
  attr_writer :turned

  def initialize(value)
    @value = value
    @turned = false
  end

  def color
    value == "B" ? :red : :green
  end

  def to_s
    value == "B" ? value : " "
  end
end
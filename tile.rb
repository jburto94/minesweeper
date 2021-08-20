require "colorize"

class Tile
  attr_accessor :value
  attr_writer :turned

  def initialize(value)
    @value = value
    @turned = false
  end

  def turned?
    @turned
  end

  def color
    value == "B" ? :red : :green
  end

  def to_s
    @turned ? value : " "
  end
end
require_relative "./gol/world"

module Gol
  VERSION = "0.1.0"

  w = Gol::World.new(40, 60)
  w.run
end

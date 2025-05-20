require "./gol/*"

module Gol
  VERSION = "0.1.0"

  w = Gol::World.new(lines: 40, columns: 60)
  w.run
end

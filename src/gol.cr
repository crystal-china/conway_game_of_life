require "./gol/*"

module Gol
  VERSION = "0.1.0"

  w = Gol::World.new(lines: 25, columns: 50)
  w.run
end

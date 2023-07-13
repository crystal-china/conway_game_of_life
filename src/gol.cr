require "./gol/*"

module Gol
    VERSION = "0.1.0"

    w = Gol::World.new(25, 50)
    w.run()
end

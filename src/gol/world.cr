module Gol
  class Cell
    property? alive
    getter x, y

    def initialize(@alive : Bool, @x : Int32, @y : Int32)
    end

    def to_s(io : IO)
      if alive?
        io << "x"
      else
        io << " "
      end
    end
  end

  class World
    @lines : Int32
    @columns : Int32
    @cells : Array(Array(Cell))

    @rand = Random.new

    def initialize(@lines, @columns, init_max_living = 50)
      @cells = Array(Array(Cell)).new
      living_count = 0

      (0..lines).each do |x|
        cell_line = Array(Cell).new
        (0..columns).each do |y|
          if living_count >= init_max_living
            next_bool = false
          else
            next_bool = @rand.next_bool
            living_count += 1 if next_bool
          end

          cell_line << Cell.new(next_bool, x, y)
        end

        @cells << cell_line
      end
    end

    def to_s(io : IO)
      @cells.each do |l|
        io.puts
        l.each do |c|
          io << c
        end
      end
    end

    def run
      loop do
        clear_screen()

        if number_of_cells_alive == 0
          puts("All cells are dead!")
          exit(0)
        end

        print self

        @cells.each do |l|
          l.each do |c|
            neighbours_alive = number_of_neighbours_alive_for(c)

            case c
            when .alive?
              # 因为孤独或人口过剩而死亡
              c.alive = false if neighbours_alive < 2 || neighbours_alive > 3
            else
              # 繁殖
              c.alive = true if neighbours_alive == 3
            end
          end
        end

        sleep(100.millisecond)
      end
    end

    private def number_of_neighbours_alive_for(cell)
      x_max = @lines
      y_max = @columns
      x = cell.x
      y = cell.y

      neighbours = Array(Cell).new

      # Checking for limit conditions:
      [-1, 0, 1].each do |i|
        [-1, 0, 1].each do |j|
          if (
               x + i >= 0 &&
               x + i < x_max &&
               y + j >= 0 &&
               y + j < y_max &&
               {i, j} != {0, 0}
             )
            neighbours << @cells[x + i][y + j]
          end
        end
      end

      alive = 0

      neighbours.each do |n|
        alive += 1 if n.alive?
      end

      alive
    end

    private def number_of_cells_alive
      cells_alive = 0

      @cells.each do |l|
        l.each do |c|
          cells_alive += 1 if c.alive?
        end
      end

      cells_alive
    end

    # Clears the terminal
    private def clear_screen
      print "\33c\e[3J"
    end
  end
end

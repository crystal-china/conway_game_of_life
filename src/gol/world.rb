module Gol
  class Cell
    attr_writer :alive
    attr_reader :x, :y

    def alive?
      @alive
    end

    def initialize(alive, x, y)
      @alive = alive
      @x = x
      @y = y
    end

    def to_s
      @alive ? "x" : " "
    end
  end

  class World
    def initialize(lines, columns, init_max_living = 50)
      @lines = lines
      @columns = columns
      @cells = []
      living_count = 0
      random = [true, false]

      (0..lines).each do |x|
        cell_line = []
        (0..columns).each do |y|
          if living_count >= init_max_living
            next_bool = false
          else
            next_bool = random.sample
            living_count += 1 if next_bool
          end

          cell_line << Cell.new(next_bool, x, y)
        end

        @cells << cell_line
      end
    end

    def to_s
      io = ""

      @cells.each do |l|
        io << "\n"
        l.each do |c|
          io << c.to_s
        end
      end

      io
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

            if c.alive?
              # 因为孤独或人口过剩而死亡
              c.alive = false if neighbours_alive < 2 || neighbours_alive > 3
            else
              # 繁殖
              c.alive = true if neighbours_alive == 3
            end
          end
        end

        sleep(0.1)
      end
    end

    private def number_of_neighbours_alive_for(cell)
      x_max = @lines
      y_max = @columns
      x = cell.x
      y = cell.y

      neighbours = []

      # Checking for limit conditions:
      [-1, 0, 1].each do |i|
        [-1, 0, 1].each do |j|
          if (
               x + i >= 0 &&
               x + i < x_max &&
               y + j >= 0 &&
               y + j < y_max &&
               [i, j] != [0, 0]
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

require "benchmark"

module Gol
  VERSION = "0.1.0"

  struct Cell
    property? alive : Bool
    getter x : Int32, y : Int32

    def initialize(@alive, @x, @y)
    end

    def to_s(io : IO)
      io << (@alive ? "x" : " ")
    end
  end

  class World
    def initialize(@lines : Int32, @columns : Int32, init_max_living = 100)
      @cells = Array(Array(Cell)).new
      rand = Random.new
      living_count = 0

      (0..lines).each do |x|
        cell_line = Array(Cell).new
        (0..columns).each do |y|
          if living_count >= init_max_living
            next_bool = false
          else
            next_bool = rand.next_bool
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
      generation = 0

      loop do
        clear_screen()

        check_cells_alive!

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

            @cells[c.x][c.y] = c
          end
        end

        sleep(1.millisecond)
        generation += 1

        break if generation == 10000
      end
    end

    private def number_of_neighbours_alive_for(cell)
      x_max = @lines
      y_max = @columns
      x = cell.x
      y = cell.y
      count = 0

      # Checking for limit conditions:
      [-1, 0, 1].each do |i|
        [-1, 0, 1].each do |j|
          nx = x + i
          ny = y + j

          next if nx >= x_max
          next if nx < 0

          next if ny >= y_max
          next if ny < 0

          next if {i, j} == {0, 0}

          count += 1 if @cells[nx][ny].alive?
        end
      end

      count
    end

    private def check_cells_alive!
      @cells.each do |l|
        l.each do |c|
          return if c.alive?
        end
      end

      sleep 0.5.seconds
      puts("All cells are dead!")
      exit(0)
    end

    # Clears the terminal
    private def clear_screen
      print "\33c\e[3J"
    end
  end
end

# 似乎无论内存占用，还是性能，struct 版本都略好一点点。
w = Gol::World.new(lines: 40, columns: 60)
# puts Benchmark.measure { w.run }
puts Benchmark.memory { w.run }

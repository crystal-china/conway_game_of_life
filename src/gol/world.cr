require "./clrscr"
require "./cell.cr"

class Gol::World
  getter lines : Int32
  getter columns : Int32
  getter cells : Array(Array(Gol::Cell))

  @rand = Random.new

  def initialize(@lines, @columns, max = 50)
    @cells = Array(Array(Gol::Cell)).new
    true_count = 0

    (0..lines).each do |x|
      cell_line = Array(Gol::Cell).new
      (0..columns).each do |y|
        next_bool = @rand.next_bool
        true_count += 1 if next_bool

        if true_count >= max
          cell_line << Gol::Cell.new(false, x, y)
        else
          cell_line << Gol::Cell.new(next_bool, x, y)
        end
      end
      @cells << cell_line
    end
  end

  def print
    io = STDOUT

    @cells.each do |l|
      io.puts
      l.each do |c|
        io.print "#{c.repr}"
      end
    end
  end

  def run
    world = self

    loop do
      clrScr()

      @cells.each do |l|
        l.each do |c|
          world = c.check_neighbours(world)
        end
      end
      world.print
      sleep(100.millisecond)
    end
  end
end

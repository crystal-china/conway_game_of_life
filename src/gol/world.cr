require "./clrscr"
require "./cell.cr"

class Gol::World
  @lines : Int32
  @columns : Int32
  @rand = Random.new
  getter? cells : Array(Array(Gol::Cell))
  getter? lines : Int32
  getter? columns : Int32

  def initialize(@lines, @columns)
    @cells = Array(Array(Gol::Cell)).new
    (0..lines).each do |x|
      cell_line = Array(Gol::Cell).new
      (0..columns).each do |y|
        cell_line << Gol::Cell.new(@rand.next_bool, x, y)
      end
      @cells << cell_line
    end
  end

  def modifyCell(c : Cell)
    @cells[c.x?][c.y?] = c
  end

  def print
    io = IO::Memory.new
    @cells.each do |l|
      io.puts
      l.each do |c|
        io.print "#{c.repr}"
      end
    end
    puts io
  end

  def sprint : String
    io = IO::Memory.new
    @cells.each do |l|
      io.puts
      l.each do |c|
        io.print "#{c.repr}"
      end
    end
    # puts io
    return io.to_s
  end

  def printValues
    io = IO::Memory.new
    @cells.each do |l|
      io.puts
      l.each do |c|
        io.print "(#{c.repr}, #{c.x?}, #{c.y?})"
      end
    end
    puts io
  end

  def run
    # make all cells check neigbours (sequentially):
    generations = 0
    cells = 0
    world = self

    loop do # looping over 'generations' (endlessly)
      clrScr()
      generations += 1
      @cells.each do |l|
        l.each do |c|
          cells += 1
          world = c.check_neighbours(world, generations, cells)
        end
      end
      world.print
      sleep(100.millisecond)
    end
  end
end

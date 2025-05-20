class Gol::Cell
  getter? alive, x, y

  def initialize(@alive : Bool, @x : Int32, @y : Int32)
  end

  def dead?
    !@alive
  end

  def dead!
    @alive = false
  end

  def alive!
    @alive = true
  end

  def repr : String
    @alive ? "x" : " "
  end

  def check_neighbours(w : World, generations : Int32, cells : Int32)
    x_max = w.lines?
    y_max = w.columns?

    neighbours = Array(Cell).new

    # Checking for limit conditions:
    [-1, 0, 1].each do |i|
      [-1, 0, 1].each do |j|
        if @x + i >= 0 && @x + i < x_max && @y + j >= 0 && @y + j < y_max && {i, j} != {0, 0}
          neighbours << w.cells?[@x + i][@y + j]
        end
      end
    end

    # Number of neighbours alive:
    neighbours_alive = neighbours.select(&.alive?).size

    # Total nb of cells alive
    cells_alive = 0

    w.cells?.each do |l|
      l.each do |c|
        if c.alive?
          cells_alive += 1
        end
      end
    end

    if cells_alive == 0
      puts("All cells are dead!")
      exit(0)
    end

    # Conway's conditions:
    case self
    when .alive?
      # 生命数量稀少 或 生命数量过多，死亡
      self.dead! if neighbours_alive > 3 || neighbours_alive < 2
    when .dead?
      # 繁殖
      self.dead! if neighbours_alive == 3
    end

    # modify w:
    w.modifyCell(self)

    w
  end
end

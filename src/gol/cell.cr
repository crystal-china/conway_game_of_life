class Gol::Cell
  getter? alive
  getter x, y

  def initialize(@alive : Bool, @x : Int32, @y : Int32)
  end

  def dead?
    !@alive
  end

  def repr : String
    @alive ? "x" : " "
  end

  def check_neighbours(w : World)
    x_max = w.lines
    y_max = w.columns

    neighbours = Array(Cell).new

    # Checking for limit conditions:
    [-1, 0, 1].each do |i|
      [-1, 0, 1].each do |j|
        if @x + i >= 0 && @x + i < x_max && @y + j >= 0 && @y + j < y_max && {i, j} != {0, 0}
          neighbours << w.cells[@x + i][@y + j]
        end
      end
    end

    # Number of neighbours alive:
    neighbours_alive = 0
    # Total nb of cells alive
    cells_alive = 0

    neighbours.each do |n|
      neighbours_alive += 1 if n.alive?
    end

    w.cells.each do |l|
      l.each do |c|
        cells_alive += 1 if c.alive?
      end
    end

    if cells_alive == 0
      puts("All cells are dead!")
      exit(0)
    end

    # Conway's conditions:
    case self
    when .alive?
      # 因为孤独或人口过剩而死亡
      @alive = false if neighbours_alive < 2 || neighbours_alive > 3
    when .dead?
      # 繁殖
      @alive = true if neighbours_alive == 3
    end

    w.cells[x][y] = self

    w
  end
end

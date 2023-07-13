class Gol::Cell
    @alive : Bool
    @x : Int32
    @y : Int32

    def initialize(@alive, @x, @y)
    end

    def dead?
        !alive?
    end

    def alive?
        @alive
    end

    def dead!
        @alive = false
    end

    def alive!
        @alive = true
    end

    def x?
        return @x
    end

    def y?
        return @y
    end

    def repr : String
        if @alive == true
            return "x"
        else 
            return " "
        end
    end
    
    def checkNeighbours(w : World, generations : Int32, cells : Int32)

        x_max = w.lines?
        y_max = w.columns?

        neighbours = Array(Cell).new

        # Checking for limit conditions:
        [-1, 0 , 1].each do |i|
            [-1, 0, 1].each do |j|
                if @x+i >= 0 && @x+i < x_max && @y+j >= 0  && @y+j < y_max && {i,j} != {0, 0}
                    neighbours << w.cells?[@x+i][@y+j]
                end
            end
        end
        
        # Number of neighbours alive:
        neighbours_alive = 0
        neighbours.each do |n|
            if n.alive?
                neighbours_alive += 1
            end
        end

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
        if self.alive? && neighbours_alive >= 3
            self.dead!
        elsif self.alive? && neighbours_alive < 2
            self.dead!
        elsif self.dead? && neighbours_alive == 3
            self.alive!
        end

        # modify w:
        w.modifyCell(self)

        # clrScr()
        # print("Cell: #{{self.x?, self.y?}}, \
        # Generations: #{generations}, \
        # Cells scanned: #{cells}, \
        # Total cell: #{cells_alive}\n
        # #{w.sprint()}")
        # sleep(10.millisecond)

        return w
    end # def

end # class

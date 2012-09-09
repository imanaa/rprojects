module Sudoku
  class Grid
    private
    class Cell
      include Observable

      attr_reader :grid, :row, :col, :cells_in_same_row, :cells_in_same_column, :cells_in_same_square, :attached_cells
      def initialize(grid,row,col)
        @grid = grid
        @row  = row
        @col  = col
        @attached_cells = []
        @cells_in_same_row = []
        @cells_in_same_square = []
        @cells_in_same_column = []

        # By default, every digits is allowed
        @alternatives = (1..9).to_a

        self.add_observer(@grid)
      end

      # Removes all possible digits except the given one
      # Returns an array of removed digits
      # Raises "ImpossibleGrid" exception if the given digit is not allowed in this cell
      def set(digit)
        raise ImpossibleGrid unless @alternatives.include?(digit)

        @alternatives.delete(digit)
        removed_digits = @alternatives    
        @alternatives = [digit]

        changed()
        notify_observers(@row+1, @col+1)

        return removed_digits
      end

      def value
        return self.set? ? @alternatives.first : nil
      end

      def add(digit)
        unless @alternatives.include?(digit)
          @alternatives << digit

          if @alternatives.size==2
            changed()
            notify_observers(@row+1, @col+1)
          end
        end
      end

      def remove(digit)
        raise ImpossibleGrid unless @alternatives.include?(digit)

        @alternatives.delete(digit)
        if @alternatives.size == 1
          changed()
          notify_observers(@row+1, @col+1)
        end
      end

      def set?
        @alternatives.size==1
      end

      def possible?(digit)
        @alternatives.include?(digit)
      end

      def register_attached_cell(cell)
        return if cell.row == self.row and cell.col == self.col
        return if @attached_cells.include?(cell)
        @cells_in_same_row << cell if cell.row == self.row
        @cells_in_same_column << cell if cell.col == self.col
        @cells_in_same_square << cell if (cell.row/3==self.row/3) and (cell.col/3==self.col/3)
        if @cells_in_same_row.include?(cell) or @cells_in_same_column.include?(cell) or @cells_in_same_square.include?(cell) then
        @attached_cells << cell
        end
      end

      def nb_alternatives
        @alternatives.size
      end

      def alternatives
        @alternatives.clone
      end

      def to_s
        "(#{row+1},#{col+1})"
      end
    end
  end
end
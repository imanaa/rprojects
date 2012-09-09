module Sudoku
  module CommandHistory
    def undo
      return if  commands_history.empty?                  # Nothing to undo
      return if commands_level.zero?                      # no more actions
      self.commands_level= commands_level-1
      commands_history[commands_level].undo
    end

    def redo
      return if commands_history.empty?                   # Nothing to redo
      return if commands_level == commands_history.size   # no more actions
      commands_history[commands_level].do
      self.commands_level= commands_level+1
    end

    def add_command_to_history(command)
      unless commands_history.empty?
        commands_history.slice!(commands_level..-1)
      end
      commands_history[commands_level] = command
      self.commands_level= commands_level+1
    end

    def clear_command_history
      @commands_history = []
      @commands_level = 0
    end

    private

    def commands_level
      if defined?(@commands_level).nil? then @commands_level = 0 end
      return @commands_level
    end

    def commands_level=(level)
      @commands_level=level
    end

    def commands_history
      @commands_history = [] if defined?(@commands_history).nil?
      return @commands_history
    end
  end

  class Grid
    include CommandHistory
    private
    class Command
      attr_accessor  :run_before, :run_after
      def initialize()
        @children = []
        @first_run = true
        self.run_after = self.run_before = nil
      end

      def run
        raise NotImplemented
      end

      def rollback
        raise NotImplemented
      end

      def do
        begin
          self.run_before.do unless self.run_before.nil?
          run
          @first_run = false
          @children.each { |action|
            action.do
          }
          self.run_after.do unless self.run_after.nil?
        rescue Grid::ImpossibleGrid, NameError => e
          undo
          raise e
        end
      end

      def undo
        self.run_before.undo unless self.run_before.nil?
        rollback
        @children.each { |action|
          action.undo
        }
        self.run_after.undo unless self.run_after.nil?
      end
    end

    class  SetCommand < Command
      attr_reader :cell
      attr_reader :digit
      def initialize(cell, digit)
        super()
        @cell = cell
        @digit = digit
        @removed_digits = nil
      end

      def run
        @removed_digits = nil
        @removed_digits = @cell.set(@digit)
        @cell.grid.debug "Set cell #{@cell.to_s} to #{@digit} by removing #{@removed_digits.to_s}"
        return unless @first_run
        @cell.attached_cells.each { |cell|
          next unless cell.possible?(@digit)
          if cell.nb_alternatives == 2 then
            alternatives = cell.alternatives
            alternatives.select! {|x| x!=@digit}
            @children << SetCommand.new(cell,alternatives.first)
          else
            @children.insert(0, RemoveCommand.new(cell,@digit))
          end
        }
      end

      def rollback
        return if @removed_digits.nil?
        @removed_digits.each { |digit|
          @cell.add(digit)
          @cell.grid.debug "Rollback Set - adding #{digit} to cell #{@cell.to_s}"
        }
      end

      def to_s
        "Set (#{@cell.row+1},#{@cell.col+1}) to #{@digit}"
      end
    end

    class RemoveCommand < Command
      attr_reader :cell
      attr_reader :digit
      def initialize(cell, digit)
        super()
        @cell = cell
        @digit = digit
        @removed = false
      end

      def run
        @removed = false
        @cell.remove(@digit)
        @removed = true
        @cell.grid.debug "Remove #{digit} from cell #{@cell.to_s}"
      end

      def rollback
        if @removed
          @cell.grid.debug "Rollback Remove - adding #{digit} to cell #{@cell.to_s}"
          @cell.add(digit)
        end
      end

      def to_s
        "Remove #{@digit} from (#{@cell.row+1},#{@cell.col+1})"
      end
    end

    class DeductionCommand < Command
      def initialize(grid, empty_cells)
        super()
        @empty_cells = empty_cells
        @grid = grid
      end

      def run
        # Clears previous results
        @children = []
        empty_cells = @empty_cells.clone
        empty_cells.each { |cell|
          if cell.set? then
          empty_cells.delete(cell)
          next
          end

          cell.alternatives.each { |digit|
          # Does this cells contain a digit that does not exists in any other cell of the same row ?
            a = cell.cells_in_same_row.select { |attached_cell| attached_cell.possible?(digit) }
            if a.empty?
              @children << SetCommand.new(cell,digit)
            empty_cells.delete(cell)
            break
            end

            # Does this cells contain a digit that does not exists in any other cell of the same column ?
            a = cell.cells_in_same_column.select { |attached_cell| attached_cell.possible?(digit) }
            if a.empty?
              @children << SetCommand.new(cell,digit)
            empty_cells.delete(cell)
            break
            end

            # Does this cells contain a digit that does not exists in any other cell of the same small square ?
            a = cell.cells_in_same_square.select { |attached_cell| attached_cell.possible?(digit) }
            if a.empty? then
              @children << SetCommand.new(cell,digit)
            empty_cells.delete(cell)
            break
            end
          }
        }

        unless @children.empty? or empty_cells.empty?
          self.run_after = DeductionCommand.new(@grid, empty_cells)
        end
      end

      def rollback
        # Empty method
      end

      def to_s
        "Deduction Command"
      end
    end
  end
end
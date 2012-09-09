module Sudoku
  class Grid
    attr_accessor :logger

    extend Forwardable
    def_delegator(:@logger, :unknown, :unknown)
    def_delegator(:@logger, :fatal, :fatal)
    def_delegator(:@logger, :error, :error)
    def_delegator(:@logger, :warn, :warn)
    def_delegator(:@logger, :info, :info)
    def_delegator(:@logger, :debug, :debug)
    def self.[](*rows)
      grid = Grid.new
      0.upto(8) { |row|
        next if rows[row].nil?
        0.upto(8) { |col|
          next if rows[row][col]==nil
          grid.set(row+1,col+1,rows[row][col])
        }
      }
      grid.clear_command_history
      return grid
    end

    def initialize
      @logger=Logger.new(STDERR)
      @logger.datetime_format = "%H:%M:%S"
      @logger.level = Logger::UNKNOWN

      @grid = (0..8).map do |row|
        (0..8).map do |col|
           Cell.new(self,row,col)
        end
      end

      @empty_cells = @grid.flatten
      @set_cells = []

      0.upto(8) { |row|
        0.upto(8) { |col|
          cell = @grid[row][col]
          # Add cells in the same row
          @grid[row].each { |c| cell.register_attached_cell(c) }
          # Add cells in the same column
          0.upto(8) {|r| cell.register_attached_cell(@grid[r][col]) }
          # Upper left corner of the corresponding rectangle
          rect_r = (row / 3) * 3
          rect_c = (col / 3) * 3
          rect_r.upto(rect_r+2) { |r|
            rect_c.upto(rect_c+2) { |c|
              cell.register_attached_cell(@grid[r][c])
            }
          }
        }
      }
    end

    def destroy
      @logger.close unless @logger.nil?
    end

    def set(row,col,digit)
      check_arguments(:row => row, :col => col, :digit => digit)

      return if self.value(row,col)==digit

      command = SetCommand.new(@grid[row-1][col-1], digit)
      command.run_after = DeductionCommand.new(self, @empty_cells)
      command.do
      add_command_to_history(command)
    end

    def set?(row,col)
      check_arguments(:row => row, :col => col)

      @grid[row-1][col-1].set?
    end

    def value(row,col)
      check_arguments(:row => row, :col => col)

      @grid[row-1][col-1].value
    end

    def possible?(row,col,digit)
      check_arguments(:row => row, :col => col, :digit => digit)

      @grid[row-1][col-1].possible?(digit)
    end

    def empty?
      1.upto(9) do |row|
        1.upto(9) do |col|
          1.upto(9) do |digit|
            return false unless possible?(row,col,digit)
          end
        end
      end
      return true
    end

    def solve
      stack = []

      while commands = next_step()
        stack.push(commands)

        loop do
          step_possible = while command = stack.last.pop
            begin
              command.do
              add_command_to_history(command)
              break true
            rescue
            next
            end
          end
          if step_possible
          break
          else
            stack.pop
            raise Exception if stack.empty?
            undo
          end
        end
      end
    end

    def solved?
      @empty_cells.empty?
    end

    def to_s
      s = ""
      @grid.each { |row|
        row.each { |cell|
          s += cell.set? ? " #{cell.value} " : " ? "
        }
        s += "\n"
      }
      return s
    end

    # Callback for Cell state change
    def update(row, col)
      cell = @grid[row-1][col-1]
      if cell.set?
        @empty_cells.delete(cell)
        @set_cells << cell unless @set_cells.include?(cell)
      else
        @set_cells.delete(cell)
        @empty_cells << cell unless @empty_cells.include?(cell)
      end
    end

    private
    DIGITS_RANGE = 1..9

    # Utility method to check usual arguments
    def check_arguments(hash)
      if hash.key?(:row) then
        raise ArgumentError, "row (#{hash[:row]}) should range between #{DIGITS_RANGE}", caller unless DIGITS_RANGE === hash[:row]
      end
      if hash.key?(:col) then
        raise ArgumentError, "col (#{hash[:col]}) should range between #{DIGITS_RANGE}", caller unless DIGITS_RANGE === hash[:col]
      end
      if hash.key?(:digit) then
        raise ArgumentError, "digit (#{hash[:digit]}) should range between #{DIGITS_RANGE}", caller unless DIGITS_RANGE === hash[:digit]
      end
    end

    def next_step()
      return nil if @empty_cells.empty?

      # To speed up the process
      @empty_cells.sort! { |a,b| a.nb_alternatives <=> b.nb_alternatives}

      commands = []
      cell = @empty_cells.first
      cell.alternatives.each { |digit|
        command = SetCommand.new(cell, digit)
        command.run_after = DeductionCommand.new(self, @empty_cells)
        commands.insert(0,command)
      }

      # Non deterministic algorithm !
      commands.shuffle!

      return commands
    end
  end
end
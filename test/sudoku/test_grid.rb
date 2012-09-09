module Sudoku
  class TestGrid < Test::Unit::TestCase
    def setup
      @empty = Grid.new
      @row = rand(8)+1
      @col = rand(8)+1
      @digit = rand(8)+1
    end

    def teardown

    end
    
    def test_solve
      grid = Grid.new
      grid.solve
      
      assert(grid.solved?, "The grid should be solved")
    end

    def test_grid1
      @grid1 = Grid[
        [nil,1  ,nil,nil,nil,nil,5  ,9  ,3  ],
        [7  ,nil,nil,5  ,3  ,2  ,nil,nil,nil],
        [3  ,nil,nil,4  ,nil,nil,7  ,nil,nil],
        [nil,5  ,8  ,nil,4  ,nil,nil,6  ,nil],
        [nil,7  ,2  ,nil,9  ,nil,3  ,1  ,nil],
        [nil,4  ,nil,nil,6  ,nil,8  ,5  ,nil],
        [nil,nil,6  ,nil,nil,1  ,nil,nil,5  ],
        [nil,nil,nil,7  ,8  ,4  ,nil,nil,6  ],
        [4  ,9  ,7  ,nil,nil,nil,nil,2  ,nil],
      ]

      refute(@grid1.empty?, "An initialized grid should not be empty")

      assert(@grid1.set?(1,2), "The Cell (1,2) should be set")
      assert(@grid1.set?(2,1), "The Cell (2,1) should be set")
      assert(@grid1.set?(3,1), "The Cell (3,1) should be set")
      assert(@grid1.set?(9,1), "The Cell (1,2) should be set")
      assert(@grid1.set?(3,4), "The Cell (3,4) should be set")
      assert(@grid1.set?(5,2), "The Cell (5,2) should be set")
      assert(@grid1.set?(5,3), "The Cell (5,3) should be set")

      assert(@grid1.solved?, "The Grid should be solved")
    end

    def test_grid2
      @grid2 = Grid[
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil]
      ]

      assert(@grid2.empty?, "This grid should be empty")

      refute(@grid2.solved?, "The Grid should not be solved")
    end

    def test_grid3
      @grid3 = Grid[
        [7  ,nil,2  ,9  ,6  ,nil,8  ,4  ,5  ],
        [8  ,1  ,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [2  ,nil,nil,7  ,3  ,5  ,nil,nil,nil],
        [4  ,7  ,3  ,nil,nil,nil,5  ,8  ,2  ],
        [nil,nil,6  ,8  ,2  ,4  ,nil,nil,9  ],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,2  ,3  ],
        [9  ,2  ,5  ,nil,7  ,8  ,4  ,nil,6  ]
      ]

      refute(@grid3.empty?, "This grid should not be empty")

      assert(@grid3.solved?, "The Grid should be solved")
    end

    def test_grid4
      @grid4 = Grid[
        [8  ,5  ,nil,nil,nil,nil,7  ,nil,nil],
        [nil,nil,nil,8  ,nil,nil,2  ,4  ,1  ],
        [nil,nil,nil,7  ,9  ,2  ,nil,nil,nil],
        [3  ,2  ,1  ,nil,4  ,nil,nil,nil,nil],
        [6  ,nil,nil,nil,5  ,nil,nil,nil,2  ],
        [nil,nil,nil,nil,7  ,nil,6  ,9  ,3  ],
        [nil,nil,nil,5  ,1  ,6  ,nil,nil,nil],
        [7  ,9  ,5  ,nil,nil,3  ,nil,nil,nil],
        [nil,nil,4  ,nil,nil,nil,nil,8  ,5  ]
      ]

      refute(@grid4.empty?, "This grid should not be empty")

      assert(@grid4.solved?, "The Grid should be solved")
    end

    def test_grid5
      @grid5 = Grid[
        [nil,9  ,5  ,nil,4  ,nil,nil,nil,nil],
        [nil,nil,nil,1  ,nil,2  ,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,8  ,7  ,9  ],
        [2  ,nil,4  ,nil,8  ,nil,nil,nil,nil],
        [6  ,nil,nil,nil,1  ,nil,nil,nil,3  ],
        [nil,nil,nil,nil,7  ,nil,4  ,nil,5  ],
        [4  ,3  ,8  ,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,6  ,nil,9  ,nil,nil,nil],
        [nil,nil,nil,nil,3  ,nil,1  ,2  ,nil]
      ]

      refute(@grid5.empty?, "This grid should not be empty")

      assert(@grid5.solved?, "The Grid should be solved")
    end

    def test_empty
      assert(@empty.empty?, "A new grid is empty")
    end

    def test_solved
      refute(@empty.solved?, "An empty grid is not solved yet")
    end

    def test_set?
      1.upto(9) do |row|
        1.upto(9) do |col|
          refute(@empty.set?(row,col), "An empty grid has no set cells")
        end
      end
    end

    def test_possible
      assert(@empty.possible?(@row,@col,@digit), "By default, every digit is possible")

      @empty.set(@row,@col,@digit)
      assert(@empty.possible?(@row,@col,@digit), "#{@digit} should be allowed in cell (#{@row}, #{@col})")
      refute(@empty.possible?(@row % 9 + 1,@col,@digit), "#{@digit} should not be allowed in column #{@col}")
      refute(@empty.possible?(@row,@col % 9 + 1,@digit), "#{@digit} should not be allowed in row #{@row}")
    end

    def test_undo
      @empty.set(1,1,1)
      @empty.set(1,2,3)

      @empty.undo
      assert(@empty.set?(1,1), "Cell (1,1) should be set")
      assert_equal(1,@empty.value(1,1), "Cell (1,1) should be set to 1")
      refute(@empty.set?(1,2), "Cell (1,2) should not be set")

      @empty.undo
      assert(@empty.empty?, "Incoherent state after undo")

      @empty.undo
      @empty.undo
      assert(@empty.empty?, "Incoherent state after undo")

      @empty.redo
      assert(@empty.set?(1,1), "Cell (1,1) should be set")
      assert_equal(1,@empty.value(1,1), "Cell (1,1) should be set to 1")
      refute(@empty.set?(1,2), "Cell (1,2) should not be set")

      @empty.redo
      @empty.redo
      assert(@empty.set?(1,1), "Cell (1,1) should be set")
      assert_equal(1,@empty.value(1,1), "Cell (1,1) should be set to 1")
      assert(@empty.set?(1,2), "Cell (1,2) should be set")
      assert_equal(3,@empty.value(1,2), "Cell (1,2) should be set to 3")
    end

    def test_out_of_range_arguments
      assert_raises(ArgumentError) {@empty.set?(0,4)}
      assert_raises(ArgumentError) {@empty.set?(-9,4)}
      assert_raises(ArgumentError) {@empty.set?(9,10)}
      assert_raises(ArgumentError) {@empty.set?(9,0)}

      assert_raises(ArgumentError) {@empty.set(0,4,40)}
      assert_raises(ArgumentError) {@empty.set(10,4,10)}
      assert_raises(ArgumentError) {@empty.set(2,10,1)}
      assert_raises(ArgumentError) {@empty.set(9,-7,-5)}

      # This one is valid, should not raise any exception
      @empty.set(@row,@col,@digit)
    end

    def test_set
      assert_nil(@empty.value(@row,@col), "The cell (#{@row},#{@col}) should be empty")

      @empty.set(@row,@col,@digit)
      assert(@empty.set?(@row,@col), "The cell (#{@row},#{@col}) has been set to #{@digit} but shows not set")
      assert_equal(@digit, @empty.value(@row,@col), "The cell (#{@row},#{@col}) should be set to #{@digit}")
    end

    def test_multiple_set_same_cell
      @empty.set(@row,@col,3)

      # Should not raise an exception since its the same value
      @empty.set(@row,@col,3)

      assert_raise(Grid::ImpossibleGrid) { @empty.set(@row,@col,2) }
      assert_equal(3, @empty.value(@row,@col), "Cell (#{@row},#{@col}) should not be set to 2")

      @empty.undo
      assert(@empty.empty?, "Actions with errors should not be stored in the action History")
    end

  end
end
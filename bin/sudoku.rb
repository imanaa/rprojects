#!/usr/bin/env ruby
#encoding: utf-8

###############################################################################
# sudoku.rb -- Solve a sudoku game 
# Arguments:
#
#
# Copyright (C) 2012  Imad MANAA
# Last Modified : 13th, September 2012
# Version : 1.0
###############################################################################

require_relative "../lib/rprojects/sudoku"

include Sudoku

grid = Grid[
        [nil,nil,3  ,nil,nil,nil,9  ,nil,nil],
        [nil,nil,nil,9  ,nil,1  ,nil,nil,nil],
        [nil,8  ,5  ,nil,nil,nil,2  ,7  ,nil],
        [nil,2  ,nil,5  ,nil,9  ,nil,4  ,nil],
        [nil,nil,nil,nil,1  ,nil,nil,nil,nil],
        [nil,1  ,nil,4  ,nil,6  ,nil,8  ,nil],
        [nil,7  ,1  ,nil,nil,nil,5  ,9  ,nil],
        [nil,nil,nil,7  ,nil,8  ,nil,nil,nil],
        [nil,nil,4  ,nil,nil,nil,6  ,nil,nil]
      ]
	  
=begin
1.upto(1) do
  line = readline.chomp!.strip!
end
=end

grid.solve
puts grid

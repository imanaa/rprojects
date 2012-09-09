require File.dirname(__FILE__) + '/test_helpers'

include Sudoku

# Require all test files in the sudoku sub_directory
Dir.chdir(File.join(File.dirname(__FILE__),'sudoku')) do
  Dir["test_*.rb"].each do |test_script|
    require File.expand_path(File.join(Dir.getwd, test_script))   
  end
end
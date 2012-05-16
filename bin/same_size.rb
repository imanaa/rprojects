#!/usr/bin/ruby
#encoding: utf-8

###############################################################################
# same_size.rb -- Search For files with the same size
# This program looks for files with the same size
# Arguments:
#   DIRECTORY : The search folder
# PATTERN : The files pattern
#
# Copyright (C) 2010-2012  Imad MANAA
# Last Modified : 28th, March 2011
# Version : 1.0
###############################################################################

require 'optparse'
options = {
  :dir => ".",
  :pattern => "*.*"
}

optparse = OptionParser.new { |opts|
  opts.banner = "Usage: #{$0} [options]"
  opts.define_head "This is a scipt to look for files with the same size"
  opts.set_summary_indent("   ")
  opts.separator "" 
  opts.on( '-d', '--dir <DIRECTORY>', 'Search directory' ) { |directory|
    options[:dir] = directory
  }
  opts.on( '-p', '--pattern <PATTERN>', 'Filename pattern' ) { |pattern|
    options[:pattern] = pattern
  }
  opts.on_tail("-h", "--help", "Show this message") {
        puts opts
    exit
    }
}
optparse.parse!

if ARGV.size != 0
  puts optparse.help
  exit
end

Dir.chdir(options[:dir]) {
  hash = {}
  Dir["**/#{options[:pattern]}*"].each { |filename|
    next if Dir.exists?(filename)
    filesize = File.size(filename)
    if hash.key?(filesize) then
      hash[filesize] << [filename] 
    else
      hash[filesize] = [filename]
    end
  }
  # Clean the hash
  hash.each_pair { |filesize, files|
    next if files.size == 1
    puts "*****************************************************************"
    puts "Files Size: #{filesize}"
    files.each { |filename|
      puts filename
    }
  }
}

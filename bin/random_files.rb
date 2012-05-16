#!/usr/bin/ruby
#encoding: utf-8

###############################################################################
# random_files.rb -- Generating Random Files
# This program generates random content files with a specific size
# Arguments:
#   Size : Size of the File
#   Output : The name of the File
#
# Copyright (C) 2010-2011  Imad MANAA
# Last Modified : 14, August 2011
# Version : 1.0
###############################################################################

require 'digest/md5'
require 'securerandom'

CLI_SYNTAX  = "Syntax: ruby dumb_files.rb [-size number] [-output name] [text]"
filename  = ""
filesize  = 0
is_binary = true
index_arg = 0
while (index_arg < ARGV.size) 
  case ARGV[index_arg]
  when "-size" 
    index_arg = index_arg+1
    if ARGV.size <= index_arg
      STDERR.puts CLI_SYNTAX
      exit
    else
      filesize = ARGV[index_arg].to_f
      index_arg = index_arg+1
    end
  when "-output" 
    index_arg = index_arg+1
    if ARGV.size <= index_arg
      STDERR.puts CLI_SYNTAX
      exit
    else
      filename = ARGV[index_arg]
      index_arg = index_arg+1
    end
  when "text"
    is_binaryis_binaryis_binary  = false
    index_arg = index_arg+1   
  else
    STDERR.puts CLI_SYNTAX
    exit  
  end
end

loop do
  break unless filename=="" 
  print "Enter the name of the file: "
  filename = STDIN.gets.gsub! "\n", ""
end

loop do
  break unless filesize==0
  print "Enter the size of the file in MB: "
  filesize = STDIN.gets.to_f
end 

filesize = (filesize * (1024 ** 2)).to_i
File.open(filename, "w") do |file|
  if is_binary
    file.print SecureRandom.random_bytes(filesize);
  else
    file.print SecureRandom.urlsafe_base64(3*filesize/4);
  end
end # << file automatically closed here

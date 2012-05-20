#!/usr/bin/env ruby
#encoding: utf-8

###############################################################################
# color_info.rb -- Print some useful information of a given color
# Arguments:
#   color : in hexadecimal representation or as three different
#           intergers (R,G,B)
#
# Copyright (C) 2012  Imad MANAA
# Last Modified : 20th, May 2012
# Version : 1.0
###############################################################################

require "rprojects"

include Rprojects

color = case ARGV.size
when 1 then Color.new(ARGV[0])
when 3 then Color.new(ARGV[0].to_i,ARGV[1].to_i,ARGV[2].to_i)
else
  STDERR.puts "Usage: #{$0} { <color_hex> | <color_red> <color_green> <color_blue>}"
  exit
end

puts "Color is RGB(#{color.red},#{color.green},#{color.blue}) = \##{color.to_hex}"
puts "Color name in :"
Color.available_name_sources.each_key { |source|
  puts "\t#{source} : #{color.name(source)} -- #{color.nearest_color(source).to_hex}"
}
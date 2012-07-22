#!/usr/bin/ruby
#encoding: utf-8

###############################################################################
#             Quote of the Day
# Author: Imad Manaa
# Version: 1.0
# Last Updated: 21/04/2011
###############################################################################
require "pp"
require "rexml/document"
include REXML

begin
  filename = File.join(File.dirname(__FILE__),"..","data","citations.xml")
  xmlfile = File.new(filename,"r")
  xmldoc = Document.new(xmlfile)
  # Now get the root element
  root = xmldoc.root
  
  quotes  = root.get_elements "quote"
  index   = rand(quotes.length)
  quote   = quotes[index]
  
  pp quote.text
  puts "\nBy: #{quote.attributes["author"]}"
  
  gets
rescue
 puts "Oops! Error in DOM like parsing"
end
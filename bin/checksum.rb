#!/usr/bin/ruby
#encoding: utf-8

###############################################################################
# checksum.rb -- Print the checksum of a given file
# Arguments:
#   hash : md5 or sha1
#   filename : The file to check
#
# Copyright (C) 2010-2012  Imad MANAA
# Last Modified : 13th, April 2012
# Version : 1.0
###############################################################################

require 'optparse'
require 'digest/md5'
require 'digest/sha1'

# Implementation Class
class Checksum
  attr_reader :digest
  def initialize(digest)
    @digest = digest
  end

  def checksum(filename)
    @digest.reset
    File.open(filename,"rb") { |file|
      file.each { |line| digest << line }
    }
    return digest.hexdigest
  end
end

# Parsing parameters
options = {
  :hash => Digest::MD5.new,            # The default hash
}

optparse = OptionParser.new { |opts|
  opts.banner = "Usage: #{$0} [options] filename"
  opts.define_head "Print the checksum of a given file"
  opts.set_summary_indent("   ")
  opts.separator ""
  opts.on( '-a', '--hash <METHOD>', 'MD5/SHA1 hash' ) { |method|
    method.downcase!
    method.strip!
    options[:hash] = case method
    when "md5" then Digest::MD5.new;
    when "sha1" then Digest::SHA1.new
    else
      STDERR.puts optparse.help
      exit
    end
  }
  opts.on_tail("-h", "--help", "Show this message") {
    STDERR.puts optparse.help
    exit
  }
}
optparse.parse!

if ARGV.size != 1 then
  STDERR.puts optparse.help
  exit
else
  options[:filename] = ARGV[0]
end

obj = Checksum.new(options[:hash])
res = obj.checksum(options[:filename])
res2 = obj.checksum(options[:filename])
puts "#{options[:hash].class}*#{res} \t #{options[:filename]}"
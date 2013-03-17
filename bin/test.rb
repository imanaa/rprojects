require 'base64'
str = "Now is the time for all good coders\nto learn Ruby"
converted = Base64.encode64(str)
puts converted
puts Base64.decode64(converted)
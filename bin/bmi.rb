#!/usr/bin/env ruby

###############################################################################
# Console Application to calculate your Body Mass Index (BMI)
# Read from console: height and weight
#
# A BMI of less than 18 means you are under weight.
# A BMI of less than 18.5 indicates you are thin for your height.
# A BMI between 18.6 and 24.9 you are at a healthy weight.
# A BMI between 25 and 29.9 suggests you are overweight .
# A BMI of 30 or greater indicates obesity. Consider consulting a doctor for
# losing weight.
###############################################################################

print("Please enter your height in centimeters : ")
height = Float(readline().chomp) / 100.0
print("Please enter your wight in kgs : ")
weight = Float(readline().chomp)

bmi = (weight / height**2).abs.round(1)
puts "The Body Mass Index is : #{bmi}"

case bmi
when 0..18
  puts "You are under weight !"
when 18..18.5
  puts "You are thin for your height!"
when 18.6..24.9
  puts "You are at a healthy weight!"
when 25..29.9
  puts "You are overweight for your height!"
else
puts "You are suffering Obesity. Consider consulting a doctor for losing weight"
end
#!/usr/bin/env ruby

$: << './lib'
require 'chompy'

chompy = Chompy.new
chompy.instruction :puts do |*args|
  Kernel.puts *args
end

generator = chompy.generator
code = generator.generate! do
  puts "test"
end

interpreter = chompy.interpreter
interpreter.interpret!(code)

#!/usr/bin/env ruby

$: << './lib'
require 'chompy'

chompy = Chompy.new do
  instruction :puts do |*args|
    Kernel.puts *args
  end
end

code = chompy.generate do
  puts "test"
end

p code

chompy.interpret(code)

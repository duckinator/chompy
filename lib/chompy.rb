require 'chompy/version'
require 'chompy/generator'
require 'chompy/interpreter'

##  Bytecode Syntax
#
#   `[instruction][name length][name][number of arguments][arguments...]`
#
#   `instruction` is a single Unicode character, indicating which
#   instruction to run. This allows up to 1,114,112 instructions.
#
#   `name length` is the length of the instruction name, as single Unicode
#   character.
#
#   `name` is the instruction name.
#
#   `number of arguments` is also a single Unicode character, indicating
#   the number of arguments being passed to the instruction.
#
#   There can be zero or more arguments.
#
### Argument Syntax
#
#   `[argument name length][argument name][argument size][serialized argument]`
#
#   `argument name length` is the length of the string form of the argument name,
#   as a single Unicode character.
#
#   `argument name` is the name of the argument.
#
#   `argument size` is the length of the serialized argument, as a single
#   Unicode character.
#
#   `serialized argument` is the serialized form of the argument.
class Chompy
  attr_accessor :generator_class
  attr_accessor :interpreter_class

  def initialize
    @generator_class   = Class.new(Generator)
    @interpreter_class = Class.new(Interpreter)
  end

  def instruction(name, &block)
    @generator_class.send(:add_command, name, &block)
    @interpreter_class.send(:add_command, name, &block)
  end

  def generator
    generator_class.new
  end

  def interpreter
    interpreter_class.new
  end
end

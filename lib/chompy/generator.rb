require 'chompy/unrecognized_instruction'
require 'stringio'

class Chompy
  class Generator
    @@instructions = []
    @@name_map     = []

    # Generates bytecode from Ruby code.
    def generate!(&block)
      @bytecode = ''
      instance_eval(&block)

      @bytecode
    end

    private
    def __write_instruction(instruction, num_arguments)
      # http://www.ruby-doc.org/core-2.1.2/Array.html#method-i-pack
      @bytecode << [instruction].pack("U")
      @bytecode << [num_arguments].pack("U")
    end

    def __write_argument_name(argument_name)
      argument_name = argument_name.to_s

      @bytecode << [argument_name.length].pack("U")
      @bytecode << argument_name
    end

    def __write_argument(argument)
      serialized_argument = Marshal.dump(argument)

      @bytecode << [serialized_argument.length].pack("U")
      @bytecode << serialized_argument
    end

    def __write_arguments(argument_names, *args)
      args.each_with_index do |argument, i|
        __write_argument_name(argument_names[i])
        __write_argument(argument)
      end
    end

    def self.add_command(command, &block)
      instruction = @@instructions.length
      @@instructions[instruction] = block
      @@name_map[instruction] = command

      # block.parameters is an array of arrays; the second element of
      # each contains the argument name as a symbol.
      arguments = block.parameters.map(&:last).map(&:to_sym)

      # x.inspect[1..-2] gets the string representation, sans quotes.
      arguments_str = arguments.map(&:to_s).join(", ")

      # What this monster does is defines an instance method by the
      # name specified by `command`, which appends the appropriate
      # instruction and values to the bytecode string.
      eval <<-EOF
        def #{command}(#{arguments_str})
          __write_instruction(#{instruction.inspect}, #{arguments.length})
          __write_arguments(#{arguments.inspect}, #{arguments_str})
        end
      EOF
    end
  end
end

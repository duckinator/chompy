require 'chompy/unrecognized_instruction'

class Chompy
  class Interpreter
    @@instructions = []
    @@name_map     = []

    # Takes bytecode and executes it.
    def interpret!(bytecode, file='(string)', line=1)
      @bytecode = bytecode

      execute_instruction! until @bytecode.length.zero?
    end

    private
    def eat_bytecode!(length, &block)
      tmp = @bytecode[0..(length - 1)]

      if block
        tmp = yield(tmp)
      end

      @bytecode = @bytecode[tmp.length..-1]

      tmp
    end

    def unpack_bytecode!(arg)
      eat_bytecode!(arg.length) do |tmp|
        tmp.unpack(arg)
      end
    end

    def execute_instruction!
      instruction, num_arguments = __read_instruction
      name = @@name_map[instruction]

      arguments = __read_arguments(num_arguments)

      puts "Code: #{name}(#{arguments.values.inspect[1..-2]})"
    end

    def __read_instruction
      # http://www.ruby-doc.org/core-2.1.2/Array.html#method-i-pack
      instruction, num_arguments = unpack_bytecode!("UU")

      [instruction, num_arguments]
    end

    def __read_argument_name
      eat_bytecode!(unpack_bytecode!("U").first)
    end

    def __read_argument
      argument_length     = unpack_bytecode!("U").first
      serialized_argument = eat_bytecode!(argument_length)

      Marshal.load(serialized_argument)
    end

    def __read_arguments(num_arguments)
      arguments = {}

      num_arguments.times.map do |i|
        name = __read_argument_name
        arguments[name] = __read_argument
      end

      arguments
    end

    def self.add_command(command, &block)
      instruction = @@instructions.length
      @@instructions[instruction] = block
      @@name_map[instruction] = command
    end
  end
end

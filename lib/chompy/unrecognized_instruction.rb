class Chompy
  class UnrecognizedInstruction < NotImplementedError
    def initialize(bytecode)
      super("unrecognized instruction type #{bytecode.inspect}")
    end
  end
end

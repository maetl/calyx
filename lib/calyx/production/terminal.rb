module Calyx
  module Production
    # A type of production rule that terminates with a resulting string atom.
    class Terminal
      # Construct a terminal node with the given value.
      #
      # @param [#to_s] atom
      def initialize(atom)
        @atom = atom
      end

      # Evaluate the terminal by returning its identity directly.
      #
      # @return [Array]
      def evaluate
        [:atom, @atom]
      end
    end
  end
end

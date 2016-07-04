module Calyx
  module Production
    class Terminal
      # Construct a terminal node with the given value.
      #
      # @param atom [#to_s]
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

module Calyx
  module Production
    # A type of production rule that represents a non-terminal expansion,
    # linking one rule to another.
    class NonTerminal
      # Construct a non-terminal node, given the symbol to lookup and the
      # registry to look it up in.
      #
      # @param symbol [Symbol]
      # @param registry [Calyx::Registry]
      def initialize(symbol, registry)
        @symbol = symbol.to_sym
        @registry = registry
      end

      # Evaluate the non-terminal, using the registry to handle the expansion.
      #
      # @return [Array]
      def evaluate
        [@symbol, @registry.expand(@symbol).evaluate]
      end
    end
  end
end

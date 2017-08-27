module Calyx
  module Production
    # A type of production rule that represents a non-terminal expansion,
    # linking one rule to another.
    class NonTerminal
      # Construct a non-terminal node, given the symbol to lookup and the
      # registry to look it up in.
      #
      # @param [Symbol] symbol
      # @param [Calyx::Registry] registry
      def initialize(symbol, registry)
        @symbol = symbol.to_sym
        @registry = registry
      end

      # Evaluate the non-terminal, using the registry to handle the expansion.
      #
      # @param [Random] random
      # @return [Array]
      def evaluate(random)
        [@symbol, @registry.expand(@symbol).evaluate(random)]
      end
    end
  end
end

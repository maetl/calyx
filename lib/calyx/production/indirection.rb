module Calyx
  module Production
    # A 'variable variable' production rule, where the result of the given rule
    # provides the name of another rule to evaluate.
    class Indirection
      SIGIL = '$'.freeze

      # Construct an indirection rule mapping.
      #
      # @param [Symbol] symbol
      # @param [Calyx::Registry] registry
      def initialize(symbol, registry)
        @symbol = symbol.slice(1, symbol.length-1).to_sym
        @registry = registry
      end

      # Evaluate the indirect rule, using the registry to handle the lookup and
      # expansion.
      #
      # @return [Array]
      def evaluate
        [@symbol, @registry.expand(@symbol).evaluate]
      end
    end
  end
end

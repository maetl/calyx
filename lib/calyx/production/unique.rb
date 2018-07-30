module Calyx
  module Production
    # A type of production rule representing a unique substitution which only
    # returns values that have not previously been selected. The probability
    # that a given rule will be selected increases as more selections are made
    # and the list grows smaller.
    class Unique
      SIGIL = '$'.freeze

      # Construct a unique rule, given the symbol to lookup and the registry
      # to look it up in.
      #
      # @param [Symbol] symbol
      # @param [Calyx::Registry] registry
      def initialize(symbol, registry)
        @symbol = symbol.slice(1, symbol.length-1).to_sym
        @registry = registry
      end

      # Evaluate the unique rule, using the registry to handle the expansion
      # and keep track of previous selections.
      #
      # @param [Calyx::Options] options
      # @return [Array]
      def evaluate(options)
        [@symbol, @registry.unique_expansion(@symbol)]
      end
    end
  end
end

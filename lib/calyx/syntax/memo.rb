module Calyx
  module Syntax
    # A type of production rule representing a memoized subsitution which
    # returns the first value selected on all subsequent lookups.
    class Memo
      SIGIL = '@'.freeze

      # Construct a memoized rule, given the symbol to lookup and the registry
      # to look it up in.
      #
      # @param [Symbol] symbol
      # @param [Calyx::Registry] registry
      def initialize(symbol, registry)
        @symbol = symbol.slice(1, symbol.length-1).to_sym
        @registry = registry
      end

      # Evaluate the memo, using the registry to handle the expansion.
      #
      # @param [Calyx::Options] options
      # @return [Array]
      def evaluate(options)
        [@symbol, @registry.memoize_expansion(@symbol)]
      end
    end
  end
end

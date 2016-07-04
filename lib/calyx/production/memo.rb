module Calyx
  module Production
    class Memo
      SIGIL = '@'.freeze

      # Construct a memoized rule, given the symbol to lookup and the registry
      # to look it up in.
      #
      # @param symbol [Symbol]
      # @param registry [Calyx::Registry]
      def initialize(symbol, registry)
        @symbol = symbol.slice(1, symbol.length-1).to_sym
        @registry = registry
      end

      # Evaluate the memo, using the registry to handle the expansion.
      #
      # @return [Array]
      def evaluate
        [@symbol, @registry.memoize_expansion(@symbol)]
      end
    end
  end
end

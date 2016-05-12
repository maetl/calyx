module Calyx
  module Production
    class NonTerminal
      def initialize(symbol, registry)
        @symbol = symbol.to_sym
        @registry = registry
      end

      def evaluate
        [@symbol, @registry.expand(@symbol).evaluate]
      end
    end
  end
end

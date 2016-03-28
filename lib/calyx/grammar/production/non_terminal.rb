module Calyx
  class Grammar
    module Production
      class NonTerminal
        def initialize(symbol, registry)
          @symbol = symbol.to_sym
          @registry = registry
        end

        def evaluate
          @registry.expand(@symbol).evaluate
        end
      end
    end
  end
end

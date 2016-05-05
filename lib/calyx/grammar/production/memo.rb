module Calyx
  class Grammar
    module Production
      class Memo
        SIGIL = '@'.freeze

        def initialize(symbol, registry)
          @symbol = symbol.slice(1, symbol.length-1).to_sym
          @registry = registry
        end

        def evaluate
          [@symbol, @registry.memoize_expansion(@symbol)]
        end
      end
    end
  end
end

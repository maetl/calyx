module Calyx
  class Grammar
    module Production
      class Expression
        def initialize(production, methods)
          @production = production
          @methods = methods.map { |m| m.to_sym }
        end

        def evaluate
          @methods.reduce(@production.evaluate) do |value,method|
            value.send(method)
          end
        end
      end
    end
  end
end

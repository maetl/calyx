module Calyx
  module Production
    class Expression
      def initialize(production, methods, registry)
        @production = production
        @methods = methods.map { |m| m.to_sym }
        @registry = registry
      end

      def evaluate
        terminal = @production.evaluate.flatten.reject { |o| o.is_a?(Symbol) }.join(''.freeze)
        expression = @methods.reduce(terminal) do |value, method|
          @registry.transform(method, value)
        end

        [:expression, expression]
      end
    end
  end
end

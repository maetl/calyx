module Calyx
  module Production
    class Expression
      def initialize(production, methods)
        @production = production
        @methods = methods.map { |m| m.to_sym }
      end

      def evaluate
        terminal = @production.evaluate.flatten.reject { |o| o.is_a?(Symbol) }.join(''.freeze)
        expression = @methods.reduce(terminal) do |value,method|
          value.send(method)
        end

        [:expression, expression]
      end
    end
  end
end

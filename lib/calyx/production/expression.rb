module Calyx
  module Production
    class Expression
      # Constructs a node representing a single template substitution.
      #
      # @param production [#evaluate]
      # @param methods [Array]
      # @param registry [Calyx::Registry]
      def initialize(production, methods, registry)
        @production = production
        @methods = methods.map { |m| m.to_sym }
        @registry = registry
      end

      # Evaluate the expression by expanding the non-terminal to produce a
      # terminal string, then passing it through the given modifier chain and
      # returning the transformed result.
      #
      # @return [Array]
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

module Calyx
  module Production
    # A type of production rule representing a single template substitution.
    class Expression
      # Constructs a node representing a single template substitution.
      #
      # @param [#evaluate] production
      # @param [Array] methods
      # @param [Calyx::Registry] registry
      def initialize(production, methods, registry)
        @production = production
        @methods = methods.map { |m| m.to_sym }
        @registry = registry
      end

      # Evaluate the expression by expanding the non-terminal to produce a
      # terminal string, then passing it through the given modifier chain and
      # returning the transformed result.
      #
      # @param [Random] random
      # @return [Array]
      def evaluate(random)
        terminal = @production.evaluate(random).flatten.reject { |o| o.is_a?(Symbol) }.join(''.freeze)
        expression = @methods.reduce(terminal) do |value, method|
          @registry.transform(method, value)
        end

        [:expression, expression]
      end
    end
  end
end

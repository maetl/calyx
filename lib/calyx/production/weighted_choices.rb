module Calyx
  module Production
    class WeightedChoices
      def self.parse(productions, registry)
        weights_sum = productions.reduce(0) do |memo, choice|
          memo += choice.last
        end

        raise 'Weights must sum to 1' if weights_sum != 1.0

        choices = productions.map do |choice, weight|
          if choice.is_a?(String)
            [Concat.parse(choice, registry), weight]
          elsif choice.is_a?(Symbol)
            [NonTerminal.new(choice, registry), weight]
          end
        end

        self.new(choices)
      end

      def initialize(collection)
        @collection = collection
      end

      def evaluate
        choice = @collection.max_by do |_, weight|
          rand ** (1.0 / weight)
        end.first

        [:weighted_choice, choice.evaluate]
      end
    end
  end
end

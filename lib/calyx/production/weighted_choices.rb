module Calyx
  module Production
    class WeightedChoices
      # Parse a given list or hash of productions into a syntax tree of weighted
      # choices.
      #
      # @param productions [Array<Array>, Hash<#to_s, Float>]
      # @param registry [Calyx::Registry]
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

      # Initialize a new choice with a list of child nodes.
      #
      # @param collection [Array]
      def initialize(collection)
        @collection = collection
      end

      # Evaluate the choice by randomly picking one of its possible options,
      # balanced according to the given weights.
      #
      # The method for selecting weighted probabilities is based on a snippet
      # of code recommended in the Ruby standard library documentation.
      #
      # @return [Array]
      def evaluate
        choice = @collection.max_by do |_, weight|
          rand ** (1.0 / weight)
        end.first

        [:weighted_choice, choice.evaluate]
      end
    end
  end
end

module Calyx
  module Production
    # A type of production rule representing a map of possible rules with
    # associated weights that define the expected probability of a rule
    # being chosen.
    class WeightedChoices
      # Parse a given list or hash of productions into a syntax tree of weighted
      # choices.
      #
      # @param [Array<Array>, Hash<#to_s, Float>] productions
      # @param [Calyx::Registry] registry
      def self.parse(productions, registry)
        weights_sum = productions.reduce(0) do |memo, choice|
          memo += choice.last
        end

        raise Errors::InvalidDefinition, 'Weights must sum to 1' if weights_sum != 1.0

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
      # @param [Array] collection
      def initialize(collection)
        @collection = collection
      end

      # Evaluate the choice by randomly picking one of its possible options,
      # balanced according to the given weights.
      #
      # The method for selecting weighted probabilities is based on a snippet
      # of code recommended in the Ruby standard library documentation.
      #
      # @param [Random] random
      # @return [Array]
      def evaluate(random)
        choice = @collection.max_by do |_, weight|
          random.rand ** (1.0 / weight)
        end.first

        [:weighted_choice, choice.evaluate(random)]
      end
    end
  end
end

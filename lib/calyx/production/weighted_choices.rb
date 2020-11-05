module Calyx
  module Production
    # A type of production rule representing a map of possible rules with
    # associated weights that define the expected probability of a rule
    # being chosen.
    class WeightedChoices
      # Parse a given list or hash of productions into a syntax tree of weighted
      # choices. Supports weights specified as Range, Fixnum and Float types.
      #
      # All weights get normalized to a set of values in the 0..1 interval that
      # sum to 1.
      #
      # @param [Array<Array>, Hash<#to_s, Float>] productions
      # @param [Calyx::Registry] registry
      # @return [Calyx::Production::WeightedChoices]
      def self.parse(productions, registry)
        if productions.first.last.is_a?(Range)
          range_max = productions.max { |a,b| a.last.max <=> b.last.max }.last.max

          weights_sum = productions.reduce(0) do |memo, choice|
            memo += choice.last.size
          end

          if range_max != weights_sum
            raise Errors::InvalidDefinition, "Weights must sum to total: #{range_max}"
          end

          normalized_productions = productions.map do |choice|
            weight = choice.last.size / range_max.to_f
            [choice.first, weight]
          end
        else
          weights_sum = productions.reduce(0) do |memo, choice|
            memo += choice.last
          end

          if productions.first.last.is_a?(Float)
            raise Errors::InvalidDefinition, 'Weights must sum to 1' if weights_sum != 1.0
            normalized_productions = productions
          else
            normalized_productions = productions.map do |choice|
              weight = choice.last.to_f / weights_sum.to_f * 1.0
              [choice.first, weight]
            end
          end
        end

        choices = normalized_productions.map do |choice, weight|
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

      # The number of possible choices available for this rule.
      #
      # @return [Integer]
      def size
        @collection.size
      end

      # Evaluate the choice by randomly picking one of its possible options,
      # balanced according to the given weights.
      #
      # The method for selecting weighted probabilities is based on a snippet
      # of code recommended in the Ruby standard library documentation.
      #
      # @param [Calyx::Options] options
      # @return [Array]
      def evaluate(options)
        choice = @collection.max_by do |_, weight|
          options.rand ** (1.0 / weight)
        end.first

        [:weighted_choice, choice.evaluate(options)]
      end
    end
  end
end

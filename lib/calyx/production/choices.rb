module Calyx
  # A type of production rule representing a list of possible rules, one of
  # which will chosen each time the grammar runs.
  module Production
    class Choices
      # Parse a list of productions and return a choice node which is the head
      # of a syntax tree of child nodes.
      #
      # @param [Array] productions
      # @param [Calyx::Registry] registry
      def self.parse(productions, registry)
        choices = productions.map do |choice|
          if choice.is_a?(String)
            Concat.parse(choice, registry)
          elsif choice.is_a?(Integer)
            Terminal.new(choice.to_s)
          elsif choice.is_a?(Symbol)
            if choice[0] == Memo::SIGIL
              Memo.new(choice, registry)
            elsif choice[0] == Unique::SIGIL
              Unique.new(choice, registry)
            else
              NonTerminal.new(choice, registry)
            end
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

      # Evaluate the choice by randomly picking one of its possible options.
      #
      # @param [Calyx::Options] options
      # @return [Array]
      def evaluate(options)
        [:choice, @collection.sample(random: options.rng).evaluate(options)]
      end
    end
  end
end

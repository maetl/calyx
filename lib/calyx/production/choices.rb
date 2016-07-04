module Calyx
  module Production
    class Choices
      # Parse a list of productions and return a choice node which is the head
      # of a syntax tree of child nodes.
      #
      # @param productions [Array]
      # @param registry [Calyx::Registry]
      def self.parse(productions, registry)
        choices = productions.map do |choice|
          if choice.is_a?(String)
            Concat.parse(choice, registry)
          elsif choice.is_a?(Fixnum)
            Terminal.new(choice.to_s)
          elsif choice.is_a?(Symbol)
            if choice[0] == Memo::SIGIL
              Memo.new(choice, registry)
            else
              NonTerminal.new(choice, registry)
            end
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

      # Evaluate the choice by randomly picking one of its possible options.
      #
      # @return [Array]
      def evaluate
        [:choice, @collection.sample.evaluate]
      end
    end
  end
end

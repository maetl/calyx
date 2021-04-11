module Calyx
  module Syntax
    # A type of production rule representing a string combining both template
    # substitutions and raw content.
    class Concat
      EXPRESSION = /(\{[A-Za-z0-9_@$<>\.]+\})/.freeze
      DEREF_OP = /([<>\.])/.freeze
      START_TOKEN = '{'.freeze
      END_TOKEN = '}'.freeze

      # Parses an interpolated string into fragments combining terminal strings
      # and non-terminal rules.
      #
      # Returns a concat node which is the head of a tree of child nodes.
      #
      # @param [String] production
      # @param [Calyx::Registry] registry
      def self.parse(production, registry)
        expressions = production.split(EXPRESSION).map do |atom|
          if atom.is_a?(String)
            if atom.chars.first == START_TOKEN && atom.chars.last == END_TOKEN
              head, *tail = atom.slice(1, atom.length-2).split(DEREF_OP)
              if tail.any?
                ExpressionChain.parse(head, tail, registry)
              else
                Expression.parse(head, registry)
              end
            else
              Terminal.new(atom)
            end
          end
        end

        self.new(expressions)
      end

      # Initialize the concat node with an expansion of terminal and
      # non-terminal fragments.
      #
      # @param [Array] expansion
      def initialize(expressions)
        @expressions = expressions
      end

      # Evaluate all the child nodes of this node and concatenate each expansion
      # together into a single result.
      #
      # @param [Calyx::Options] options
      # @return [Array]
      def evaluate(options)
        expansion = @expressions.reduce([]) do |exp, atom|
          exp << atom.evaluate(options)
        end

        #[:expansion, expansion]
        # TODO: fix this along with a git rename
        # Commented out because of a lot of tests depending on :concat symbol
        [:concat, expansion]
      end
    end
  end
end

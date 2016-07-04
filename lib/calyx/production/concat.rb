module Calyx
  module Production
    class Concat
      EXPRESSION = /(\{[A-Za-z0-9_@\.]+\})/.freeze
      START_TOKEN = '{'.freeze
      END_TOKEN = '}'.freeze
      DEREF_TOKEN = '.'.freeze

      # Parses an interpolated string into fragments combining terminal strings
      # and non-terminal rules.
      #
      # Returns a concat node which is the head of a tree of child nodes.
      #
      # @param production [String]
      # @param registry [Calyx::Registry]
      def self.parse(production, registry)
        expansion = production.split(EXPRESSION).map do |atom|
          if atom.is_a?(String)
            if atom.chars.first == START_TOKEN && atom.chars.last == END_TOKEN
              head, *tail = atom.slice(1, atom.length-2).split(DEREF_TOKEN)
              if head[0] == Memo::SIGIL
                rule = Memo.new(head, registry)
              else
                rule = NonTerminal.new(head, registry)
              end
              unless tail.empty?
                Expression.new(rule, tail, registry)
              else
                rule
              end
            else
              Terminal.new(atom)
            end
          end
        end

        self.new(expansion)
      end

      # Initialize the concat node with an expansion of terminal and
      # non-terminal fragments.
      #
      # @param expansion [Array]
      def initialize(expansion)
        @expansion = expansion
      end

      # Evaluate all the child nodes of this node and concatenate them together
      # into a single result.
      #
      # @return [Array]
      def evaluate
        concat = @expansion.reduce([]) do |exp, atom|
          exp << atom.evaluate
        end

        [:concat, concat]
      end
    end
  end
end

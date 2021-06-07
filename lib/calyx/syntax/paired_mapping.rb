module Calyx
  module Syntax
    # A type of production rule representing a bidirectional dictionary of
    # mapping pairs that can be used as a substitution table in template
    # expressions.
    class PairedMapping
      def self.parse(productions, registry)
        # TODO: handle wildcard expressions
        self.new(productions)
      end

      # %es
      # prefix: nil, suffix: 'es'
      # match: 'buses' -> ends_with(suffix)

      # %y
      # prefix: nil, suffix: 'ies'

      def initialize(mapping)
        @lhs_index = PrefixTree.new
        @rhs_index = PrefixTree.new

        @lhs_list = mapping.keys
        @rhs_list = mapping.values

        @lhs_index.add_all(@lhs_list)
        @rhs_index.add_all(@rhs_list)
      end

      def value_for(key)
        match = @lhs_index.lookup(key)
        result = @rhs_list[match.index]

        if match.captured
          result.sub("%", match.captured)
        else
          result
        end
      end

      def key_for(value)
        match = @rhs_index.lookup(value)
        result = @lhs_list[match.index]

        if match.captured
          result.sub("%", match.captured)
        else
          result
        end
      end
    end
  end
end

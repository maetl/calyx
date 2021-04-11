module Calyx
  # A type of production rule representing a bidirectional dictionary of
  # mapping pairs that can be used as a substitution table in template
  # expressions.
  module Syntax
    class PairedMapping
      def self.parse(productions, registry)
        # TODO: handle wildcard expressions
        self.new(productions)
      end

      def initialize(mapping)
        @mapping_keys = mapping.keys
        @mapping_values = mapping.values
      end

      def value_for(key)
        @mapping_values[@mapping_keys.index(key)]
      end

      def key_for(value)
        @mapping_keys[@mapping_values.index(value)]
      end
    end
  end
end

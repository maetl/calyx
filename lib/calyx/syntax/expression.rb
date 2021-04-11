module Calyx
  module Syntax
    # A symbolic expression representing a single template substitution.
    class Expression
      def self.parse(symbol, registry)
        if symbol[0] == Memo::SIGIL
          Memo.new(symbol, registry)
        elsif symbol[0] == Unique::SIGIL
          Unique.new(symbol, registry)
        else
          NonTerminal.new(symbol, registry)
        end
      end
    end

    class Modifier < Struct.new(:type, :name, :map_dir)
      def self.filter(name)
        new(:filter, name, nil)
      end

      def self.map_left(name)
        new(:map, name, :left)
      end

      def self.map_right(name)
        new(:map, name, :right)
      end
    end

    # Handles filter chains that symbolic expressions can pass through to
    # generate a custom substitution.
    class ExpressionChain
      def self.parse(production, production_chain, registry)
        modifier_chain = production_chain.each_slice(2).map do |op_token, target|
          rule = target.to_sym
          case op_token
          when Token::EXPR_FILTER then Modifier.filter(rule)
          when Token::EXPR_MAP_LEFT then Modifier.map_left(rule)
          when Token::EXPR_MAP_RIGHT then Modifier.map_right(rule)
          else
            # Should not end up here because the regex excludes it but this
            # could be a place to add a helpful parse error on any weird
            # chars used by the expression—current behaviour is to pass
            # the broken expression through to the result as part of the
            # text, as if that is what the author meant.
            raise("unreachable")
          end
        end

        expression = Expression.parse(production, registry)

        self.new(expression, modifier_chain, registry)
      end

      # @param [#evaluate] production
      # @param [Array] modifiers
      # @param [Calyx::Registry] registry
      def initialize(production, modifiers, registry)
        @production = production
        @modifiers = modifiers
        @registry = registry
      end

      # Evaluate the expression by expanding the non-terminal to produce a
      # terminal string, then passing it through the given modifier chain and
      # returning the transformed result.
      #
      # @param [Calyx::Options] options
      # @return [Array]
      def evaluate(options)
        expanded = @production.evaluate(options).flatten.reject { |o| o.is_a?(Symbol) }.join
        chain = []

        expression = @modifiers.reduce(expanded) do |value, modifier|
          case modifier.type
          when :filter
            @registry.expand_filter(modifier.name, value)
          when :map
            @registry.expand_map(modifier.name, value, modifier.map_dir)
          end
        end

        [:expression, expression]
      end
    end
  end
end

module Calyx
  class Grammar
    class Registry
      attr_reader :rules

      def initialize
        @rules = {}
      end

      def method_missing(name, *arguments)
        rule(name, *arguments)
      end

      def rule(name, *productions, &production)
        @rules[name.to_sym] = construct_rule(productions)
      end

      def expand(symbol)
        @rules[symbol]
      end

      def combine(registry)
        @rules = rules.merge(registry.rules)
      end

      def evaluate(start_symbol=:start, context={})
        duplicate_registry = Marshal.load(Marshal.dump(self))
        duplicate_rules = duplicate_registry.rules
        context.each do |key, value|
          if duplicate_rules.key?(key.to_sym)
            raise "Rule already declared in grammar: #{key}"
          end

          duplicate_rules[key.to_sym] = if value.is_a?(Array)
            Production::Choices.parse(value, duplicate_registry)
          else
            Production::Concat.parse(value.to_s, duplicate_registry)
          end
        end

        duplicate_rules[start_symbol].evaluate
      end

      private

      def construct_rule(productions)
        if productions.first.is_a?(Enumerable)
          Production::WeightedChoices.parse(productions, self)
        else
          Production::Choices.parse(productions, self)
        end
      end
    end
  end
end

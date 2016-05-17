module Calyx
  class Registry
    attr_reader :rules

    def initialize
      @rules = {}
    end

    def method_missing(name, *arguments)
      rule(name, *arguments)
    end

    def rule(name, *productions, &production)
      rules[name.to_sym] = construct_rule(productions)
    end

    def expand(symbol)
      rules[symbol] || context[symbol]
    end

    def memoize_expansion(symbol)
      memos[symbol] ||= expand(symbol).evaluate
    end

    def combine(registry)
      @rules = rules.merge(registry.rules)
    end

    def evaluate(start_symbol=:start, rules_map={})
      reset_evaluation_context

      rules_map.each do |key, value|
        if rules.key?(key.to_sym)
          raise "Rule already declared in grammar: #{key}"
        end

        context[key.to_sym] = if value.is_a?(Array)
          Production::Choices.parse(value, self)
        else
          Production::Concat.parse(value.to_s, self)
        end
      end

      expansion = expand(start_symbol)

      if expansion.respond_to?(:evaluate)
        [start_symbol, expansion.evaluate]
      else
        raise RuleNotFound.new(start_symbol)
      end
    end

    private

    attr_reader :memos, :context

    def reset_evaluation_context
      @context = {}
      @memos = {}
    end

    def construct_rule(productions)
      if productions.first.is_a?(Enumerable)
        Production::WeightedChoices.parse(productions, self)
      else
        Production::Choices.parse(productions, self)
      end
    end
  end
end
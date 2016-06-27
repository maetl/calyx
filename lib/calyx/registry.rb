module Calyx
  class Registry
    attr_reader :rules, :transforms, :modifiers

    def initialize
      @rules = {}
      @transforms = {}
      @modifiers = Modifiers.new
    end

    def method_missing(name, *arguments)
      rule(name, *arguments)
    end

    def modifier(name)
      modifiers.extend_with(name)
    end

    def mapping(name, pairs)
      transforms[name.to_sym] = construct_mapping(pairs)
    end

    def filter(name, callable=nil, &block)
      if block_given?
        transforms[name.to_sym] = block
      else
        transforms[name.to_sym] = callable
      end
    end

    def rule(name, *productions)
      rules[name.to_sym] = construct_rule(productions)
    end

    def expand(symbol)
      rules[symbol] || context[symbol]
    end

    def transform(name, value)
      if transforms.key?(name)
        transforms[name].call(value)
      else
        modifiers.transform(name, value)
      end
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
          raise Error::DuplicateRule.new(key)
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
        raise Errors::RuleNotFound.new(start_symbol)
      end
    end

    private

    attr_reader :memos, :context

    def reset_evaluation_context
      @context = {}
      @memos = {}
    end

    def construct_mapping(pairs)
      mapper = -> (input) {
        match, target = pairs.detect { |match, target| input =~ match }
        input.gsub(match, target)
      }
    end

    def construct_rule(productions)
      if productions.first.is_a?(Hash)
        Production::WeightedChoices.parse(productions.first.to_a, self)
      elsif productions.first.is_a?(Enumerable)
        Production::WeightedChoices.parse(productions, self)
      else
        Production::Choices.parse(productions, self)
      end
    end
  end
end

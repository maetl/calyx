module Calyx
  # Lookup table of all the available rules in the grammar.
  class Registry
    attr_reader :rules, :transforms, :modifiers

    # Construct an empty registry.
    def initialize
      @rules = {}
      @transforms = {}
      @modifiers = Modifiers.new
    end

    # Hook for defining rules without explicitly calling the `#rule` method.
    #
    # @param [Symbol] name
    # @param [Array] productions
    def method_missing(name, *arguments)
      rule(name, *arguments)
    end

    # Attaches a modifier module to this instance.
    #
    # @param [Module] module_name
    def modifier(name)
      modifiers.extend(name)
    end

    # Registers a paired mapping regex.
    #
    # @param [Symbol] name
    # @param [Hash<Regex,String>] pairs
    def mapping(name, pairs)
      transforms[name.to_sym] = construct_mapping(pairs)
    end

    # Registers the given block as a string filter.
    #
    # @param [Symbol] name
    # @block block with a single string argument returning a modified string.
    def filter(name, callable=nil, &block)
      if block_given?
        transforms[name.to_sym] = block
      else
        transforms[name.to_sym] = callable
      end
    end

    # Registers a new grammar rule.
    #
    # @param [Symbol] name
    # @param [Array] productions
    def rule(name, *productions)
      rules[name.to_sym] = construct_rule(productions)
    end

    # Expands the given rule symbol to its production.
    #
    # @param [Symbol] symbol
    def expand(symbol)
      rules[symbol] || context[symbol]
    end

    # Applies the given modifier function to the given value to transform it.
    #
    # @param [Symbol] name
    # @param [String] value
    # @return [String]
    def transform(name, value)
      if transforms.key?(name)
        transforms[name].call(value)
      else
        modifiers.transform(name, value)
      end
    end

    # Expands a memoized rule symbol by evaluating it and storing the result
    # for later.
    #
    # @param [Symbol] symbol
    def memoize_expansion(symbol)
      memos[symbol] ||= expand(symbol).evaluate(@random)
    end

    # Expands a unique rule symbol by evaluating it and checking that it hasn't
    # previously been selected.
    #
    # @param [Symbol] symbol
    def unique_expansion(symbol)
      pending = true
      uniques[symbol] = [] if uniques[symbol].nil?

      while pending
        result = expand(symbol).evaluate(@random)

        unless uniques[symbol].include?(result)
          uniques[symbol] << result
          pending = false
        end
      end

      result
    end

    # Merges the given registry instance with the target registry.
    #
    # This is only needed at compile time, so that child classes can easily
    # inherit the set of rules decared by their parent.
    #
    # @param [Calyx::Registry] registry
    def combine(registry)
      @rules = rules.merge(registry.rules)
    end

    # Evaluates the grammar defined in this registry, combining it with rules
    # from the passed in context.
    #
    # Produces a syntax tree of nested list nodes.
    #
    # @param [Symbol] start_symbol
    # @param [Random] random
    # @param [Hash] rules_map
    # @return [Array]
    def evaluate(start_symbol=:start, random=Random.new, rules_map={})
      reset_evaluation_context(random)

      rules_map.each do |key, value|
        if rules.key?(key.to_sym)
          raise Errors::DuplicateRule.new(key)
        end

        context[key.to_sym] = if value.is_a?(Array)
          Production::Choices.parse(value, self)
        else
          Production::Concat.parse(value.to_s, self)
        end
      end

      expansion = expand(start_symbol)

      if expansion.respond_to?(:evaluate)
        [start_symbol, expansion.evaluate(random)]
      else
        raise Errors::MissingRule.new(start_symbol)
      end
    end

    private

    attr_reader :random, :memos, :context, :uniques

    def reset_evaluation_context(random)
      @random = random
      @context = {}
      @memos = {}
      @uniques = {}
    end

    def construct_mapping(pairs)
      mapper = -> (input) {
        match, target = pairs.detect { |match, target| input =~ match }

        if match && target
          input.gsub(match, target)
        else
          input
        end
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

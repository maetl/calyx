module Calyx
  # Lookup table of all the available rules in the grammar.
  class Registry
    attr_reader :rules, :transforms, :modifiers

    # Construct an empty registry.
    def initialize
      @options = Options.new({})
      @rules = {}
      @transforms = {}
      @modifiers = Modifiers.new
    end

    # Applies additional config options to this instance.
    #
    # @param [Options] opts
    def options(opts)
      @options = @options.merge(opts)
    end

    # Attaches a modifier module to this instance.
    #
    # @param [Module] name
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
    # @yield [String]
    # @yieldreturn [String]
    def filter(name, callable=nil, &block)
      if block_given?
        transforms[name.to_sym] = block
      else
        transforms[name.to_sym] = callable
      end
    end

    # Registers a new grammar rule without explicitly calling the `#rule` method.
    #
    # @param [Symbol] name
    # @param [Array] productions
    def method_missing(name, *productions)
      define_rule(name, caller_locations.first, productions)
    end

    # Registers a new grammar rule.
    #
    # @param [Symbol] name
    # @param [Array] productions
    def rule(name, *productions)
      define_rule(name, caller_locations.first, productions)
    end

    # Defines a static rule in the grammar.
    #
    # @param [Symbol] name
    # @param [Array] productions
    def define_rule(name, trace, productions)
      rules[name.to_sym] = Rule.new(name.to_sym, construct_rule(productions), trace)
    end

    # Defines a rule in the temporary evaluation context.
    #
    # @param [Symbol] name
    # @param [Array] productions
    def define_context_rule(name, trace, productions)
      productions = [productions] unless productions.is_a?(Enumerable)
      context[name.to_sym] = Rule.new(name.to_sym, construct_rule(productions), trace)
    end

    # Expands the given symbol to its rule.
    #
    # @param [Symbol] symbol
    # @return [Calyx::Rule]
    def expand(symbol)
      expansion = rules[symbol] || context[symbol]

      if expansion.nil?
        if @options.strict?
          raise Errors::UndefinedRule.new(@last_expansion, symbol)
        else
          expansion = Production::Terminal.new('')
        end
      end

      @last_expansion = expansion
      expansion
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
      memos[symbol] ||= expand(symbol).evaluate(@options)
    end

    # Expands a unique rule symbol by evaluating it and checking that it hasn't
    # previously been selected.
    #
    # @param [Symbol] symbol
    def unique_expansion(symbol)
      pending = true
      uniques[symbol] = [] if uniques[symbol].nil?

      while pending
        if uniques[symbol].size == @rules[symbol].size
          uniques[symbol] = []
          pending = false
        end

        result = expand(symbol).evaluate(@options)

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
    # @param [Hash] rules_map
    # @return [Array]
    def evaluate(start_symbol=:start, rules_map={})
      reset_evaluation_context

      rules_map.each do |key, value|
        if rules.key?(key.to_sym)
          raise Errors::DuplicateRule.new(key)
        end

        define_context_rule(key, caller_locations.last, value)
      end

      [start_symbol, expand(start_symbol).evaluate(@options)]
    end

    private

    attr_reader :memos, :context, :uniques

    def reset_evaluation_context
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

module Calyx
  # The main public interface to Calyx. Grammars represent the concept of a
  # template grammar defined by a set of production rules that can be chained
  # and nested from a given starting rule.
  #
  # Calyx works like a traditional phrase-structured grammar in reverse. Instead
  # of recognising strings based on a union of possible matches, it generates
  # strings by representing the union as a choice and randomly picking one
  # of the options each time the grammar runs.
  class Grammar
    class << self
      # Access the registry belonging to this grammar class.
      #
      # Constructs a new registry if it isn't already available.
      #
      # @return [Calyx::Registry]
      def registry
        @registry ||= Registry.new
      end

      # Load a grammar instance from the given file.
      #
      # Accepts a JSON or YAML file path, identified by its extension (`.json`
      # or `.yml`).
      #
      # @param [String] filename
      # @return [Calyx::Grammar]
      def load(filename)
        Format.load(filename)
      end

      # DSL helper method for registering a modifier module with the grammar.
      #
      # @param [Module] module_name
      def modifier(module_name)
        registry.modifier(module_name)
      end

      # DSL helper method for registering a paired mapping regex.
      #
      # @param [Symbol] name
      # @param [Hash<Regex,String>] pairs
      def mapping(name, pairs)
        registry.mapping(name, pairs)
      end

      # DSL helper method for registering the given block as a string filter.
      #
      # @param [Symbol] name
      # @block block with a single string argument returning a modified string.
      def filter(name, &block)
        registry.filter(name, &block)
      end

      # DSL helper method for registering a new grammar rule.
      #
      # Not usually used directly, as the method missing API is less verbose.
      #
      # @param [Symbol] name
      # @param [Array] productions
      def rule(name, *productions)
        registry.rule(name, *productions)
      end

      # Augument the grammar with a method missing hook that treats class
      # method calls as declarations of a new rule.
      #
      # This must be bypassed by calling `#rule` directly if the name of the
      # desired rule clashes with an existing helper method.
      #
      # @param [Symbol] name
      # @param [Array] productions
      def method_missing(name, *productions)
        registry.rule(name, *productions)
      end

      # Hook for combining the registry of a parent grammar into the child that
      # inherits from it.
      #
      # @param [Calyx::Registry] child_registry
      def inherit_registry(child_registry)
        registry.combine(child_registry) unless child_registry.nil?
      end

      # Hook for combining the rules from a parent grammar into the child that
      # inherits from it.
      #
      # This is automatically called by the Ruby engine.
      #
      # @param [Class] subclass
      def inherited(subclass)
        subclass.inherit_registry(registry)
      end
    end

    # Create a new grammar instance, passing in a random seed if needed.
    #
    # Grammar rules can be constructed on the fly when the passed-in block is
    # evaluated.
    #
    # @param [Numeric, Random] random
    def initialize(random=Random.new, &block)
      if random.is_a?(Numeric)
        @random = Random.new(random)
      else
        @random = random
      end

      if block_given?
        @registry = Registry.new
        @registry.instance_eval(&block)
      else
        @registry = self.class.registry
      end
    end

    # Produces a string as an output of the grammar.
    #
    # @overload
    #   @param [Symbol] start_symbol
    #   @param [Hash] rules_map
    # @return [String]
    def generate(*args)
      start_symbol, rules_map = map_default_args(*args)

      @registry.evaluate(start_symbol, @random, rules_map).flatten.reject do |obj|
        obj.is_a?(Symbol)
      end.join(''.freeze)
    end

    # Produces a syntax tree of nested list nodes as an output of the grammar.
    #
    # @overload
    #   @param [Symbol] start_symbol
    #   @param [Hash] rules_map
    # @return [Array]
    def evaluate(*args)
      start_symbol, rules_map = map_default_args(*args)

      @registry.evaluate(start_symbol, @random, rules_map)
    end

    private

    def map_default_args(*args)
      start_symbol = :start
      rules_map = {}

      args.each do |arg|
        start_symbol = arg if arg.class == Symbol
        rules_map = arg if arg.class == Hash
      end

      [start_symbol, rules_map]
    end
  end
end

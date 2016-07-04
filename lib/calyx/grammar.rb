module Calyx
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
      # @param filename [String]
      # @return [Calyx::Grammar]
      def load(filename)
        Format.load(filename)
      end

      # DSL helper method for registering a modifier module with the grammar.
      #
      # @param module_name [Module]
      def modifier(module_name)
        registry.modifier(module_name)
      end

      # DSL helper method for registering a paired mapping regex.
      #
      # @param name [Symbol]
      # @param pairs [Hash<Regex,String>]
      def mapping(name, pairs)
        registry.mapping(name, pairs)
      end

      # DSL helper method for registering the given block as a string filter.
      #
      # @param name [Symbol]
      # @block block with a single string argument returning a modified string.
      def filter(name, &block)
        registry.mapping(name, &block)
      end

      # DSL helper method for registering a new grammar rule.
      #
      # Not usually used directly, as the method missing API is less verbose.
      #
      # @param name [Symbol]
      # @param productions [Array]
      def rule(name, *productions)
        registry.rule(name, *productions)
      end

      # Augument the grammar with a method missing hook that treats class
      # method calls as declarations of a new rule.
      #
      # This must be bypassed by calling `#rule` directly if the name of the
      # desired rule clashes with an existing helper method.
      #
      # @param name [Symbol]
      # @param productions [Array]
      def method_missing(name, *productions)
        registry.rule(name, *productions)
      end

      # Hook for combining the registry of a parent grammar into the child that
      # inherits from it.
      #
      # @param child_registry [Calyx::Registry]
      def inherit_registry(child_registry)
        registry.combine(child_registry) unless child_registry.nil?
      end

      # Hook for combining the rules from a parent grammar into the child that
      # inherits from it.
      #
      # This is automatically called by the Ruby engine.
      #
      # @param subclass [Class]
      def inherited(subclass)
        subclass.inherit_registry(registry)
      end
    end

    # Create a new grammar instance, passing in a random seed if needed.
    #
    # Grammar rules can be constructed on the fly when the passed-in block is
    # evaluated.
    #
    # @param seed [Number]
    def initialize(seed=nil, &block)
      @seed = seed || Random.new_seed
      srand(@seed)

      if block_given?
        @registry = Registry.new
        @registry.instance_eval(&block)
      else
        @registry = self.class.registry
      end
    end

    # Produces a string as an output of the grammar.
    #
    # @param start_symbol [Symbol]
    # @param rules_map [Hash]
    # @return [String]
    def generate(*args)
      start_symbol, rules_map = map_default_args(*args)

      @registry.evaluate(start_symbol, rules_map).flatten.reject do |obj|
        obj.is_a?(Symbol)
      end.join(''.freeze)
    end

    # Produces a syntax tree of nested list nodes as an output of the grammar.
    #
    # @param start_symbol [Symbol]
    # @param rules_map [Hash]
    # @return [Array]
    def evaluate(*args)
      start_symbol, rules_map = map_default_args(*args)

      @registry.evaluate(start_symbol, rules_map)
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

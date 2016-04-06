module Calyx
  class Grammar
    class << self
      def registry
        @registry ||= Registry.new
      end

      def rule(name, *productions, &production)
        registry.rule(name, *productions)
      end

      def method_missing(name, *productions)
        registry.rule(name, *productions)
      end

      def inherit_registry(child_registry)
        registry.combine(child_registry) unless child_registry.nil?
      end

      def inherited(subclass)
        subclass.inherit_registry(registry)
      end
    end

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

    def generate(*args)
      start_symbol = :start
      rules_map = {}

      args.each do |arg|
        start_symbol = arg if arg.class == Symbol
        rules_map = arg if arg.class == Hash
      end

      @registry.evaluate(start_symbol, rules_map).flatten.reject do |obj|
        obj.is_a?(Symbol)
      end.join(''.freeze)
    end
  end
end

module Calyx
  class Grammar
    class << self
      def registry
        @registry ||= Registry.new
      end

      def start(*productions, &production)
        registry.rule(:start, *productions)
      end

      def rule(name, *productions, &production)
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

    def generate(context={})
      @registry.evaluate(:start, context)
    end
  end
end

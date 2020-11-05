module Calyx
  # Represents a named rule connected to a tree of productions that can be
  # evaluated and a trace which represents where the rule was declared.
  class Rule
    def self.build_ast(productions, registry)
      if productions.first.is_a?(Hash)
        Production::WeightedChoices.parse(productions.first.to_a, registry)
      elsif productions.first.is_a?(Enumerable)
        Production::WeightedChoices.parse(productions, registry)
      else
        Production::Choices.parse(productions, registry)
      end
    end

    attr_reader :name, :tree, :trace

    def initialize(name, productions, trace)
      @name = name.to_sym
      @tree = productions
      @trace = trace
    end

    def size
      tree.size
    end

    def evaluate(options)
      tree.evaluate(options)
    end
  end
end

module Calyx
  # Represents a named rule connected to a tree of productions that can be
  # evaluated and a trace which represents where the rule was declared.
  class Rule
    attr_reader :name, :productions, :trace

    def initialize(name, productions, trace)
      @name = name.to_sym
      @productions = productions
      @trace = trace
    end

    def evaluate(random)
      productions.evaluate(random)
    end
  end
end

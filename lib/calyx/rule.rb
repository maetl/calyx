module Calyx
  # Represents a named rule connected to a tree of productions that can be
  # evaluated and a trace which represents where the rule was declared.
  class Rule
    def self.build_ast(productions, registry)
      if productions.first.is_a?(Hash)
        # TODO: test that key is a string

        if productions.first.first.last.is_a?(String)
          # If value of the production is a strings then this is a
          # paired mapping production.
          Syntax::PairedMapping.parse(productions.first, registry)
        else
          # Otherwise, we assume this is a weighted choice declaration and
          # convert the hash to an array
          Syntax::WeightedChoices.parse(productions.first.to_a, registry)
        end
      elsif productions.first.is_a?(Enumerable)
        # TODO: this needs to change to support attributed/tagged grammars
        Syntax::WeightedChoices.parse(productions, registry)
      else
        Syntax::Choices.parse(productions, registry)
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

module Calyx
  # Value object representing a generated grammar result.
  class Result
    def initialize(expression)
      @expression = expression.freeze
    end

    # Produces a syntax tree of nested nodes as the output of the grammar. Each
    # syntax node represents the production rules that were evaluated at each
    # step of the generator.
    #
    # @return [Array]
    def tree
      @expression
    end

    alias_method :to_exp, :tree

    # Produces a text string as the output of the grammar.
    #
    # @return [String]
    def text
      @expression.flatten.reject do |obj|
        obj.is_a?(Symbol)
      end.join
    end

    alias_method :to_s, :text

    # Produces a symbol as the output of the grammar.
    #
    # @return [Symbol]
    def symbol
      text.to_sym
    end

    alias_method :to_sym, :symbol
  end
end

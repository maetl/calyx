module Calyx
  # Value object representing a generated grammar result.
  class Result
    def initialize(expression)
      @expression = expression.freeze
    end

    # The syntax tree of nested nodes representing the production rules which
    # generated this result.
    #
    # @return [Array]
    def tree
      @expression
    end

    alias_method :to_exp, :tree

    # The generated text string produced by the grammar.
    #
    # @return [String]
    def text
      @expression.flatten.reject do |obj|
        obj.is_a?(Symbol)
      end.join
    end

    alias_method :to_s, :text

    # A symbol produced by converting the generated text string where possible.
    #
    # @return [Symbol]
    def symbol
      text.to_sym
    end

    alias_method :to_sym, :symbol
  end
end

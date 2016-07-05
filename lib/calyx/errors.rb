module Calyx
  module Errors
    # Only rules that exist in the registry can be evaluated. When a
    # non-existent rule is referenced, this error is raised.
    #
    #   grammar = Calyx::Grammar.new do
    #     start :blank
    #   end
    #
    #   grammar.evaluate
    #   # => Calyx::Errors::MissingRule: :blank is not registered
    class MissingRule < RuntimeError;
      def initialize(msg=key)
        super(":#{msg} is not registered")
      end
    end

    # Raised when a rule passed in via a context map conflicts with an existing
    # rule in the grammar.
    #
    #   grammar = Calyx::Grammar.new do
    #     start :priority
    #     priority "(A)"
    #   end
    #
    #   grammar.evaluate(priority: "(B)")
    #   # => Calyx::Errors::DuplicateRule: :priority is already registered
    class DuplicateRule < ArgumentError
      def initialize(msg=key)
        super(":#{msg} is already registered")
      end
    end
  end
end

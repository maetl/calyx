module Calyx
  module Errors
    class RuleNotFound < StandardError; end

    class DuplicateRule < StandardError
      def initialize(key)
        super("Rule already declared in grammar: #{key}")
      end
    end
  end
end

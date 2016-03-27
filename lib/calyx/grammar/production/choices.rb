module Calyx
  class Grammar
    module Production
      class Choices
        def self.parse(productions, registry)
          choices = productions.map do |choice|
            if choice.is_a?(String)
              Concat.parse(choice, registry)
            elsif choice.is_a?(Symbol)
              NonTerminal.new(choice, registry)
            end
          end
          self.new(choices)
        end

        def initialize(collection)
          @collection = collection
        end

        def evaluate
          @collection.sample.evaluate
        end
      end
    end
  end
end

module Calyx
  class Grammar
    module Production
      class Choices
        def self.parse(productions, registry)
          choices = productions.map do |choice|
            if choice.is_a?(String)
              Concat.parse(choice, registry)
            elsif choice.is_a?(Fixnum)
              Terminal.new(choice.to_s)
            elsif choice.is_a?(Symbol)
              if choice[0] == Memo::SIGIL
                Memo.new(choice, registry)
              else
                NonTerminal.new(choice, registry)
              end
            end
          end
          self.new(choices)
        end

        def initialize(collection)
          @collection = collection
        end

        def evaluate
          [:choice, @collection.sample.evaluate]
        end
      end
    end
  end
end

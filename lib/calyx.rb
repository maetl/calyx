module Calyx
  class Grammar
    class << self
      attr_accessor :registry

      def start(*productions, &production)
        registry[:start] = construct_rule(productions)
      end

      def rule(name, *productions, &production)
        registry[name.to_sym] = construct_rule(productions)
      end

      def inherit_registry(rules)
        @registry ||= {}
        @registry.merge!(rules || {})
      end

      def inherited(subclass)
        subclass.inherit_registry(@registry)
      end

      def construct_rule(productions)
        if productions.first.is_a?(Enumerable)
          Production::WeightedChoices.parse(productions)
        else
          Production::Choices.parse(productions)
        end
      end
    end

    module Production
      class NonTerminal
        def initialize(expansion)
          @expansion = expansion.to_sym
        end

        def evaluate(registry)
          registry[@expansion].evaluate(registry)
        end
      end

      class Terminal
        def initialize(atom)
          @atom = atom
        end

        def evaluate(registry)
          @atom
        end
      end

      class Concat
        DELIMITER = /(\{[A-Za-z0-9_]+\})/.freeze

        def self.parse(production)
          expansion = production.split(DELIMITER).map do |atom|
            if atom.is_a?(String)
              if atom.chars.first == '{' && atom.chars.last == '}'
                NonTerminal.new(atom.slice(1, atom.length-2))
              else
                Terminal.new(atom)
              end
            elsif atom.is_a?(Symbol)
              NonTerminal.new
            end
          end

          self.new(expansion)
        end

        def initialize(expansion)
          @expansion = expansion
        end

        def evaluate(registry)
          @expansion.reduce('') do |exp, atom|
            exp << atom.evaluate(registry)
          end
        end
      end

      class WeightedChoices
        def self.parse(productions)
          weights_sum = productions.reduce(0) do |memo, choice|
            memo += choice.last
          end

          raise 'Weights must sum to 1' if weights_sum != 1.0

          choices = productions.map do |choice, weight|
            if choice.is_a?(String)
              [Concat.parse(choice), weight]
            elsif choice.is_a?(Symbol)
              [NonTerminal.new(choice), weight]
            end
          end

          self.new(choices)
        end

        def initialize(collection)
          @collection = collection
        end

        def evaluate(registry)
          choice = @collection.max_by { |_, weight| rand ** (1.0 / weight) }.first
          choice.evaluate(registry)
        end
      end

      class Choices
        def self.parse(productions)
          choices = productions.map do |choice|
            if choice.is_a?(String)
              Concat.parse(choice)
            elsif choice.is_a?(Symbol)
              NonTerminal.new(choice)
            end
          end
          self.new(choices)
        end

        def initialize(collection)
          @collection = collection
        end

        def evaluate(registry)
          @collection.sample.evaluate(registry)
        end
      end
    end

    def initialize(seed=nil)
      @seed = seed
      @seed = Time.new.to_i unless @seed
      srand(@seed)
    end

    def registry
      self.class.registry
    end

    def generate
      registry[:start].evaluate(registry)
    end
  end
end

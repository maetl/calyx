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
        Production::Choices.parse(productions)
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
            if atom.chars.first == '{' && atom.chars.last == '}'
              NonTerminal.new(atom.slice(1, atom.length-2))
            else
              Terminal.new(atom)
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

      class Choices
        def self.parse(production)
          choices = production.map do |choice|
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

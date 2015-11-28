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
          Production::WeightedChoices.parse(productions, registry)
        else
          Production::Choices.parse(productions, registry)
        end
      end
    end

    module Production
      class NonTerminal
        def initialize(expansion, registry)
          @expansion = expansion.to_sym
          @registry = registry
        end

        def evaluate
          @registry[@expansion].evaluate
        end
      end

      class Terminal
        def initialize(atom)
          @atom = atom
        end

        def evaluate
          @atom
        end
      end

      class Expression
        def initialize(production, methods)
          @production = production
          @methods = methods.map { |m| m.to_sym }
        end

        def evaluate
          @methods.reduce(@production.evaluate) do |value,method|
            value.send(method)
          end
        end
      end

      class Concat
        EXPRESSION = /(\{[A-Za-z0-9_\.]+\})/.freeze
        START_TOKEN = '{'.freeze
        END_TOKEN = '}'.freeze
        DEREF_TOKEN = '.'.freeze

        def self.parse(production, registry)
          expansion = production.split(EXPRESSION).map do |atom|
            if atom.is_a?(String)
              if atom.chars.first == START_TOKEN && atom.chars.last == END_TOKEN
                head, *tail = atom.slice(1, atom.length-2).split(DEREF_TOKEN)
                rule = NonTerminal.new(head, registry)
                unless tail.empty?
                  Expression.new(rule, tail)
                else
                  rule
                end
              else
                Terminal.new(atom)
              end
            elsif atom.is_a?(Symbol)
              NonTerminal.new(atom, registry)
            end
          end

          self.new(expansion)
        end

        def initialize(expansion)
          @expansion = expansion
        end

        def evaluate
          @expansion.reduce('') do |exp, atom|
            exp << atom.evaluate
          end
        end
      end

      class WeightedChoices
        def self.parse(productions, registry)
          weights_sum = productions.reduce(0) do |memo, choice|
            memo += choice.last
          end

          raise 'Weights must sum to 1' if weights_sum != 1.0

          choices = productions.map do |choice, weight|
            if choice.is_a?(String)
              [Concat.parse(choice, registry), weight]
            elsif choice.is_a?(Symbol)
              [NonTerminal.new(choice, registry), weight]
            end
          end

          self.new(choices)
        end

        def initialize(collection)
          @collection = collection
        end

        def evaluate
          choice = @collection.max_by do |_, weight|
            rand ** (1.0 / weight)
          end.first

          choice.evaluate
        end
      end

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

    def initialize(seed=nil)
      @seed = seed
      @seed = Time.new.to_i unless @seed
      srand(@seed)
    end

    def registry
      self.class.registry
    end

    def generate
      registry[:start].evaluate
    end
  end
end

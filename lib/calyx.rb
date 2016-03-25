require 'yaml'

module Calyx
  class Grammar
    class Registry
      attr_reader :rules

      def initialize
        @rules = {}
      end

      def method_missing(name, *arguments)
        rule(name, *arguments)
      end

      def rule(name, *productions, &production)
        @rules[name.to_sym] = construct_rule(productions)
      end

      def expand(symbol)
        @rules[symbol]
      end

      def combine(registry)
        @rules = rules.merge(registry.rules)
      end

      def evaluate(start_symbol=:start, context={})
        duplicate_registry = Marshal.load(Marshal.dump(self))
        duplicate_rules = duplicate_registry.rules
        context.each do |key, value|
          if duplicate_rules.key?(key.to_sym)
            raise "Rule already declared in grammar: #{key}"
          end

          duplicate_rules[key.to_sym] = if value.is_a?(Array)
            Production::Choices.parse(value, duplicate_registry)
          else
            Production::Concat.parse(value.to_s, duplicate_registry)
          end
        end

        duplicate_rules[start_symbol].evaluate
      end

      private

      def construct_rule(productions)
        if productions.first.is_a?(Enumerable)
          Production::WeightedChoices.parse(productions, self)
        else
          Production::Choices.parse(productions, self)
        end
      end
    end

    class << self
      def load_yml(file)
        klass = Class.new(Calyx::Grammar)
        yaml = YAML.load_file(file)
        yaml.each do |key, value|
          if key.to_sym == :start
            klass.send(:start, *value)
          else
            klass.send(:rule, key, *value)
          end
        end
        klass.new
      end

      def registry
        @registry ||= Registry.new
      end

      def start(*productions, &production)
        registry.rule(:start, *productions)
      end

      def rule(name, *productions, &production)
        registry.rule(name, *productions)
      end

      def inherit_registry(child_registry)
        registry.combine(child_registry) unless child_registry.nil?
      end

      def inherited(subclass)
        subclass.inherit_registry(registry)
      end
    end

    module Production
      class NonTerminal
        def initialize(symbol, registry)
          @symbol = symbol.to_sym
          @registry = registry
        end

        def evaluate
          @registry.expand(@symbol).evaluate
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

    def initialize(seed=nil, &block)
      @seed = seed || Random.new_seed
      srand(@seed)

      if block_given?
        @registry = Registry.new
        @registry.instance_eval(&block)
      else
        @registry = self.class.registry
      end
    end

    def generate(context={})
      @registry.evaluate(:start, context)
    end
  end
end

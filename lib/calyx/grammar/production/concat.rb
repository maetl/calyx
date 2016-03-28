module Calyx
  class Grammar
    module Production
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
    end
  end
end

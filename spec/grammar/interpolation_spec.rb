require 'spec_helper'

describe Calyx::Grammar do
  describe 'string interpolation' do
    it 'substitutes multiple rules in a string' do
      class OneTwo < Calyx::Grammar
        start '{one}. {two}.'
        rule :one, 'One'
        rule :two, 'Two'
      end

      grammar = OneTwo.new
      expect(grammar.generate).to eq('One. Two.')
    end

    it 'calls a formatting modifier in a string substitution' do
      class StringFormatters < Calyx::Grammar
        start :hello_world
        rule :hello_world, '{hello.capitalize} world'
        rule :hello, 'hello'
      end

      grammar = StringFormatters.new(seed: 12345)
      expect(grammar.generate).to eq('Hello world')
    end

    it 'calls a chain of formatting functions in a string substitution' do
      class StringFormatters < Calyx::Grammar
        start :hello_world
        rule :hello_world, '{hello.upcase.rstrip}.'
        rule :hello, 'hello world     '
      end

      grammar = StringFormatters.new
      expect(grammar.generate).to eq('HELLO WORLD.')
    end
  end
end

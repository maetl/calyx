require 'spec_helper'

describe Calyx::Grammar do
  describe 'Class' do
    it 'combines rules from inheritance chain in subclass' do
      class ParentRule < Calyx::Grammar
        rule :one, 'One'
      end

      class ChildRule < ParentRule
        rule :two, 'Two'
      end

      class GrandchildRule < ChildRule
        rule :three, 'Three'
      end

      class GreatGrandchildRule < GrandchildRule
        start '{one}. {two}. {three}.'
      end

      grammar = GreatGrandchildRule.new
      expect(grammar.generate).to eq('One. Two. Three.')
    end
  end
end

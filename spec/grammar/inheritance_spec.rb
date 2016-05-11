require 'spec_helper'

describe Calyx::Grammar do
  context 'inheritance' do
    it 'combines rules from parent in subclass' do
      class BaseRules < Calyx::Grammar
        rule :one, 'One.'
        rule :two, 'Two.'
      end

      class StartRule < BaseRules
        start '{one} {two}'
      end

      grammar = StartRule.new
      expect(grammar.generate).to eq('One. Two.')
    end

    it 'combines rules from inheritance chain in subclass' do
      class ParentRules < Calyx::Grammar
        rule :one, 'One.'
        rule :two, 'Two.'
      end

      class ChildRule < ParentRules
        rule :three, 'Three.'
      end

      class GrandchildRule < ChildRule
        start '{one} {two} {three}'
      end

      grammar = GrandchildRule.new
      expect(grammar.generate).to eq('One. Two. Three.')

      parent = ParentRules.new
      expect { parent.generate }.to raise_error(NoMethodError)
    end
  end
end

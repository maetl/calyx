require 'spec_helper'

describe Calyx::Grammar do
  describe 'context hash' do
    specify 'construct dynamic rules with context hash of values' do
      class TemplateStringValues < Calyx::Grammar
        start '{one}{two}{three}'
      end

      grammar = TemplateStringValues.new
      expect(grammar.generate({one: 1, two: 2, three: 3})).to eq('123')
    end

    specify 'construct dynamic rules with context hash of expansion strings' do
      class TemplateStringExpansions < Calyx::Grammar
        start '{how}'
        rule :a, 'piece of string?'
      end

      grammar = TemplateStringExpansions.new
      expect(grammar.generate({how: '{long}', long: '{is}', is: '{a}'})).to eq('piece of string?')
    end

    specify 'construct dynamic rules with context hash of choices' do
      class TemplateStringChoices < Calyx::Grammar
        start '{fruit}'
      end

      grammar = TemplateStringChoices.new
      expect(grammar.generate({fruit: ['apple', 'orange']})).to match(/apple|orange/)
    end


    specify 'construct dynamic rules with two context hashes' do
      class StockReport < Calyx::Grammar
        start 'You should buy shares in {company}.'
      end

      grammar = StockReport.new
      cyberdyne_context_hash = {company: 'Cyberdyne' }
      bridgestone_context_hash = {company: 'Bridgestone' }

      expect(grammar.generate(cyberdyne_context_hash)).to eq('You should buy shares in Cyberdyne.')
      expect(grammar.generate(bridgestone_context_hash)).to eq('You should buy shares in Bridgestone.')
    end

    specify 'raise error when duplicate rule is passed' do
      grammar = Calyx::Grammar.new do
        start :priority
        priority '(A)'
      end

      expect { grammar.evaluate(priority: '(B)') }.to raise_error(Calyx::Errors::DuplicateRule)
    end
  end
end

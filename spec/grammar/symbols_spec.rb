require 'spec_helper'

describe Calyx::Grammar do
  describe 'recursive symbols' do
    it 'substitutes a chain of rules with symbols' do
      class RuleSymbols < Calyx::Grammar
        start :rule_symbol
        rule :rule_symbol, :terminal_symbol
        rule :terminal_symbol, 'OK'
      end

      grammar = RuleSymbols.new
      expect(grammar.generate).to eq('OK')
    end
  end
end

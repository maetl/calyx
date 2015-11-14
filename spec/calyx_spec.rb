require 'spec_helper'

describe Calyx do
  specify 'construct non-terminal production rule' do
    terminal = double('terminal')
    expect(terminal).to receive(:evaluate)
    statement = Calyx::Grammar::Production::NonTerminal.new(:statement)
    statement.evaluate(statement: terminal)
  end

  specify 'construct terminal production rule' do
    atom = Calyx::Grammar::Production::Terminal.new(:atom)
    expect(atom.evaluate({})).to eq(:atom)
  end

  specify 'split and join with delimiters' do
    class OneTwo < Calyx::Grammar
      start '{one} {two}'
      rule :one, 'One.'
      rule :two, 'Two.'
    end

    grammar = OneTwo.new
    expect(grammar.generate).to eq('One. Two.')
  end

  specify 'rule inheritance' do
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

  specify 'reference rule symbols in other rules' do
    class RuleSymbols < Calyx::Grammar
      start :rule_symbol
      rule :rule_symbol, :terminal_symbol
      rule :terminal_symbol, 'OK'
    end

    grammar = RuleSymbols.new
    expect(grammar.generate).to eq('OK')
  end

  specify 'weighted choices must sum to 1' do
    expect do
      class BadWeights < Calyx::Grammar
        start ['10%', 0.1], ['70%', 0.7]
      end
    end.to raise_error('Weights must sum to 1')
  end

  specify 'weighted choices in rule definition' do
    class WeightedChoices < Calyx::Grammar
      start ['20%', 0.2], ['80%', 0.8]
    end

    grammar = WeightedChoices.new(12345)
    expect(grammar.generate).to eq('20%')
  end
end

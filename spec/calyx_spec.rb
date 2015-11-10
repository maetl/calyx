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
end

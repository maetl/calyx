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
end

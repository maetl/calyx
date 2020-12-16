require 'spec_helper'

describe Calyx::Syntax::NonTerminal do
  specify 'construct non-terminal production rule' do
    registry = double('registry')
    expect(registry).to receive(:expand).and_return(Calyx::Syntax::Terminal.new(:atom))
    rule = Calyx::Syntax::NonTerminal.new(:statement, registry)
    rule.evaluate(Calyx::Options.new)
  end
end

require 'spec_helper'

describe Calyx::Production::NonTerminal do
  specify 'construct non-terminal production rule' do
    registry = double('registry')
    expect(registry).to receive(:expand).and_return(Calyx::Production::Terminal.new(:atom))
    rule = Calyx::Production::NonTerminal.new(:statement, registry)
    rule.evaluate
  end
end

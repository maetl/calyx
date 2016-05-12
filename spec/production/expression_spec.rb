require 'spec_helper'

describe Calyx::Production::Expression do
  specify 'construct string formatting production' do
    nonterminal = double(:nonterminal)
    allow(nonterminal).to receive(:evaluate).and_return([:atom, 'hello'])
    rule = Calyx::Production::Expression.new(nonterminal, ['upcase'])
    expect(rule.evaluate).to eq([:expression, 'HELLO'])
  end
end

require 'spec_helper'

describe Calyx::Production::Expression do
  let(:atom) do
    double(:atom)
  end

  it 'evaluates a value' do
    allow(atom).to receive(:evaluate).and_return([:atom, 'hello'])

    rule = Calyx::Production::Expression.new(atom, [])
    expect(rule.evaluate).to eq([:expression, 'hello'])
  end

  it 'evaluates a value with modifier' do
    allow(atom).to receive(:evaluate).and_return([:atom, 'hello'])

    rule = Calyx::Production::Expression.new(atom, ['upcase'])
    expect(rule.evaluate).to eq([:expression, 'HELLO'])
  end

  it 'evaluates a value with modifier chain' do
    allow(atom).to receive(:evaluate).and_return([:atom, 'hello'])

    rule = Calyx::Production::Expression.new(atom, ['upcase', 'swapcase'])
    expect(rule.evaluate).to eq([:expression, 'hello'])
  end
end

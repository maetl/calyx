require 'spec_helper'

describe Calyx::Production::Expression do
  let(:production) do
    double(:production)
  end

  it 'evaluates a value' do
    allow(production).to receive(:evaluate).and_return([:atom, 'hello'])

    rule = Calyx::Production::Expression.new(production, [])
    expect(rule.evaluate).to eq([:expression, 'hello'])
  end

  it 'evaluates a value with modifier' do
    allow(production).to receive(:evaluate).and_return([:atom, 'hello'])

    rule = Calyx::Production::Expression.new(production, ['upcase'])
    expect(rule.evaluate).to eq([:expression, 'HELLO'])
  end

  it 'evaluates a value with modifier chain' do
    allow(production).to receive(:evaluate).and_return([:atom, 'hello'])

    rule = Calyx::Production::Expression.new(production, ['upcase', 'swapcase'])
    expect(rule.evaluate).to eq([:expression, 'hello'])
  end
end

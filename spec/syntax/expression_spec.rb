require 'spec_helper'

describe Calyx::Syntax::Expression do
  let(:atom) do
    atom = double(:atom)
    allow(atom).to receive(:evaluate).and_return([:atom, 'hello'])
    atom
  end

  let(:registry_double) do
    double(:registry)
  end

  let(:registry_instance) do
    Calyx::Registry.new
  end

  it 'evaluates a value' do
    rule = Calyx::Syntax::Expression.new(atom, [], registry_instance)
    expect(rule.evaluate(Calyx::Options.new)).to eq([:expression, 'hello'])
  end

  it 'evaluates a value with modifier' do
    rule = Calyx::Syntax::Expression.new(atom, ['upcase'], registry_instance)
    expect(rule.evaluate(Calyx::Options.new)).to eq([:expression, 'HELLO'])
  end

  it 'evaluates a value with modifier chain' do
    rule = Calyx::Syntax::Expression.new(atom, ['upcase', 'swapcase'], registry_instance)
    expect(rule.evaluate(Calyx::Options.new)).to eq([:expression, 'hello'])
  end

  it 'transforms a value with a custom modifier' do
    allow(registry_double).to receive(:transform).with(:to_uppercase, 'hello').and_return('HELLO')

    rule = Calyx::Syntax::Expression.new(atom, ['to_uppercase'], registry_double)
    expect(rule.evaluate(Random.new)).to eq([:expression, 'HELLO'])
  end
end

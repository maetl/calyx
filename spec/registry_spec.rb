require 'spec_helper'

describe Calyx::Grammar::Registry do
  let(:registry) do
    Calyx::Grammar::Registry.new
  end

  specify 'registry evaluates the start rule' do
    registry.start('atom')
    expect(registry.evaluate).to eq([:start, [:choice, [:concat, [[:atom, "atom"]]]]])
  end

  specify 'registry evaluates recursive rules' do
    registry.start(:atom)
    registry.rule(:atom, 'atom')
    expect(registry.evaluate).to eq([:start, [:choice, [:atom, [:choice, [:concat, [[:atom, "atom"]]]]]]])
  end

  specify 'evaluate from context if rule not found' do
    registry.start(:atom)
    expect(registry.evaluate(:start, atom: 'atom')).to eq([:start, [:choice, [:atom, [:concat, [[:atom, "atom"]]]]]])
  end
end

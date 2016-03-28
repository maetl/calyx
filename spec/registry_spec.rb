require 'spec_helper'

describe Calyx::Grammar::Registry do
  specify 'registry evaluates the start rule' do
    registry = Calyx::Grammar::Registry.new
    registry.start('atom')
    expect(registry.evaluate).to eq('atom')
  end

  specify 'registry evaluates recursive rules' do
    registry = Calyx::Grammar::Registry.new
    registry.start(:atom)
    registry.rule(:atom, 'atom')
    expect(registry.evaluate).to eq('atom')
  end
end

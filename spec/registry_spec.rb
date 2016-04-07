require 'spec_helper'

describe Calyx::Grammar::Registry do
  let(:registry) do
    Calyx::Grammar::Registry.new
  end

  context '#evaluate' do
    # Need to do some more work to determine what the tree representation should look like.
    #
    # In particular, need to look at whether the :choice and :concat nodes could be simplified
    # in cases where there is only a single production rather than multiple choices.
    #
    # The best way to resolve this is probably to try generating some interesting trees and
    # seeing what is useful in practice.
    it 'should return a tree representation of the grammar'
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

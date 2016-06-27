require 'spec_helper'

describe Calyx::Production::WeightedChoices do
  specify 'construct choices from array' do
    registry = double('registry')
    rule = Calyx::Production::WeightedChoices.parse([['atom', 0.5], ['atom', 0.5]], registry)
    expect(rule.evaluate).to eq([:weighted_choice, [:concat, [[:atom, 'atom']]]])
  end

  specify 'construct choices from hash' do
    registry = double('registry')
    rule = Calyx::Production::WeightedChoices.parse({'atom' => 1}, registry)
    expect(rule.evaluate).to eq([:weighted_choice, [:concat, [[:atom, 'atom']]]])
  end
end

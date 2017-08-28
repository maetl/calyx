require 'spec_helper'

describe Calyx::Production::WeightedChoices do
  specify 'construct choices from array' do
    rule = Calyx::Production::WeightedChoices.parse([['atom', 0.5], ['atom', 0.5]], Calyx::Registry.new)
    expect(rule.evaluate(Calyx::Options.new)).to eq([:weighted_choice, [:concat, [[:atom, 'atom']]]])
  end

  specify 'construct choices from hash' do
    rule = Calyx::Production::WeightedChoices.parse({'atom' => 1}, Calyx::Registry.new)
    expect(rule.evaluate(Calyx::Options.new)).to eq([:weighted_choice, [:concat, [[:atom, 'atom']]]])
  end
end

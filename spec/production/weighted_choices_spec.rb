require 'spec_helper'

describe Calyx::Production::WeightedChoices do
  let(:options) do
    Calyx::Options.new(seed: 2)
  end

  specify 'construct choices from array of floats' do
    rule = Calyx::Production::WeightedChoices.parse([['atom', 0.5], ['molecule', 0.5]], Calyx::Registry.new)
    expect(rule.evaluate(options)).to eq([:weighted_choice, [:concat, [[:atom, 'atom']]]])
  end

  specify 'construct choices from hash of floats' do
    rule = Calyx::Production::WeightedChoices.parse({'atom' => 0.4, 'molecule' => 0.6}, Calyx::Registry.new)
    expect(rule.evaluate(options)).to eq([:weighted_choice, [:concat, [[:atom, 'atom']]]])
  end

  specify 'construct choices from hash of fixnums' do
    rule = Calyx::Production::WeightedChoices.parse({'atom' => 1, 'molecule' => 4}, Calyx::Registry.new)
    expect(rule.evaluate(options)).to eq([:weighted_choice, [:concat, [[:atom, 'atom']]]])
  end
end

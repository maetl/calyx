require 'spec_helper'

describe Calyx::Production::Choices do
  specify 'construct choices from strings' do
    rule = Calyx::Production::Choices.parse(['atom', 'atom', 'atom'], Calyx::Registry.new)
    expect(rule.evaluate(Random.new)).to eq([:choice, [:concat, [[:atom, 'atom']]]])
  end

  specify 'construct choices from numbers' do
    rule = Calyx::Production::Choices.parse([123, 123, 123], Calyx::Registry.new)
    expect(rule.evaluate(Random.new)).to eq([:choice, [:atom, '123']])
  end
end

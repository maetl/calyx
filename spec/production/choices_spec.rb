require 'spec_helper'

describe Calyx::Production::Choices do
  specify 'construct choices from strings' do
    registry = double('registry')
    rule = Calyx::Production::Choices.parse(['atom', 'atom', 'atom'], registry)
    expect(rule.evaluate).to eq([:choice, [:concat, [[:atom, 'atom']]]])
  end

  specify 'construct choices from numbers' do
    registry = double('registry')
    rule = Calyx::Production::Choices.parse([123, 123, 123], registry)
    expect(rule.evaluate).to eq([:choice, [:atom, '123']])
  end
end

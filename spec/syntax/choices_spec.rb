require 'spec_helper'

describe Calyx::Syntax::Choices do
  specify 'construct choices from strings' do
    rule = Calyx::Syntax::Choices.parse(['atom', 'atom', 'atom'], Calyx::Registry.new)
    expect(rule.evaluate(Calyx::Options.new)).to eq([:choice, [:concat, [[:atom, 'atom']]]])
  end

  specify 'construct choices from numbers' do
    rule = Calyx::Syntax::Choices.parse([123, 123, 123], Calyx::Registry.new)
    expect(rule.evaluate(Calyx::Options.new)).to eq([:choice, [:atom, '123']])
  end
end

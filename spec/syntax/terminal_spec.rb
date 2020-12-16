require 'spec_helper'

describe Calyx::Syntax::Terminal do
  specify 'construct terminal production rule' do
    atom = Calyx::Syntax::Terminal.new(:terminal)
    expect(atom.evaluate(Calyx::Options.new)).to eq([:atom, :terminal])
  end
end

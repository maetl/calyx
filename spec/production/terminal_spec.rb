require 'spec_helper'

describe Calyx::Production::Terminal do
  specify 'construct terminal production rule' do
    atom = Calyx::Production::Terminal.new(:terminal)
    expect(atom.evaluate).to eq([:atom, :terminal])
  end
end

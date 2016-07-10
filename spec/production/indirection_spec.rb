describe Calyx::Production::Indirection do
  it 'uses the registry to substitute a variable variable expression' do
    registry = double('registry')
    rule = Calyx::Production::NonTerminal.new(:one, registry)
    one = Calyx::Production::Terminal.new('ONE')
    allow(registry).to receive(:expand).with(:rule).and_return(rule)
    allow(registry).to receive(:expand).with(:one).and_return(one)
    indirection = Calyx::Production::Indirection.new(:$rule, registry)
    # Return the full tree until this API design is properly figured out
    expect(indirection.evaluate).to eq([:rule, [:one, [:atom, "ONE"]]])
  end
end

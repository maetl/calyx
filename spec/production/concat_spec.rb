describe Calyx::Production::Concat do
  it 'treats input with no delimiters as a concatenated production with a single atom' do
    registry = double('registry')
    concat = Calyx::Production::Concat.parse('one two three', registry)
    expect(concat.evaluate(Random.new)).to eq([:concat, [[:atom, 'one two three']]])
  end

  it 'treats input with delimiters as a concatenated production with an expansion' do
    registry = double('registry')
    allow(registry).to receive(:expand).and_return(Calyx::Production::Terminal.new('ONE'))
    concat = Calyx::Production::Concat.parse('{one} two three', registry)
    expect(concat.evaluate(Random.new)).to eq([:concat, [[:atom, ''], [:one, [:atom, 'ONE']], [:atom, ' two three']]])
  end
end

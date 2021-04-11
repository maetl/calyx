describe Calyx::Syntax::Concat do
  it 'treats input with no delimiters as a concatenated production with a single atom' do
    registry = double('registry')
    concat = Calyx::Syntax::Concat.parse('one two three', registry)
    expect(concat.evaluate(Calyx::Options.new)).to eq([:concat, [[:atom, 'one two three']]])
  end

  it 'treats input with delimiters as a concatenated production with an expansion' do
    registry = double('registry')
    allow(registry).to receive(:expand).and_return(Calyx::Syntax::Terminal.new('ONE'))
    concat = Calyx::Syntax::Concat.parse('{one} two three', registry)
    expect(concat.evaluate(Calyx::Options.new)).to eq([:concat, [[:atom, ''], [:one, [:atom, 'ONE']], [:atom, ' two three']]])
  end

  # it 'treats input with chained expression in delimiters as a concatenated production' do
  #   registry = double('registry')
  #   concat = Calyx::Syntax::Concat.parse('{one} two three', registry)
  #   expect(concat.evaluate(Calyx::Options.new)).to eq([:concat, [[:atom, ''], [:one, [:atom, 'ONE']], [:atom, ' two three']]])
  # end
end

describe 'rules dsl' do
  specify 'rule symbols from named instance methods' do
    grammar = Calyx::Grammar.new do
      start '{hello} {world}.'
      hello 'Hallo'
      world 'Welt'
    end

    expect(grammar.generate).to eq('Hallo Welt.')
  end

  specify 'rule symbols from named class methods' do
    class HalloWelt < Calyx::Grammar
      start '{hello} {world}.'
      hello 'Hallo'
      world 'Welt'
    end
    grammar = HalloWelt.new

    expect(grammar.generate).to eq('Hallo Welt.')
  end
end

require 'spec_helper'

describe '#load_json' do
  def sample_path(filename)
    "#{__dir__}/samples/#{filename}.json"
  end

  specify 'generate with recursive rules' do
    grammar = Calyx::Format.load_json(sample_path('hello_statement'))
    expect(grammar.generate).to eq('Hello World')
  end

  specify 'generate with multiple choices' do
    grammar = Calyx::Format.load_json(sample_path('multiple_choices'))
    expect(grammar.generate).to match(/Dragon Wins|Hero Wins/)
  end

  specify 'generate with rule expansion' do
    grammar = Calyx::Format.load_yml(sample_path('rule_expansion'))
    expect(grammar.generate).to match(/apple|orange/)
  end

  specify 'generate with weighted choices' do
    grammar = Calyx::Format.load_json(sample_path('weighted_choices'))
    expect(grammar.generate).to match(/40%|60%/)
  end

  specify 'raise error if weighted choices do not sum to 1' do
    expect { Calyx::Format.load_json(sample_path('bad_weights')) }.to raise_error('Weights must sum to 1')
  end
end

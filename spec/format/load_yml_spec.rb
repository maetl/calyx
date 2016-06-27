require 'spec_helper'

describe "#load_yml" do
  def sample(filename)
    File.read("#{__dir__}/samples/#{filename}.yml")
  end

  specify 'generate with recursive rules' do
    grammar = Calyx::Format.load_yml(sample('hello_statement'))
    expect(grammar.generate).to eq("Hello World")
  end

  specify 'generate with multiple choices' do
    grammar = Calyx::Format.load_yml(sample('multiple_choices'))
    expect(grammar.generate).to match(/Dragon Wins|Hero Wins/)
  end

  specify 'generate with rule expansion' do
    grammar = Calyx::Format.load_yml(sample('rule_expansion'))
    expect(grammar.generate).to match(/apple|orange/)
  end

  specify 'generate with weighted choices' do
    grammar = Calyx::Format.load_yml(sample('weighted_choices'))
    expect(grammar.generate).to match(/40%|60%/)
  end

  specify 'raise error if weighted choices do not sum to 1' do
    expect { Calyx::Format.load_yml(sample('bad_weights')) }.to raise_error('Weights must sum to 1')
  end
end

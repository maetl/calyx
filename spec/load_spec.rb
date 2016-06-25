require 'spec_helper'
require 'psych'

describe "#load" do
  def sample(filename)
    "#{__dir__}/format/samples/#{filename}"
  end

  specify 'can load a YAML file properly' do
    grammar = Calyx::Grammar.load(sample('hello.yml'))
    expect(grammar.generate).to eq("Hello World")
  end

  specify "can load a JSON file properly" do
    grammar = Calyx::Grammar.load(sample('hello.json'))
    expect(grammar.generate).to eq("Hello World")
  end

  specify "raises error if given a file that it cannot parse" do
    expect { Calyx::Grammar.load(sample('bad_syntax.yml')) }.to raise_error(Psych::SyntaxError)
  end

  specify "raises error with bad file extension" do
    expect { Calyx::Grammar.load(sample('bad_extension.bad')) }.to raise_error('Cannot convert .bad files.')
  end
end

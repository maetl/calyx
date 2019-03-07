require 'spec_helper'
require 'json'

describe '#load' do
  def sample(filename)
    "#{__dir__}/samples/#{filename}"
  end

  specify 'can load a JSON file properly' do
    grammar = Calyx::Format.load(sample('hello.json'))
    expect(grammar.generate).to eq('Hello World')
  end

  specify 'raises error if given a file that it cannot parse' do
    expect { Calyx::Format.load(sample('bad_syntax.json')) }.to raise_error(JSON::ParserError)
  end

  specify 'raises error with bad file extension' do
    expect { Calyx::Format.load(sample('bad_extension.bad')) }.to raise_error(Calyx::Errors::UnsupportedFormat)
  end
end

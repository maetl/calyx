require 'spec_helper'

describe "#load" do
  specify 'can load a YAML file properly' do
      yaml = <<-EOF
      start: "Hello World"
      EOF
    file_name = "example.yml"
    allow(File).to receive(:read).with(file_name).and_return(yaml)
    grammar = Calyx::Grammar.load(file_name)
    expect(grammar.generate).to eq("Hello World")
  end

  specify "can load a JSON file properly" do
      json = <<-EOF
      {
        "start": "Hello World"
      }
      EOF
      file_name = "example.json"
      allow(File).to receive(:read).with(file_name).and_return(json)
      grammar = Calyx::Grammar.load(file_name)
      expect(grammar.generate).to eq("Hello World")
  end

  specify "raises error if given a file that it cannot parse" do
    mystery = <<-EOF
    ? start: "Hello World" ¿
    EOF
    file_name = "example.mystery"
    allow(File).to receive(:read).with(file_name).and_return(mystery)
    expect do
      Calyx::Grammar.load(file_name)
    end.to raise_error('Cannot convert .mystery files.')
  end

end
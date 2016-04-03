require 'spec_helper'

describe "#load_json" do

  specify 'construct a Calyx::Grammar class using a JSON file that references other rules' do
    json_text = <<-EOF
    {
      "start": ":hello_world",
      "hello_world": ":statement",
      "statement": "Hello World"
    }
    EOF
    grammar = Calyx::Grammar.load_json(json_text)
    expect(grammar.generate).to eq("Hello World")
  end

  specify 'construct a Calyx::Grammar class using a JSON file that can handle multiple parameters' do
    json_text = <<-EOF
    {
      "start": "{fruit}",
      "fruit": ["apple","orange"]
    }
    EOF
    grammar = Calyx::Grammar.load_json(json_text)
    array = []
    10.times { array << grammar.generate }
    expect(array.uniq.sort).to eq(["apple","orange"])
  end

  specify "construct a Calyx::Grammar class with weighted choices" do
    json_text = <<-EOF
    {
      "start": [["60%", 0.6], ["40%", 0.4]]
    }
    EOF
    grammar = Calyx::Grammar.load_json(json_text)
    array = []
    10.times { array << grammar.generate }
    expect(array.uniq.sort).to eq(["40%","60%"])
  end

  specify 'construct a Calyx::Grammar class but raise an error if weighted choices do not equal 1' do
    json_text = <<-EOF
    {
      "start": [["90%", 0.9], ["80%", 0.8]]
    }
    EOF
    expect do
      Calyx::Grammar.load_json(json_text)
    end.to raise_error('Weights must sum to 1')

  end

end
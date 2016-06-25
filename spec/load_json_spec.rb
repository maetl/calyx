require 'spec_helper'

describe "#load_json" do
  specify 'generate with recursive rules' do
    json_text = <<-EOF
    {
      "start": "{hello_world}",
      "hello_world": "{statement}",
      "statement": "Hello World"
    }
    EOF
    grammar = Calyx::Format.load_json(json_text)
    expect(grammar.generate).to eq("Hello World")
  end

  specify 'generate with multiple choices' do
    json_text = <<-EOF
    {
      "start": ["{dragon_wins}", "{hero_wins}"],
      "dragon_wins": "Dragon Wins",
      "hero_wins": "Hero Wins"
    }
    EOF
    grammar = Calyx::Format.load_json(json_text)
    expect(grammar.generate).to match(/Dragon Wins|Hero Wins/)
  end

  specify 'generate with weighted choices' do
    json_text = <<-EOF
    {
      "start": [["60%", 0.6], ["40%", 0.4]]
    }
    EOF
    grammar = Calyx::Format.load_json(json_text)
    expect(grammar.generate).to match(/40%|60%/)
  end

  specify 'raise error if weighted choices do not sum to 1' do
    json_text = <<-EOF
    {
      "start": [["90%", 0.9], ["80%", 0.8]]
    }
    EOF
    expect { Calyx::Format.load_json(json_text) }.to raise_error('Weights must sum to 1')
  end
end

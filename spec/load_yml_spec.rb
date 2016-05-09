require 'spec_helper'

describe "#load_yml" do

  specify 'generate with recursive rules' do
    yaml = <<-EOF
    start: :hello_world
    hello_world: :statement
    statement: "Hello World"
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    expect(grammar.generate).to eq("Hello World")
  end

  specify 'generate with multiple choices' do
    yaml = <<-EOF
    start:
      - :dragon_wins
      - :hero_wins
    dragon_wins: "Dragon Wins"
    hero_wins: "Hero Wins"
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    expect(grammar.generate).to match(/Dragon Wins|Hero Wins/)
  end

  specify 'generate with template expansion' do
    yaml = <<-EOF
    start: "{fruit}"
    fruit:
      - apple
      - orange
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    expect(grammar.generate).to match(/apple|orange/)
  end

  specify 'generate with weighted choices' do
    yaml = <<-EOF
    start:
      - [60%, 0.6]
      - [40%, 0.4]
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    expect(grammar.generate).to match(/40%|60%/)
  end

  specify 'raise error if weighted choices do not sum to 1' do
    yaml = <<-EOF
    start:
      - [90%, 0.9]
      - [80%, 0.8]
    EOF
    expect { Calyx::Grammar.load_yml(yaml) }.to raise_error('Weights must sum to 1')
  end


end

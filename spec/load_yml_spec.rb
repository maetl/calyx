require 'spec_helper'

describe "#load_yml" do

  specify 'construct a Calyx::Grammar class using a YAML file that references other rules' do
    yaml = <<-EOF
    start: :hello_world
    hello_world: :statement
    statement: "Hello World"
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    expect(grammar.generate).to eq("Hello World")
  end

  specify 'construct a Calyx::Grammar that can handle multiple references to other rules' do
    yaml = <<-EOF
    start:
      - :dragon_wins
      - :hero_wins
    dragon_wins: "Dragon Wins"
    hero_wins: "Hero Wins"
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    array = []
    10.times { array << grammar.generate }
    expect(array.uniq.sort).to eq(["Dragon Wins","Hero Wins"])
  end

  specify 'construct a Calyx::Grammar class using a YAML file that can handle multiple parameters' do
    yaml = <<-EOF
    start: "{fruit}"
    fruit:
      - apple
      - orange
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    array = []
    10.times { array << grammar.generate }
    expect(array.uniq.sort).to eq(["apple","orange"])
  end

  specify 'construct a Calyx::Grammar class with weighted choices' do
    yaml = <<-EOF
    start:
      - [60%, 0.6]
      - [40%, 0.4]
    EOF
    grammar = Calyx::Grammar.load_yml(yaml)
    array = []
    10.times { array << grammar.generate }
    expect(array.uniq.sort).to eq(["40%","60%"])
  end

  specify 'construct a Calyx::Grammar class but raise an error if weighted choices do not equal 1' do
    yaml = <<-EOF
    start:
      - [90%, 0.9]
      - [80%, 0.8]
    EOF
    expect do
      Calyx::Grammar.load_yml(yaml)
    end.to raise_error('Weights must sum to 1')
  end


end
require 'spec_helper'

describe 'memoized rules' do
  specify 'memoized symbol prefix' do
    grammar = Calyx::Grammar.new do
      rule :start, "Enter {character}. Exit {character}."
      rule :character, :@name
      rule :name, "Vladimir", "Estragon"
    end

    expect(grammar.generate).to eq(grammar.generate)
  end

  specify 'memoized template expression' do
    grammar = Calyx::Grammar.new do
      rule :burger, "Monolith {@extras}"
      rule :burger_combo, "Jumbo Monolith {@extras}"
      rule :extras, "w/ extra grease", "w/ polycheese"
    end

    expect(grammar.generate(:burger_combo)).to include(grammar.generate(:burger))
  end

  xit 'memoized symbol in rule definition' do
    grammar = Calyx::Grammar.new do
      rule :@spitz, "pomeranian", "samoyed", "shiba inu"
    end

    expect(grammar.generate(:spitz)).to eq(grammar.generate(:spitz))
  end
end

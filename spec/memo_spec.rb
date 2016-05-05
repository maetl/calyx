require 'spec_helper'

describe 'memoized rules' do
  specify 'memoized rule mapped with symbol prefix' do
    grammar = Calyx::Grammar.new do
      rule :start, "Enter {character}. Exit {character}."
      rule :character, :@name
      rule :name, "Vladimir", "Estragon"
    end

    expect(grammar.generate).to eq(grammar.generate)
  end

  specify 'memoized rule mapped with template expression' do
    grammar = Calyx::Grammar.new do
      rule :pupper, '{@spitz}:{@spitz}'
      rule :spitz, "pomeranian", "samoyed", "shiba inu"
    end

    actual = grammar.generate(:pupper).split(':')
    expect(actual.first).to eq(actual.last)
  end
end

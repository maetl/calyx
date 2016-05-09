require 'spec_helper'

describe 'memoized rules' do
  specify 'memoized rule mapped with symbol prefix' do
    grammar = Calyx::Grammar.new do
      rule :start, '{@tramp}:{@tramp}'
      rule :tramp, :@character
      rule :character, 'Vladimir', 'Estragon'
    end

    actual = grammar.generate.split(':')
    expect(actual.first).to eq(actual.last)
  end

  specify 'memoized rule mapped with template expression' do
    grammar = Calyx::Grammar.new do
      rule :start, :pupper
      rule :pupper, '{@spitz}:{@spitz}'
      rule :spitz, "pomeranian", "samoyed", "shiba inu"
    end

    actual = grammar.generate.split(':')
    expect(actual.first).to eq(actual.last)
  end

  specify 'memoized rules are reset between multiple runs' do
    grammar = Calyx::Grammar.new(1212) do
      rule :start, '{flower}{flower}{flower}'
      rule :flower, :@flowers
      rule :flowers, "🌷", "🌻", "🌼"
    end

    expect(grammar.generate).to match(/🌷{3}/)
    expect(grammar.generate).to match(/🌼{3}/)
    expect(grammar.generate).to match(/🌼{3}/)
    expect(grammar.generate).to match(/🌼{3}/)
    expect(grammar.generate).to match(/🌷{3}/)
    expect(grammar.generate).to match(/🌻{3}/)
  end
end

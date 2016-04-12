require 'spec_helper'

describe 'memoized rules' do
  specify 'memoized symbol prefix' do
    direction = Calyx::Grammar.new(123) do
      rule :start, "Enter {character}. Exit {character}."
      rule :character, :@name
      rule :name, "Vladimir", "Estragon"
    end

    10.times do
      expect(direction.generate).to eq("Enter Vladimir. Exit Vladimir.")
    end
  end
end

describe Calyx::Grammar do
  describe 'unique rules' do
    specify 'unique rule mapped with symbol prefix' do
      grammar = Calyx::Grammar.new do
        rule :start, '{$tramp}:{$tramp}'
        rule :tramp, :$character
        rule :character, 'Vladimir', 'Estragon'
      end

      actual = grammar.generate.split(':')
      expect(actual.first).to_not eq(actual.last)
    end

    specify 'unique rules never repeat the same choice' do
      grammar = Calyx::Grammar.new do
        rule :start, '{flower}{flower}{flower}'
        rule :flower, :$flowers
        rule :flowers, '🌷', '🌻', '🌼'
      end

      expect(grammar.generate).to match(/🌷🌻🌼|🌷🌼🌻|🌻🌷🌼|🌻🌼🌷|🌼🌻🌷|🌼🌷🌻/)
    end

    specify 'unique rules cycle once sequence is consumed' do
      grammar = Calyx::Grammar.new do
        rule :start, '{pet}{pet}{pet}'
        rule :pet, :$pets
        rule :pets, '🐱', '🐶'
      end

      expect(grammar.generate).to match(/🐱🐶🐶|🐱🐶🐱|🐶🐱🐱|🐶🐱🐶/)
    end

    specify 'unique rules can merge from execution context' do
      grammar = Calyx::Grammar.new do
        start "{$num}{$num}"
      end

      expect(grammar.generate(num: ["¶", "§"])).to match(/¶§|§¶/)
    end
  end
end

require 'rspec/expectations'

RSpec::Matchers.define :eq_per_platform do |expected|
  match do |actual|
    key = if expected.key?(RUBY_ENGINE.to_sym)
      RUBY_ENGINE.to_sym
    else
      :default
    end

    actual == expected[key]
  end
end

describe Calyx::Grammar do
  describe 'options' do
    class Metallurgy < Calyx::Grammar
      start 'platinum', 'titanium', 'tungsten'
    end

    describe ':seed' do
      it 'accepts a seed in the legacy constructor format' do
        grammar = Metallurgy.new(43210)

        expect(grammar.generate).to eq_per_platform(jruby: 'tungsten', default: 'platinum')
      end

      it 'accepts a seed option' do
        grammar = Metallurgy.new(seed: 43210)

        expect(grammar.generate).to eq_per_platform(jruby: 'tungsten', default: 'platinum')
      end
    end

    describe ':rng' do
      it 'accepts a random instance in the legacy constructor format' do
        grammar = Metallurgy.new(Random.new(43210))

        expect(grammar.generate).to eq_per_platform(jruby: 'tungsten', default: 'platinum')
      end

      it 'accepts a random instance as an option' do
        grammar = Metallurgy.new(rng: Random.new(43210))

        expect(grammar.generate).to eq_per_platform(jruby: 'tungsten', default: 'platinum')
      end
    end
  end
end

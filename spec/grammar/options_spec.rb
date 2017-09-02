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
      describe 'deprecation' do
        before do
          @orig_stderr = $stderr
          $stderr = StringIO.new
        end

        it 'deprecates seed number in the legacy constructor format' do
          Metallurgy.new(43210)
          $stderr.rewind
          expect($stderr.string.chomp).to match(/Passing a numeric seed arg directly is deprecated./)
        end

        after do
          $stderr = @orig_stderr
        end
      end

      it 'accepts a seed option' do
        grammar = Metallurgy.new(seed: 43210)

        expect(grammar.generate).to eq_per_platform(jruby: 'platinum', default: 'platinum')
      end
    end

    describe ':rng' do
      describe 'deprecation' do
        before do
          @orig_stderr = $stderr
          $stderr = StringIO.new
        end

        it 'deprecates random instance in the legacy constructor format' do
          Metallurgy.new(Random.new(43210))
          $stderr.rewind
          expect($stderr.string.chomp).to match(/Passing a Random object directly is deprecated./)
        end

        after do
          $stderr = @orig_stderr
        end
      end

      it 'accepts a random instance as an option' do
        grammar = Metallurgy.new(rng: Random.new(43210))

        expect(grammar.generate).to eq_per_platform(jruby: 'platinum', default: 'platinum')
      end
    end
  end
end

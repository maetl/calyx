require 'spec_helper'

describe Calyx::Result do
  describe '#tree' do
    specify 'wraps expression tree' do
      tree = Calyx::Result.new([:root, [:leaf, 'atom']]).tree
      expect(tree).to eq([:root, [:leaf, 'atom']])
    end

    specify 'expression tree is immutable' do
      tree = Calyx::Result.new([:root, [:leaf, 'atom']]).tree
      expect { tree << [:leaf, 'atom'] }.to raise_error(RuntimeError)
    end

    specify '#to_exp aliases #tree' do
      result = Calyx::Result.new([:root, [:leaf, 'atom']])
      expect(result.to_exp).to eq(result.tree)
    end
  end

  describe '#text' do
    specify 'flattens expression tree to string' do
      expr = [:root, [:branch, [:leaf, 'one'], [:leaf, ' '], [:leaf, 'two']]]
      text = Calyx::Result.new(expr).text
      expect(text).to eq('one two')
    end

    specify '#to_s aliases #text' do
      result = Calyx::Result.new([:root, [:leaf, 'atom']])
      expect(result.to_s).to eq(result.text)
    end

    specify '#to_s interpolates automatically' do
      result = Calyx::Result.new([:root, [:leaf, 'atom']])
      expect("#{result}").to eq(result.text)
    end
  end

  describe '#symbol' do
    specify 'flattens expression tree to symbol' do
      symbol = Calyx::Result.new([:root, [:leaf, 'atom']]).symbol
      expect(symbol).to eq(:atom)
    end

    specify '#to_sym aliases #symbol' do
      result = Calyx::Result.new([:root, [:leaf, 'atom']])
      expect(result.to_sym).to eq(result.symbol)
    end
  end
end

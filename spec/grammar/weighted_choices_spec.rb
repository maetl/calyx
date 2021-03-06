require 'spec_helper'

describe Calyx::Grammar do
  describe 'weighted choices' do
    it 'raises error if weighted choices do not sum to 1' do
      expect do
        class BadWeights < Calyx::Grammar
          start ['10%', 0.1], ['70%', 0.7]
        end
      end.to raise_error('Weights must sum to 1')
    end

    it 'selects rules with a weighted choice' do
      class WeightedChoices < Calyx::Grammar
        start ['20%', 0.2], ['80%', 0.8]
      end

      grammar = WeightedChoices.new(seed: 12345)
      expect(grammar.generate).to eq('20%')
    end

    it 'selects rules with hash choices' do
      grammar = Calyx::Grammar.new(seed: 12345) do
        start '20%' => 0.2, '80%' => 0.8
      end

      expect(grammar.generate).to eq('20%')
    end

    it 'raises error if ranges do not sum to range.max' do
      expect do
        Calyx::Grammar.new(seed: 12345) do
          start 'first' => 0..1, 'last' => 5..7
        end
      end.to raise_error('Weights must sum to total: 7')
    end

    it 'selects rules with range weights' do
      grammar = Calyx::Grammar.new(seed: 12345) do
        start '20%' => 1..2, '80%' => 3..10
      end

      expect(grammar.generate).to eq('20%')
    end

    it 'selects rules with fixnum weights' do
      grammar = Calyx::Grammar.new(seed: 12345) do
        start '20%' => 20, '80%' => 80
      end

      expect(grammar.generate).to eq('20%')
    end
  end
end

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

      grammar = WeightedChoices.new(12345)
      expect(grammar.generate).to eq('20%')
    end
  end
end

require 'spec_helper'

describe Calyx::Grammar do
  describe '#generate' do
    specify 'generate with explicit start symbol' do
      grammar = Calyx::Grammar.new do
        alt_start 'alt_start'
        start 'start'
      end

      expect(grammar.generate(:alt_start)).to eq('alt_start')
    end

    specify 'generate with explicit start symbol and context hash' do
      grammar = Calyx::Grammar.new do
        alt_start '{alt_start_var}'
        start 'start'
      end

      expect(grammar.generate(:alt_start, { alt_start_var: 'alt_start_var' })).to eq('alt_start_var')
    end
  end
end

require 'spec_helper'

describe Calyx::Grammar do
  describe 'Instance' do
    it 'constructs a grammar in block with #rule' do
      hue = Calyx::Grammar.new do
        rule :start, 'rgb({r},{g},{b})'
        rule :r, '255'
        rule :g, '0'
        rule :b, '0'
      end

      expect(hue.generate).to eq('rgb(255,0,0)')
    end

    it 'constructs a grammar in block with #method_missing' do
      hue = Calyx::Grammar.new do
        start 'rgb({r},{g},{b})'
        r '255'
        g '0'
        b '0'
      end

      expect(hue.generate).to eq('rgb(255,0,0)')
    end

    it 'returns an empty grammar when block not given' do
      empty = Calyx::Grammar.new

      expect(empty.generate(start: 'START')).to eq('START')
    end
  end
end

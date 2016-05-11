require 'spec_helper'

describe Calyx::Grammar do
  context 'instance' do
    it 'constructs a grammar from block passed to initialize' do
      hue = Calyx::Grammar.new do
        start 'rgb({r},{g},{b})'
        rule :r, '255'
        rule :g, '0'
        rule :b, '0'
      end

      expect(hue.generate).to eq('rgb(255,0,0)')
    end
  end
end

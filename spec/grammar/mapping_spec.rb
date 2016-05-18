require 'spec_helper'

describe Calyx::Grammar do
  describe 'custom mappings' do
    it 'modifies expressions with custom mappings defined in the grammar' do
      grammar = Calyx::Grammar.new do
        mapping :pluralise, /(.+)/ => '\\1s'
        start '{noun.pluralise}'
        noun 'noun'
      end

      expect(grammar.generate).to eq('nouns')
    end
  end
end

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

    it 'modifies expressions with custom filters defined in the grammar' do
      grammar = Calyx::Grammar.new do
        filter :pluralise do |input|
          "#{input}s"
        end
        start '{noun.pluralise}'
        noun 'noun'
      end

      expect(grammar.generate).to eq('nouns')
    end
  end
end

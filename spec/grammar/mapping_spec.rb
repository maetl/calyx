require 'spec_helper'

describe Calyx::Grammar do
  describe 'custom mappings' do
    it 'modifies expressions with custom mappings defined in the grammar' do
      grammar = Calyx::Grammar.new do
        mapping :trim_e, /(.+)(e$)/ => "\\1"
        ism_without_e '{structural.trim_e}ism'
        ism_with_e '{narrative.trim_e}ism'
        structural 'structural'
        narrative 'narrative'
      end

      expect(grammar.generate(:ism_without_e)).to eq('structuralism')
      expect(grammar.generate(:ism_with_e)).to eq('narrativism')
    end

    it 'modifies expressions with methods from an included module' do
      module Pluralisation
        def pluralise(input)
          "#{input}s"
        end
      end

      grammar = Calyx::Grammar.new do
         modifier Pluralisation
         start '{noun.pluralise}'
         noun 'noun'
      end

      expect(grammar.generate).to eq('nouns')
    end

    it 'only includes modifiers on the instance scope' do
      grammar = Calyx::Grammar.new do
         start '{noun.pluralise}'
         noun 'noun'
      end

      expect(grammar.generate).to eq('noun')
    end

    it 'responds to builtin modifiers' do
      grammar = Calyx::Grammar.new do
        start '{noun_l.upper}:{noun_u.lower}'
        noun_l 'lower'
        noun_u 'UPPER'
      end

      expect(grammar.generate).to eq('LOWER:upper')
    end

    xit "rewrites selected nouns using mapping" do
      grammar = Calyx::Grammar.new do
        mapping :pronoun, {
          /Snowball/i => "her",
          /Santa’s Little Helper/i => "his"
        }

        start "{@animal} {verb} {@animal.pronoun} {appendage}"
        animal "Snowball", "Santa’s Little Helper"
        verb "chases", "licks", "bites"
        appendage "tail", "paw"
      end

      expect(grammar.generate).to eq('Snowball licks her tail')
    end
  end
end

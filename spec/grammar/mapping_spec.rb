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
        start '{noun_l.upper} & {noun_u.lower}'
        noun_l 'lower'
        noun_u 'UPPER'
      end

      expect(grammar.generate).to eq('LOWER & upper')
    end

    it "handles modifier chains with bidirectional mapping" do
      grammar = Calyx::Grammar.new(seed: 12345) do
        animal "Snowball", "Santa’s Little Helper"
        posessive "her", "his"

        animal_to_pronoun({
          "Snowball" => "her",
          "Santa’s Little Helper" => "his"
        })

        map_left "{@posessive<animal_to_pronoun} licks {@posessive} tail"
        map_right "{@animal} licks {@animal>animal_to_pronoun} tail"
      end

      expect(grammar.generate(:map_left)).to eq("Snowball licks her tail")
      expect(grammar.generate(:map_right)).to eq("Santa’s Little Helper licks his tail")
    end
  end
end

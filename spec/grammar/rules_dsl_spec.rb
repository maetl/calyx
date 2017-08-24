require 'spec_helper'

describe Calyx::Grammar do
  describe 'rules dsl' do
    specify 'rule symbols from named instance methods' do
      grammar = Calyx::Grammar.new do
        start '{hello} {world}.'
        hello 'Hallo'
        world 'Welt'
      end

      expect(grammar.generate).to eq('Hallo Welt.')
    end

    specify 'rule symbols from named class methods' do
      class HalloWelt < Calyx::Grammar
        start '{hello} {world}.'
        hello 'Hallo'
        world 'Welt'
      end
      grammar = HalloWelt.new

      expect(grammar.generate).to eq('Hallo Welt.')
    end

    specify 'class definitions behave the same as instance definitions' do
      class ClassDef < Calyx::Grammar
        start '.1.'
      end

      instance_def = Calyx::Grammar.new do
        start '.1.'
      end

      class_def = ClassDef.new
      expect(class_def.generate).to eq(instance_def.generate)
    end
  end
end

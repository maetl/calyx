require 'spec_helper'

describe 'production rules' do
  describe Calyx::Grammar::Production::NonTerminal do
    specify 'construct non-terminal production rule' do
      registry = double('registry')
      expect(registry).to receive(:expand).and_return(Calyx::Grammar::Production::Terminal.new(:atom))
      rule = Calyx::Grammar::Production::NonTerminal.new(:statement, registry)
      rule.evaluate
    end
  end

  describe Calyx::Grammar::Production::Terminal do
    specify 'construct terminal production rule' do
      atom = Calyx::Grammar::Production::Terminal.new(:terminal)
      expect(atom.evaluate).to eq([:atom, :terminal])
    end
  end

  describe Calyx::Grammar::Production::Expression do
    specify 'construct string formatting production' do
      nonterminal = double(:nonterminal)
      allow(nonterminal).to receive(:evaluate).and_return([:atom, 'hello'])
      rule = Calyx::Grammar::Production::Expression.new(nonterminal, ['upcase'])
      expect(rule.evaluate).to eq([:expression, 'HELLO'])
    end
  end

  describe Calyx::Grammar::Production::Choices do
    specify 'construct choices from strings' do
      registry = double('registry')
      rule = Calyx::Grammar::Production::Choices.parse(['atom', 'atom', 'atom'], registry)
      expect(rule.evaluate).to eq([:choice, [:concat, [[:atom, "atom"]]]])
    end

    specify 'construct choices from numbers' do
      registry = double('registry')
      rule = Calyx::Grammar::Production::Choices.parse([123, 123, 123], registry)
      expect(rule.evaluate).to eq([:choice, [:atom, '123']])
    end
  end
end

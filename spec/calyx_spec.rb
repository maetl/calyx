require 'spec_helper'

describe Calyx do
  specify 'registry evaluates the start rule' do
    registry = Calyx::Grammar::Registry.new
    registry.start('atom')
    expect(registry.evaluate).to eq('atom')
  end

  specify 'registry evaluates recursive rules' do
    registry = Calyx::Grammar::Registry.new
    registry.start(:atom)
    registry.rule(:atom, 'atom')
    expect(registry.evaluate).to eq('atom')
  end

  specify 'construct non-terminal production rule' do
    registry = double('registry')
    expect(registry).to receive(:expand).and_return(Calyx::Grammar::Production::Terminal.new(:atom))
    rule = Calyx::Grammar::Production::NonTerminal.new(:statement, registry)
    rule.evaluate
  end

  specify 'construct terminal production rule' do
    atom = Calyx::Grammar::Production::Terminal.new(:atom)
    expect(atom.evaluate).to eq(:atom)
  end

  specify 'construct string formatting production' do
    nonterminal = double(:nonterminal)
    allow(nonterminal).to receive(:evaluate).and_return('hello')
    rule = Calyx::Grammar::Production::Expression.new(nonterminal, ['upcase'])
    expect(rule.evaluate).to eq('HELLO')
  end

  specify 'split and join with delimiters' do
    class OneTwo < Calyx::Grammar
      start '{one} {two}'
      rule :one, 'One.'
      rule :two, 'Two.'
    end

    grammar = OneTwo.new
    expect(grammar.generate).to eq('One. Two.')
  end

  specify 'rule inheritance' do
    class BaseRules < Calyx::Grammar
      rule :one, 'One.'
      rule :two, 'Two.'
    end

    class StartRule < BaseRules
      start '{one} {two}'
    end

    grammar = StartRule.new
    expect(grammar.generate).to eq('One. Two.')
  end

  specify 'reference rule symbols in other rules' do
    class RuleSymbols < Calyx::Grammar
      start :rule_symbol
      rule :rule_symbol, :terminal_symbol
      rule :terminal_symbol, 'OK'
    end

    grammar = RuleSymbols.new
    expect(grammar.generate).to eq('OK')
  end

  specify 'weighted choices must sum to 1' do
    expect do
      class BadWeights < Calyx::Grammar
        start ['10%', 0.1], ['70%', 0.7]
      end
    end.to raise_error('Weights must sum to 1')
  end

  specify 'weighted choices in rule definition' do
    class WeightedChoices < Calyx::Grammar
      start ['20%', 0.2], ['80%', 0.8]
    end

    grammar = WeightedChoices.new(12345)
    expect(grammar.generate).to eq('20%')
  end

  specify 'string formatters in rule definition' do
    class StringFormatters < Calyx::Grammar
      start :hello_world
      rule :hello_world, '{hello.capitalize} world'
      rule :hello, 'hello'
    end

    grammar = StringFormatters.new(12345)
    expect(grammar.generate).to eq('Hello world')
  end

  specify 'instance constructor with block eval' do
    Hue = Calyx::Grammar.new do
      start 'rgb({r},{g},{b})'
      rule :r, '255'
      rule :g, '0'
      rule :b, '0'
    end

    expect(Hue.generate).to eq('rgb(255,0,0)')
  end

  specify 'construct dynamic rules with context hash of values' do
    class TemplateStringValues < Calyx::Grammar
      start '{one}{two}{three}'
    end

    grammar = TemplateStringValues.new
    expect(grammar.generate({one: 1, two: 2, three: 3})).to eq('123')
  end

  specify 'construct dynamic rules with context hash of expansion strings' do
    class TemplateStringExpansions < Calyx::Grammar
      start '{how}'
      rule :a, 'piece of string?'
    end

    grammar = TemplateStringExpansions.new
    expect(grammar.generate({how: '{long}', long: '{is}', is: '{a}'})).to eq('piece of string?')
  end

  specify 'construct dynamic rules with context hash of choices' do
    class TemplateStringChoices < Calyx::Grammar
      start '{fruit}'
    end

    grammar = TemplateStringChoices.new
    expect(grammar.generate({fruit: ['apple', 'orange']})).to match(/apple|orange/)
  end
end

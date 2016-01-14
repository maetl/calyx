require 'spec_helper'
require 'date'
require 'erb'

describe Calyx::Grammar do
  specify 'construct non-terminal production rule' do
    terminal = double('terminal')
    expect(terminal).to receive(:evaluate)
    statement = Calyx::Grammar::Production::NonTerminal.new(:statement, {statement: terminal})
    statement.evaluate
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
end

describe Calyx::DataTemplate do
    class Happy < Calyx::Grammar
      start 'I am happy.'
    end
    class Sad < Calyx::Grammar
      start 'I am sad.'
    end

    happy_data = {:mood => :happy }
    sad_data = { :mood => :sad }

    it 'can handle tenary operations' do
      class DataTemplate < Calyx::DataTemplate
        def write_narrative
          conditional_write mood == :happy, Happy, Sad
        end
      end
      happy_sentence = DataTemplate.new(happy_data)
      sad_sentence = DataTemplate.new(sad_data)

      expect(happy_sentence.publish).to eq("I am happy.")
      expect(sad_sentence.publish).to eq("I am sad.")
    end

    it 'can handle single operations' do
      class DataTemplate < Calyx::DataTemplate
        def write_narrative
          conditional_write mood == :happy, Happy
        end
      end

      happy_sentence = DataTemplate.new(happy_data)
      sad_sentence = DataTemplate.new(sad_data)

      expect(happy_sentence.publish).to eq("I am happy.")
      expect(sad_sentence.publish).to eq("")
    end

    it 'can write without conditions' do
      class DataTemplate < Calyx::DataTemplate
        def write_narrative
          write Happy
        end
      end

      happy_sentence = DataTemplate.new(happy_data)
      expect(happy_sentence.publish).to eq("I am happy.")
    end

    it 'can substitute in data' do
      class StockReport < Calyx::Grammar
        start 'The price of one share of <%= name %> is <%= price %> Yen.'
      end

      class DataTemplate < Calyx::DataTemplate
        def write_narrative
          write StockReport
        end
      end

      stock_data = { :name => "Cyberdyne", :price => 1897.0 }

      stock_report = DataTemplate.new(stock_data)
      expect(stock_report.publish).to eq("The price of one share of Cyberdyne is 1897.0 Yen.")

    end


end

require 'spec_helper'

describe Calyx::Registry do
  let(:registry) do
    Calyx::Registry.new
  end

  specify 'registry evaluates the start rule' do
    registry.start('atom')
    expect(registry.evaluate).to eq([:start, [:choice, [:concat, [[:atom, 'atom']]]]])
  end

  specify 'registry evaluates recursive rules' do
    registry.start(:atom)
    registry.rule(:atom, 'atom')
    expect(registry.evaluate).to eq([:start, [:choice, [:atom, [:choice, [:concat, [[:atom, 'atom']]]]]]])
  end

  specify 'evaluate from context if rule not found' do
    registry.start(:atom)
    expect(registry.evaluate(:start, atom: 'atom')).to eq([:start, [:choice, [:atom, [:choice, [:concat, [[:atom, 'atom']]]]]]])
  end

  specify 'evaluate concatenated production' do
    registry.start('Hello, {name}.')
    registry.rule(:name, 'Joe')
    expect(registry.evaluate).to eq([:start, [:choice, [:concat, [[:atom, 'Hello, '], [:name, [:choice, [:concat, [[:atom, 'Joe']]]]], [:atom, '.']]]]])
  end

  specify 'define rules with error traces' do
    registry.define_rule(:start, 'Registry#define_rule', ['Hello, {name}.'])
    registry.define_rule(:name, 'Registry#define_rule', ['Joe'])
    expect(registry.evaluate).to eq([:start, [:choice, [:concat, [[:atom, 'Hello, '], [:name, [:choice, [:concat, [[:atom, 'Joe']]]]], [:atom, '.']]]]])
  end

  specify 'define rules with method missing' do
    registry.one('1.')
    expect(registry.evaluate(:one)).to eq([:one, [:choice, [:concat, [[:atom, "1."]]]]])
  end

  specify 'transform a value using core string API' do
    expect(registry.expand_filter(:upcase, 'derive')).to eq('DERIVE')
  end

  specify 'transform a value using custom string transformation' do
    registry.mapping(:past_tensify, /(.+e)$/ => '\1d')
    expect(registry.expand_filter(:past_tensify, 'derive')).to eq('derived')
  end

  specify 'unregistered transform returns the identity passed to it' do
    expect(registry.expand_filter(:null, 'derive')). to eq('derive')
  end
end

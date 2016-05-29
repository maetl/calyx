require 'spec_helper'

describe Calyx::Registry do
  let(:registry) do
    Calyx::Registry.new
  end

  specify 'registry evaluates the start rule' do
    registry.start('atom')
    expect(registry.evaluate).to eq([:start, [:choice, [:concat, [[:atom, "atom"]]]]])
  end

  specify 'registry evaluates recursive rules' do
    registry.start(:atom)
    registry.rule(:atom, 'atom')
    expect(registry.evaluate).to eq([:start, [:choice, [:atom, [:choice, [:concat, [[:atom, "atom"]]]]]]])
  end

  specify 'evaluate from context if rule not found' do
    registry.start(:atom)
    expect(registry.evaluate(:start, atom: 'atom')).to eq([:start, [:choice, [:atom, [:concat, [[:atom, "atom"]]]]]])
  end

  specify 'evaluate concatenated production' do
    registry.start('Hello, {name}.')
    registry.rule(:name, 'Joe')
    expect(registry.evaluate).to eq([:start, [:choice, [:concat, [[:atom, "Hello, "], [:name, [:choice, [:concat, [[:atom, "Joe"]]]]], [:atom, "."]]]]])
  end

  specify 'transform a value using core string API' do
    expect(registry.transform(:upcase, "derive")).to eq("DERIVE")
  end

  specify 'transform a value using custom string transformation' do
    registry.mapping(:past_tensify, /(.+e)$/ => '\1d')
    expect(registry.transform(:past_tensify, "derive")).to eq("derived")
  end
end

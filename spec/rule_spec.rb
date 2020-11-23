require 'spec_helper'

describe Calyx::Rule do
  describe '#build_ast' do
    before(:all) do
      @registry = Calyx::Registry.new
    end

    specify 'ε' do
      tree = Calyx::Rule.build_ast([], @registry)
      expect(tree).to be_a(Calyx::Production::Choices)
      expect(tree.size).to eq(0)
    end

    specify 'choices list' do
      tree = Calyx::Rule.build_ast(["One", "Two"], @registry)
      expect(tree).to be_a(Calyx::Production::Choices)
      expect(tree.size).to eq(2)
    end

    specify 'weighted choices list' do
      tree = Calyx::Rule.build_ast([["One", 80], ["Two", 20]], @registry)
      expect(tree).to be_a(Calyx::Production::WeightedChoices)
      expect(tree.size).to eq(2)
    end

    specify 'weighted choices hash' do
      tree = Calyx::Rule.build_ast({"One" => 80, "Two" => 20}, @registry)
      expect(tree).to be_a(Calyx::Production::WeightedChoices)
      expect(tree.size).to eq(2)
    end
  end
end

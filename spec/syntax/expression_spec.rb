require 'spec_helper'

describe Calyx::Syntax::Modifier do
  specify "#filter" do
    modifier = Calyx::Syntax::Modifier.filter(:lower)
    expect(modifier.type).to eq(:filter)
    expect(modifier.name).to eq(:lower)
  end

  specify "#map_left" do
    modifier = Calyx::Syntax::Modifier.map_left(:pronoun)
    expect(modifier.type).to eq(:map)
    expect(modifier.name).to eq(:pronoun)
    expect(modifier.map_dir).to eq(:left)
  end

  specify "#map_right" do
    modifier = Calyx::Syntax::Modifier.map_right(:pronoun)
    expect(modifier.type).to eq(:map)
    expect(modifier.name).to eq(:pronoun)
    expect(modifier.map_dir).to eq(:right)
  end
end

describe Calyx::Syntax::Expression do
  describe "parser" do
    # let(:registry) do
    #   registry = double(:registry)
    #   allow(registry).to receive(:expand).with(:one).and_return("tahi")
    #   allow(registry).to receive(:memoize_expansion).with(:two).and_return("rua")
    #   allow(registry).to receive(:unique_expansion).with(:three).and_return("toru")
    #   registry
    # end

    let(:options) do
      Calyx::Options.new
    end

    specify "non terminal expansion" do
      tahi = double(:tahi)
      allow(tahi).to receive(:evaluate).with(options).and_return("tahi")
      registry = double(:registry)
      allow(registry).to receive(:expand).with(:one).and_return(tahi)

      expr = Calyx::Syntax::Expression.parse("one", registry)
      expect(expr).to be_a(Calyx::Syntax::NonTerminal)
      expect(expr.evaluate(options)).to eq([:one, 'tahi'])
    end

    specify "memoized expansion" do
      registry = double(:registry)
      expect(registry).to receive(:memoize_expansion).with(:two).and_return("rua")

      expr = Calyx::Syntax::Expression.parse("@two", registry)
      expect(expr).to be_a(Calyx::Syntax::Memo)
      expect(expr.evaluate(options)).to eq([:two, 'rua'])
    end

    specify "unique expansion" do
      registry = double(:registry)
      allow(registry).to receive(:unique_expansion).with(:three).and_return("toru")

      expr = Calyx::Syntax::Expression.parse("$three", registry)
      expect(expr).to be_a(Calyx::Syntax::Unique)
      expect(expr.evaluate(options)).to eq([:three, 'toru'])
    end
  end
end

describe Calyx::Syntax::ExpressionChain do
  let(:atom) do
    atom = double(:node)
    allow(atom).to receive(:evaluate).and_return([:atom, 'HELLO'])
    atom
  end

  let(:registry) do
    registry = double(:registry)
    allow(registry).to receive(:expand).with(:lookup).and_return(atom)
    allow(registry).to receive(:expand_filter).with(:lower, 'HELLO').and_return('hello')
    registry
  end

  let(:lower_modifier) do
    modifier = double(:lower_modifier)
    allow(modifier).to receive(:type).and_return(:filter)
    allow(modifier).to receive(:name).and_return(:lower)
    modifier
  end

  let(:options) do
    Calyx::Options.new
  end

  describe "parser" do
    it "constructs a modifier chain from expression syntax" do
      chain = Calyx::Syntax::ExpressionChain.parse("lookup", [".", "lower"], registry)
      expect(chain.evaluate(options)).to eq([:expression, "hello"])
    end
  end

  describe "instance" do
    it "constructs a modifier chain from initialized productions" do
      chain = Calyx::Syntax::ExpressionChain.new(atom, [lower_modifier], registry)
      expect(chain.evaluate(options)).to eq([:expression, "hello"])
    end
  end
end

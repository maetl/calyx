describe Calyx::Options do
  describe :rng do
    it 'returns a random generator from given numeric seed' do
      options = Calyx::Options.new(seed: 1234)
      expect(options.rng.seed).to eq(1234)
    end

    it 'returns a random generator from given random instance' do
      random = Random.new(5678)
      options = Calyx::Options.new(rng: random)
      expect(options.rng).to be(random)
    end

    it 'returns a new generator instance when none is provided' do
      options = Calyx::Options.new
      expect(options.rng).to be_a(Random)
    end
  end

  describe :strict do
    it 'returns true by default' do
      options = Calyx::Options.new
      expect(options.strict).to eq(true)
    end

    it 'returns false when option is set' do
      options = Calyx::Options.new(strict: false)
      expect(options.strict).to eq(false)
    end
  end
end

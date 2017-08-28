describe Calyx::Grammar do
  describe 'strict evaluation' do
    it 'raises undefined rule errors by default' do
      grammar = Calyx::Grammar.new do
        start '{missing_rule}'
      end

      expect { grammar.generate }.to raise_error(Calyx::Errors::UndefinedRule, /{missing_rule}/)
    end

    it 'raises undefined rule errors when :strict => true' do
      grammar = Calyx::Grammar.new(strict: true) do
        start '{missing_rule}'
      end

      expect { grammar.generate }.to raise_error(Calyx::Errors::UndefinedRule, /{missing_rule}/)
    end

    it 'concats empty strings for undefined rules when :strict => false' do
      grammar = Calyx::Grammar.new(strict: false) do
        start '{missing_rule}'
      end

      expect(grammar.generate).to eq('')
    end
  end
end

describe Calyx::Grammar do
  describe 'error trace' do
    it 'raises error when missing rule referenced' do
      grammar = Calyx::Grammar.new do
        start '{next_rule}'
      end

      expect { grammar.generate }.to raise_error(Calyx::Errors::UndefinedRule, /'{next_rule}'/)
    end
  end
end

describe Calyx::Grammar do
  describe 'error trace' do
    specify 'undefined rule in block constructor' do
      grammar = Calyx::Grammar.new do
        start '{next_rule}'
      end

      expect {
        grammar.generate
      }.to raise_error(Calyx::Errors::UndefinedRule, /:next_rule/)
    end

    specify 'undefined rule in class definition' do
      class UndefinedRules < Calyx::Grammar
        start '{next_rule}'
      end

      grammar = UndefinedRules.new

      expect {
        grammar.generate
      }.to raise_error(Calyx::Errors::UndefinedRule, /:next_rule/)
    end

    specify 'undefined start symbol in block constructor' do
      grammar = Calyx::Grammar.new

      expect {
        grammar.generate
      }.to raise_error(Calyx::Errors::UndefinedRule, /:start/)
    end

    specify 'undefined start symbol in block constructor' do
      grammar = Calyx::Grammar.new

      expect {
        grammar.generate
      }.to raise_error(Calyx::Errors::UndefinedRule, /:start/)
    end

    specify 'undefined rule in context hash' do
      grammar = Calyx::Grammar.new do
        start :hello
      end

      expect {
        grammar.generate(hello: :world)
      }.to raise_error(Calyx::Errors::UndefinedRule, /:world/)
    end

    specify 'error trace contains details of source line' do
      grammar = Calyx::Grammar.new do
        start '{hello}'
      end

      expect { grammar.generate }.to raise_error { |error|
        expect(error.message).to match(/error_trace_spec.rb:53/)
        expect(error.message).to match(/start '{hello}'/)
        expect(error.source_line).to eq("start '{hello}'")
      }
    end
  end
end

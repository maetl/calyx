require 'spec_helper'

describe Calyx::Production::AffixTable do
  let(:registry) do
    Calyx::Registry.new
  end

  describe 'literal match' do
    let(:paired_map) do
      Calyx::Production::AffixTable.parse({
        'atom' => 'atoms',
        'molecule' => 'molecules'
      }, registry)
    end

    specify 'lookup from key to value' do
      expect(paired_map.value_for('atom')).to eq('atoms')
      expect(paired_map.value_for('molecule')).to eq('molecules')
    end

    specify 'lookup from value to key' do
      expect(paired_map.key_for('atoms')).to eq('atom')
      expect(paired_map.key_for('molecules')).to eq('molecule')
    end
  end

  describe 'wildcard match' do
    let(:paired_map) do
      Calyx::Production::AffixTable.parse({
        "%y" => "%ies",
        "%s" => "%ses",
        "%" => "%s"
      }, registry)
    end

    specify 'lookup from key to value' do
      expect(paired_map.value_for('ferry')).to eq('ferries')
      expect(paired_map.value_for('bus')).to eq('buses')
      expect(paired_map.value_for('car')).to eq('cars')
    end

    specify 'lookup from value to key' do
      expect(paired_map.key_for('ferries')).to eq('ferry')
      expect(paired_map.key_for('buses')).to eq('bus')
      expect(paired_map.key_for('cars')).to eq('car')
    end
  end
end

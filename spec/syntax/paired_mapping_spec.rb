require 'spec_helper'

describe Calyx::Syntax::PairedMapping do
  let(:registry) do
    Calyx::Registry.new
  end

  let(:paired_map) do
    Calyx::Syntax::PairedMapping.parse({
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

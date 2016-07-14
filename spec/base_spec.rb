require 'spec_helper'

describe ProjectStore::Base do

  let(:store) { File.expand_path '../../test/store1', __FILE__ }

  subject do
    o = described_class.new store
    o.load_entities
    o
  end

  it 'should load all object from all stores' do
    expect(subject.project_entities.keys.size).to eq 3
  end

  it 'should index objects by types' do
    expect(subject.entity_types.keys.size).to eq 2
  end

end
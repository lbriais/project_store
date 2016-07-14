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

  it 'should index objects by stores' do
    expect(subject.stores.keys.size).to eq 2
  end

  it 'should allow to save any entity' do
    subject.project_entities.values.each do |entity|
      expect {entity.save}.not_to raise_error
    end
  end

  context 'when the stores contains duplicated objects' do

    let(:store) { File.expand_path '../../test/store2', __FILE__ }
    subject {described_class.new store}

    it 'should raise an exception by default' do
      expect {subject.load_entities}.to raise_error
    end

  end



end
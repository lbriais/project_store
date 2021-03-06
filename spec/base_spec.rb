require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe ProjectStore::Base do

  let(:store_path) { File.expand_path '../../test/store1', __FILE__ }
  let(:bad_store_path) { File.expand_path '../../test/no_store', __FILE__ }

  subject do
    o = described_class.new store_path
    o.load_entities
    o
  end

  it 'should load all object from all files' do
    expect(subject.project_entities.keys.size).to eq 3
  end

  it 'should index objects by types' do
    expect(subject.entity_types.keys.size).to eq 2
  end

  it 'should index objects by files' do
    expect(subject.files.keys.size).to eq 2
  end

  it 'should allow to save any entity' do
    subject.project_entities.values.each do |entity|
      expect {entity.save}.not_to raise_error
    end
  end

  context 'when initialized with a non-existing path' do

    subject {described_class}

    it 'should raise an exception' do
      expect do
        subject.new bad_store_path
      end .to raise_error ProjectStore::Error
    end

  end

  context 'when the files contain duplicated objects' do

    let(:store_path) { File.expand_path '../../test/store2', __FILE__ }
    subject {described_class.new store_path}

    it 'should raise an exception by default' do
      expect {subject.load_entities}.to raise_error PSE
    end

    it 'should be possible to skip entities with issues' do
      subject.continue_on_error = true
      expect {subject.load_entities}.not_to raise_error
    end

  end


  context 'when managing objects' do

    before(:all) {@dir = Dir.mktmpdir 'project_store'}
    after(:all) { FileUtils.remove_entry @dir }

    let(:correct_entity_content) { {type: :stupid} }

    subject do
      described_class.new @dir
    end

    it 'should allow to delete objects' do
      entity = subject.create :foo, correct_entity_content
      expect(subject.project_entities.values.first).to eq entity
      expect { entity.save }.not_to raise_error
      expect(File.exists? entity.backing_store.path).to be_truthy
      expect { subject.delete entity }.not_to raise_error
      expect(subject.project_entities.values).to be_empty
    end

  end


end
require 'spec_helper'

describe ProjectStore::Editing do

  let(:store_path) { File.expand_path '../../test/store1', __FILE__ }

  subject do
    s = ProjectStore::Base.new store_path
    s.load_entities
    s
  end

  context 'when no editor is specified' do

    it 'should raise an exception when trying to edit an entity' do
      expect {subject.edit subject.project_entities.values.first}.to raise_error PSE
    end

  end

  context 'when an editor is specified' do

    subject do
      s = ProjectStore::Base.new store_path
      s.load_entities
      s.editor = 'any_valid_editor'
      s
    end

    it 'should be able to edit an entity' do
      allow(subject).to receive(:edit_file)
      expect {subject.edit subject.project_entities.values.first}.not_to raise_error
    end

    it 'should be able to edit a store' do
      allow(subject).to receive(:edit_file)
      expect {subject.edit subject.project_entities.values.first.backing_store.path}.not_to raise_error
    end
  end




end
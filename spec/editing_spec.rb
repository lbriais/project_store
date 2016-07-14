require 'spec_helper'

describe ProjectStore::Editing do

  let(:store_path) { File.expand_path '../../test/store1', __FILE__ }

  subject do
    o = ProjectStore::Base.new store_path
    o.load_entities
    o
  end

  context 'when no editor is specified' do

    it 'should raise an exception when trying to edit an entity' do
      expect {subject.edit subject.project_entities.values.first}.to raise_error PSE
    end

  end

  context 'when an editor is specified' do

    it 'should be able to edit a store' do
      pending
      fail
    end
  end




end
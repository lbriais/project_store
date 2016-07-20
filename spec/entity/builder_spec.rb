require 'spec_helper'

describe ProjectStore::Entity::Builder do

  let(:correct_entity) { {type: :stupid} }
  let(:incorrect_entity) { {} }

  subject do
    module A
      extend ProjectStore::Entity::Builder
    end
    A.decorators = {}
    A
  end

  it 'should be possible to create new entities out of (almost) nothing' do
    expect {subject.setup_entity :pipo, correct_entity}.not_to raise_error
    expect {subject.setup_entity :pipo, incorrect_entity}.to raise_error PSE
    expect {subject.setup_entity :pipo, incorrect_entity, :stupid}.not_to raise_error
  end

end

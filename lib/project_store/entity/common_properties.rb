module ProjectStore
  module Entity

    module CommonProperties

      extend ProjectStore::Entity::PropertyBinder

      yaml_accessor :description, :data

    end

  end
end

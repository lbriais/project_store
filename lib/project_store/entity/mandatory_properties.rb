module ProjectStore
  module Entity

    module MandatoryProperties

      extend ProjectStore::Entity::PropertyBinder

      attr_accessor :name
      yaml_accessor :type

    end

  end
end

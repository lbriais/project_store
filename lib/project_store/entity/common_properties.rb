module ProjectStore
  module Entity

    module CommonProperties

      extend ProjectStore::Entity::PropertyBinder

      yaml_accessor :description
      yaml_writer :data

      def data
        self[:data] || {}
      end

    end

  end
end

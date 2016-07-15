module ProjectStore
  module Entity

    module CommonProperties

      extend ProjectStore::Entity::PropertyBinder

      yaml_accessor :description, :data

      # def description
      #   self[:description]
      # end
      #
      # def description=(description)
      #   self[:description] = description
      # end
      #
      # def data
      #   self[:data]
      # end
      #
      # def data=(data)
      #   self[:data] = data
      # end

    end

  end
end

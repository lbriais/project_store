module ProjectStore
  module Entity

    module Base

      include ProjectStore::Entity::MandatoryProperties

      attr_reader :backing_store

      def backing_store=(store)
        raise PSE, 'Cannot change the store for an entity' if backing_store
        @backing_store = store
      end

      def save
        if backing_store.nil?
          ProjectStore.logger.warn "No backing store specified for '#{name}'"
          return false
        end
        valid? raise_exception: true
        ProjectStore.logger.debug "Saving '#{name}' into '#{backing_store.path}'"
        backing_store.transaction do
          backing_store[name] = self
        end
      end

      def valid?(raise_exception: false)
        mandatory_properties.each do |mandatory_property|
          unless self[mandatory_property]
            raise_exception ? raise(PSE, "Invalid entity '#{name}'. Missing '#{mandatory_property}' property") : false
          end
        end
        true
      end

      def mandatory_properties
        @mandatory_properties ||= [:type]
      end

      def basic_checks
        raise PSE, 'Invalid entity. Missing name' unless name
        raise PSE, 'Invalid entity. You should not specify a name as it would not be taken in account' if self[:name]

        [:backing_store, :basic_checks, :save, :internal_type, :mandatory_properties, :valid?].each do |forbidden_name|
          raise PSE, "Invalid entity '#{name}'. Forbidden '#{forbidden_name}' property" if self[forbidden_name]
        end

        valid?(raise_exception: true)
      end

    end

  end
end
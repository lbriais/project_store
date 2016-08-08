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
          ProjectStore.logger.warn "No backing store specified for '#{name}'. Not saved!"
          return false
        end
        valid_to_save? raise_exception: true
        ProjectStore.logger.debug "Saving '#{name}' into '#{backing_store.path}'"
        backing_store.transaction do
          backing_store[name] = self
        end
      end

      def valid_to_load?(raise_exception: false)
        mandatory_properties.each do |mandatory_property|
          unless self[mandatory_property]
            if raise_exception then
              raise(PSE, "Invalid entity '#{name}'. Missing '#{mandatory_property}' property")
            else
              ProjectStore.logger.warn "Invalid entity '#{name}'. Missing '#{mandatory_property}' property"
              false
            end
          end
        end
        true
      end

      def valid_to_save?(raise_exception: false)
        mandatory_properties.each do |mandatory_property|
          unless self[mandatory_property]
            if raise_exception then
              raise(PSE, "Invalid entity '#{name}'. Missing '#{mandatory_property}' property")
            else
              ProjectStore.logger.warn "Invalid entity '#{name}'. Missing '#{mandatory_property}' property"
              false
            end
          end
        end
        true
      end

      def valid?(raise_exception: false)
        valid_to_save? raise_exception
      end

      def mandatory_properties
        @mandatory_properties ||= [:type]
      end

      def basic_checks
        raise PSE, 'Invalid entity. Missing name' unless name
        raise PSE, 'Invalid entity. You should not specify a name as it would not be taken in account' if self[:name]

        [:backing_store, :basic_checks, :save, :internal_type, :mandatory_properties, :valid_to_load?].each do |forbidden_name|
          raise PSE, "Invalid entity '#{name}'. Forbidden '#{forbidden_name}' property" if self[forbidden_name]
        end

        valid_to_load?(raise_exception: true)
      end

    end

  end
end
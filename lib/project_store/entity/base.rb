module ProjectStore
  module Entity

    module Base

      include ProjectStore::Entity::MandatoryProperties
      include ProjectStore::Entity::CommonProperties

      attr_reader :backing_store

      def backing_store=(store)
        raise PSE, 'Cannot change the store for an entity' if @backing_store
        @backing_store = store
      end

      def save
        ProjectStore.logger.info "Saving '#{name}' into '#{backing_store.path}'"
        backing_store.transaction do
          backing_store[name] = self
        end
      end


      def basic_checks
        raise PSE, 'Invalid entity. Missing name' unless name
        raise PSE, 'Invalid entity. You should not specify a name as it would not be taken in account' if self[:name]
        raise PSE, "Invalid entity '#{name}'. Missing type" unless type
        raise PSE, "Invalid entity '#{name}'. Forbidden 'backing_store' entry" if self[:backing_store]
        raise PSE, "Invalid entity '#{name}'. Forbidden 'basic_checks' entry" if self[:basic_checks]
        raise PSE, "Invalid entity '#{name}'. Forbidden 'save' entry" if self[:save]
        raise PSE, "Invalid entity '#{name}'. Forbidden 'internal_type' entry" if self[:internal_type]
      end

    end

  end
end
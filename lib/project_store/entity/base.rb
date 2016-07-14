module ProjectStore
  module Entity

    module Base

      include ProjectStore::Entity::MandatoryProperties

      attr_reader :backing_store, :internal_type

      def backing_store=(store)
        raise 'Cannot change the store for an entity' if @backing_store
        @backing_store = store
      end

      def internal_type=(type)
        raise 'Cannot change the type for an entity' if @internal_type
        @internal_type = type
      end

      def save
        ProjectStore.logger.info "Saving '#{name}' into '#{backing_store.path}'"
        backing_store.transaction do
          backing_store[internal_type] = self
        end
      end


      def basic_checks
        raise 'Invalid entity. Missing name' unless name
        raise "Invalid entity '#{name}'. Forbidden 'backing_store' entry" if self[:backing_store]
        raise "Invalid entity '#{name}'. Forbidden 'basic_checks' entry" if self[:basic_checks]
        raise "Invalid entity '#{name}'. Forbidden 'save' entry" if self[:save]
        raise "Invalid entity '#{name}'. Forbidden 'internal_type' entry" if self[:internal_type]
      end

    end

  end
end
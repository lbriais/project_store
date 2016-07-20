module ProjectStore
  module Entity

    module Builder

      attr_accessor :decorators

      def setup_entity(entity_name, entity = {}, entity_type = nil)
        entity.extend ProjectStore::Entity::Base
        entity.name = entity_name
        entity.type = entity_type unless entity_type.nil?
        entity.basic_checks
        ProjectStore.logger.info "New entity '#{entity.name}' of type '#{entity.type}'."
        # Adds extra decorator
        add_decorators entity
      end

      def add_decorators(entity)
        [:_default, entity.type].each do |decorator_name|
          case decorators[decorator_name]
            when Array
              decorators[decorator_name]
            when NilClass
              []
            else
              [decorators[decorator_name]]
          end .each do |decorator|
            entity.extend decorator
            entity.mandatory_properties.concat decorator.mandatory_properties if decorator.respond_to? :mandatory_properties
            ProjectStore.logger.debug "Decorated entity '#{entity.name}' with '#{decorator}'"
          end
        end
      end

    end

  end
end

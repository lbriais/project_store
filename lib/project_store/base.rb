

module ProjectStore

  class Base

    include ProjectStore::Editing

    attr_accessor :continue_on_error
    attr_reader :path, :project_entities, :entity_types, :stores, :logger

    def initialize(path)
      raise PSE, "Invalid store path '#{path}'!" unless valid_path? path
      @logger = ProjectStore.logger
      @path = File.expand_path path
      @continue_on_error = false
      @project_entities = {}
      @stores = {}
      @entity_types = {}
    end

    def load_entities
      Dir.glob(File.join(path, '*.yaml')).each do |file|
        logger.debug "Found store file '#{file}'"
        begin
          store = YAML::Store.new(file)
          stores[store] ||= []
          store.transaction(true) do
            store.roots.each do |entity_name|
              begin
                logger.debug "Loading '#{entity_name}' entity."
                entity = store[entity_name]
                add_and_index_entity entity, store, entity_name
              rescue => e
                if continue_on_error
                  logger.error "Invalid entity of type '#{entity_name}' in file '#{file}'"
                  logger.debug "#{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
                else
                  logger.debug "#{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
                  raise PSE, "Invalid entity of type '#{entity_name}' in file '#{file}'"
                end
              end
            end
          end
        rescue => e
          logger.error "Invalid store file '#{file}'"
          logger.debug "#{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
          raise unless continue_on_error
        end
      end
    end

    private

    def valid_path?(path)
      Dir.exist? path and File.readable? path and File.writable? path
    end

    def add_and_index_entity(entity, store, entity_name)
      entity.extend ProjectStore::Entity::Base
      entity.name = entity_name
      entity.basic_checks
      logger.info "Found '#{entity.name}' of type '#{entity.type}'."
      raise PSE, "Entity '#{entity.name}' already defined in file '#{project_entities[entity.name].backing_store.path}'" if project_entities[entity.name]
      entity.backing_store = store
      project_entities[entity.name] = entity
      entity_types[entity.type] ||= []
      entity_types[entity.type] << entity
      stores[store] << entity
    end



  end


end
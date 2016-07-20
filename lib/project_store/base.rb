

module ProjectStore

  class Base

    include ProjectStore::Entity::Builder
    include ProjectStore::Editing

    attr_accessor :continue_on_error
    attr_reader :path, :project_entities, :entity_types, :stores, :logger

    def initialize(path)
      raise PSE, "Invalid store path '#{path}'!" unless valid_path? path
      @logger = ProjectStore.logger
      @path = File.expand_path path
      self.continue_on_error = false
      @project_entities = {}
      @stores = {}
      @entity_types = {}
      self.decorators = {}
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
                decorate_and_index_entity entity_name, entity, store
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

    def decorate_and_index_entity(entity_name, entity, store)
      setup_entity! entity_name, entity
      # Re-check the validity of the object now that it has been decorated
      entity.valid?(raise_exception: true)
      index_entity(entity, store)
    end

    def index_entity(entity, store)
      entity.backing_store = store
      raise PSE, "Entity '#{entity.name}' already defined in file '#{project_entities[entity.name].backing_store.path}'" if project_entities[entity.name]
      # Add to the store index store -> entity list
      stores[store] << entity
      # Add to main hash entity name -> entity
      project_entities[entity.name] = entity
      # Add to type hash  entity type -> entity list
      entity_types[entity.type] ||= []
      entity_types[entity.type] << entity
    end


  end


end
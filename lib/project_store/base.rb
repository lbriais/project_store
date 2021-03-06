

module ProjectStore

  class Base

    include ProjectStore::Entity::Builder
    include ProjectStore::Editing

    attr_accessor :continue_on_error
    attr_reader :path, :project_entities, :entity_types, :files, :logger

    def initialize(path)
      raise PSE, "Invalid store path '#{path}'!" unless valid_path? path
      @logger = ProjectStore.logger
      @path = File.expand_path path
      self.continue_on_error = false
      @project_entities = {}
      @files = {}
      @entity_types = {}
      self.decorators = {}
    end

    def clear
      @project_entities = {}
      @files = {}
      @entity_types = {}
    end

    def create(entity_name, entity_content = {}, entity_type = nil, &block)
      raise PSE, "Entity '#{entity_name}' already exists !" if project_entities[entity_name]
      entity_type ||= entity_content[:type]
      entity_content[:type] = entity_type
      store_file = File.join path, "#{entity_type}.yaml"
      candidate_stores = files.keys.select do |store|
        store.path == store_file
      end
      raise PSE, 'Oops something went really wrong' if candidate_stores.size > 1
      target_store = candidate_stores.empty? ? YAML::Store.new(store_file) : candidate_stores.first
      files[target_store] ||= []
      decorate_and_index_entity entity_name, entity_content, target_store, &block
    end

    def delete(entity)
      files[entity.backing_store].delete entity
      project_entities.delete entity.name
      entity_types[entity.type].delete entity
      entity.delete!
    end

    def load_entities(&block)
      Dir.glob(File.join(path, '*.yaml')).each do |file|
        logger.debug "Found store file '#{file}'"
        begin
          store = YAML::Store.new(file)
          files[store] ||= []
          store.transaction(true) do
            store.roots.each do |entity_name|
              begin
                logger.debug "Loading '#{entity_name}' entity."
                entity = store[entity_name]
                decorate_and_index_entity entity_name, entity, store, &block
              rescue => e
                msg = "Invalid entity '#{entity_name}' in file '#{file}' (#{e.message})"
                dbg_msg = "#{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
                if continue_on_error
                  logger.warn msg
                  logger.debug dbg_msg
                else
                  logger.debug dbg_msg
                  raise PSE, msg
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

    def reset
      [project_entities, files, entity_types].each { |list| list.clear}
    end

    def valid_path?(path)
      Dir.exist? path and File.readable? path and File.writable? path
    end

    def decorate_and_index_entity(entity_name, entity, store, &block)
      setup_entity! entity_name, entity, &block
      # Re-check the validity of the object now that it has been decorated
      entity.valid_to_load?(raise_exception: true)
      index_entity(entity, store)
      entity
    end

    def index_entity(entity, store)
      entity.backing_store = store
      raise PSE, "Entity '#{entity.name}' already defined in file '#{project_entities[entity.name].backing_store.path}'" if project_entities[entity.name]
      # Add to the store index store -> entity list
      files[store] << entity
      # Add to main hash entity name -> entity
      project_entities[entity.name] = entity
      # Add to type hash  entity type -> entity list
      entity_types[entity.type] ||= []
      entity_types[entity.type] << entity
    end



  end


end
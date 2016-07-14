
require 'logger'

module ProjectStore

  class Base

    attr_accessor :logger, :continue_on_error
    attr_reader :path, :project_entities, :entity_types, :stores

    def initialize(path)
      raise "Invalid store path '#{path}'!" unless valid_path? path
      @logger = Logger.new STDOUT
      @path = File.expand_path path
      @continue_on_error = true
      @project_entities = {}
      @stores = {}
      @entity_types = {}
    end

    def load_entities
      Dir.glob(File.join(path, '*.yaml')).each do |file|
        logger.debug "Found store file '#{file}'"
        begin
          store = YAML::Store.new(file)
          stores[file] ||= []
          store.transaction(true) do
            store.roots.each do |entity_type|
              begin
                logger.debug "Loading a '#{entity_type}' entity type."
                entity = store[entity_type]
                entity.extend ProjectStore::BasicEntity
                entity.basic_checks
                logger.info "Found '#{entity.name}' of type '#{entity_type}'."
                project_entities[entity.name] = entity
                entity_types[entity_type] ||= []
                entity_types[entity_type] << entity
                stores[file] << entity
              rescue => e
                logger.error "Invalid entity of type '#{entity_type}' in file '#{file}'"
                logger.debug "#{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
                raise unless continue_on_error
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



  end


end
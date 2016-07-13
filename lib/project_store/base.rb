module ProjectStore

  class Base

    attr_reader :path, :project_entities

    def initialize(path)
      raise "Invalid store path '#{path}'!" unless valid_path? path
      @path = File.expand_path path
      @project_entities = {}
    end

    def load_entities
      Dir.glob(File.join path, '*.yaml').each do |file|
        store = YAML::Store.new(file)
        store.transaction(true) do
          store.roots.each do |root_name|
            project_entities[root_name] = store[root_name]
          end
        end
      end
    end




    private

    def valid_path?(path)
      Dir.exist? path and File.readable? path and File.writable? path
    end



  end


end
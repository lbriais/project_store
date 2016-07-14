require 'tempfile'
require 'fileutils'

module ProjectStore

  module Editing

    def editor=(editor)
      raise PSE, "Invalid editor specified '#{editor}'" unless File.executable? editor
      @editor = editor
    end

    def editor
      @editor ||= ENV['EDITOR']
      raise PSE, 'No valid editor specified' unless File.executable? @editor
      @editor
    end

    def edit(file_or_entity)
      file =  case file_or_entity
                when String
                  file_or_entity
                when ProjectStore::Entity::Base
                  file_or_entity.backing_store.path
              end
      tmp_file = Tempfile.new(self.class.name)
      begin
        FileUtils.copy file, tmp_file
        `"#{editor}" "#{tmp_file}"`
        begin
          store = YAML::Store.new(tmp_file)
          store.transaction(true) do
            store.roots.each do |entity_type|
              store[entity_type]
            end
          end
          FileUtils.copy tmp_file, file
        rescue
          logger.error 'Invalid modifications. Aborted !'
        end
      ensure
        tmp_file.unlink
      end

    end


  end

end
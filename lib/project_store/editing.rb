require 'tempfile'
require 'fileutils'

module ProjectStore

  module Editing

    EDITOR_ENVIRONMENT_VARIABLE = 'DM_EDITOR'

    attr_writer :editor

    def editor
      @editor ||= ENV[EDITOR_ENVIRONMENT_VARIABLE]
    end

    def edit(file_or_entity, &block)
      file =  case file_or_entity
                when String
                  if File.exists? file_or_entity and File.readable? file_or_entity
                    file_or_entity
                  else
                    raise PSE, "Invalid file to edit '#{file_or_entity}'"
                  end
                when ProjectStore::Entity::Base
                  file_or_entity.backing_store.path
              end
      tmp_file = Tempfile.new([self.class.name, '.yaml']).path
      begin
        FileUtils.copy file, tmp_file
        edit_file tmp_file, &block
        begin
          store = YAML::Store.new(tmp_file)
          store.transaction do
            store.roots.each do |entity_type|
              store[entity_type]
            end
          end
          FileUtils.copy tmp_file, file
          logger.info "File '#{file}' updated successfully."
          file
        rescue => e
          logger.debug "#{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
          raise PSE, 'Invalid modifications. Aborted !'
        end
      ensure
        File.unlink tmp_file
      end

    end

    private

    def edit_file(file)
      raise PSE, 'No editor specified' if editor.nil?
      logger.debug "Editing file '#{file}', using editor '#{editor}'"
      if block_given?
        yield editor, file
      else
        system "#{editor} '#{file}'"
      end
    end


  end

end
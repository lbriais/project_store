require 'tempfile'
require 'fileutils'

module ProjectStore

  module Editing

    EDITOR_ENVIRONMENT_VARIABLE = 'DM_EDITOR'
    EDIT_RETRY_ENVIRONMENT_VARIABLE = 'DM_EDIT_RETRY'
    DEFAULT_RETRY_MAX_COUNT = 1
    ERROR_FILE_KEPT = '/tmp/last-failed-edit.yaml'

    attr_writer :editor, :nb_max_edit_retries

    def editor
      @editor ||= ENV[EDITOR_ENVIRONMENT_VARIABLE]
    end

    def nb_max_edit_retries
      default = ENV[EDIT_RETRY_ENVIRONMENT_VARIABLE].to_i unless ENV[EDIT_RETRY_ENVIRONMENT_VARIABLE].nil?
      default ||= DEFAULT_RETRY_MAX_COUNT
      @nb_max_edit_retries ||= default
    end

    def edit(file_or_entity, &block)
      file = case file_or_entity
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
        retry_count ||= 1
        FileUtils.copy file, tmp_file if retry_count == 1
        edit_file tmp_file

        store = YAML::Store.new(tmp_file)
        store.transaction do
          store.roots.each do |entity_name|
            entity = store[entity_name]
            setup_entity! entity_name, entity, &block
            entity.valid_to_save? raise_exception: true
          end
        end
        FileUtils.copy tmp_file, file
        logger.info "File '#{file}' updated successfully."
        file
      rescue StandardError => e
        retry_count += 1
        retry unless retry_count > nb_max_edit_retries
        raise e
      ensure
        if retry_count > nb_max_edit_retries
          logger.error "Keeping file '#{ERROR_FILE_KEPT}' which was invalid !"
          FileUtils.copy tmp_file, ERROR_FILE_KEPT
        end
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
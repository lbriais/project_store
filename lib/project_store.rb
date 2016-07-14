require 'yaml/store'
require 'logger'

require 'project_store/version'
require 'project_store/basic_entity'
require 'project_store/base'

module ProjectStore
  def self.logger
    @logger ||= Logger.new STDOUT
  end

  def self.logger=(logger)
    @logger = logger
  end
end

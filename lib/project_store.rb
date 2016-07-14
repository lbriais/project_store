require 'yaml/store'
require 'logger'

require 'project_store/version'
require 'project_store/error'

module ProjectStore
  def self.logger
    @logger ||= Logger.new STDOUT
  end

  def self.logger=(logger)
    @logger = logger
  end
end


require 'project_store/entity/mandatory_properties'
require 'project_store/entity/common_properties'
require 'project_store/entity/base'
require 'project_store/editing'
require 'project_store/base'

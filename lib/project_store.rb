require 'yaml/store'
require 'logger'

require 'project_store/version'
require 'project_store/error'
require 'project_store/utils/basic_logger'
require 'project_store/initializer'

module ProjectStore

  extend ProjectStore::Utils::BasicLogger

end

require 'project_store/entity/property_binder'
require 'project_store/entity/mandatory_properties'
require 'project_store/entity/common_properties'
require 'project_store/entity/base'
require 'project_store/editing'
require 'project_store/base'

require 'fileutils'

module ProjectStore

  module Initializer

    def self.init_path_structure(path = Dir.pwd)
      FileUtils.mkpath path
    end

  end

end
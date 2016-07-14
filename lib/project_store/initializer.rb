require 'fileutils'

module ProjectStore

  module Initializer

    def self.setup(path = Dir.pwd)
      FileUtils.mkpath path
    end

  end

end
require 'fileutils'

module ProjectStore

  module Initializer


    def self.setup(path = Dir.pwd)
      FileUtils.mkpath path
    end

    private

    def find_store_dir(dir_basename, from_dir)
      raise "Invalid directory '#{from_dir}'" unless Dir.exist?(from_dir) and File.readable?(from_dir)

      candidate = File.join from_dir, dir_basename

      if Dir.exists? candidate
        if File.readable? candidate and File.writable? candidate
          candidate
        else
          raise "Found a project directory '#{candidate}', but with wrong access rights."
        end
      else
        next_dir = File.expand_path '..', from_dir
        if next_dir == from_dir
          raise 'No project directory found.'
        else
          find_store_dir dir_basename, next_dir
        end
      end

    end



  end


end
module ProjectStore

  module BasicEntity


    def name
      self[:name]
    end

    def description
      self[:description]
    end

    def data
      self[:data]
    end

    def basic_checks
      raise 'Invalid entity. Missing name' unless name
    end

  end

end
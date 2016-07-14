module ProjectStore

  module BasicEntity

    attr_reader :backing_store

    def backing_store=(store)
      raise 'Cannot change the store for an entity' if @backing_store
      @backing_store = store
    end

    def name
      self[:name]
    end

    def name=(name)
      self[:name] = name
    end

    def description
      self[:description]
    end

    def description=(description)
      self[:description] = description
    end

    def data
      self[:data]
    end

    def data=(data)
      self[:data] = data
    end

    def basic_checks
      raise 'Invalid entity. Missing name' unless name
      raise "Invalid entity '#{name}'. Forbidden 'backing_store' entry" if self[:backing_store]
    end

  end

end
module ProjectStore
  module Entity

    module MandatoryProperties

      def name
        self[:name]
      end

      def name=(name)
        self[:name] = name
      end

    end

  end
end

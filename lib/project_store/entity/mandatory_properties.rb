module ProjectStore
  module Entity

    module MandatoryProperties

      attr_accessor :name

      def type
        self[:type]
      end

      def type=(type)
        self[:type] = type
      end

    end

  end
end

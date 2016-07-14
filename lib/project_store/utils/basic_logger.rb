module ProjectStore
  module Utils

    module BasicLogger

      def logger=(logger)
        @logger = logger
      end

      def logger
        @logger ||= Logger.new STDOUT
      end

    end

  end
end

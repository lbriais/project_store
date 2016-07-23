module ProjectStore
  module Utils

    module BasicLogger

      class NullLogger
        def method_missing(*args)
          # Do nothing
        end
      end

      def logger=(logger)
        @logger = logger
        yield logger if block_given?
      end

      def logger
        @logger ||= NullLogger.new
      end

    end

  end
end

module ProjectStore
  module Entity

    module PropertyBinder

      def yaml_accessor(*args)
        args.each do |arg|
          yaml_reader arg
          yaml_writer arg
        end
      end

      def yaml_reader(*args)
        args.each do |arg|
          self.class_eval do
            define_method arg do
              self[arg]
            end
          end
        end
      end

      def yaml_writer(*args)
        args.each do |arg|
          self.class_eval do
            define_method "#{arg}=" do |val|
              self[arg] = val
            end
          end
        end
      end

    end

  end
end

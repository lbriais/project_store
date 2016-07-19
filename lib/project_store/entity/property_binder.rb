module ProjectStore
  module Entity

    module PropertyBinder

      def yaml_accessor(*yaml_properties)
        yaml_properties.each do |yaml_property|
          yaml_reader yaml_property
          yaml_writer yaml_property
        end
      end

      def yaml_reader(*yaml_properties)
        yaml_properties.each do |yaml_property|
          self.class_eval do
            define_method yaml_property do
              self[yaml_property]
            end
          end
        end
      end

      def yaml_writer(*yaml_properties)
        yaml_properties.each do |yaml_property|
          self.class_eval do
            define_method "#{yaml_property}=" do |val|
              self[yaml_property] = val
            end
          end
        end
      end

      def mandatory_properties
        @mandatory_properties ||= []
      end

      def mandatory_property(*properties)
        properties.each do |property|
          mandatory_properties << property
        end
      end



    end

  end
end

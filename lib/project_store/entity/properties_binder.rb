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
            define_method(arg) {self[arg]}
          end
        end
      end

      def yaml_writer(*args)
        args.each do |arg|
          self.class_eval do
            define_method("#{arg}=") do |val|
              if self.respond_to? :backing_store
                backing_store.transaction do
                  self[arg] = val
                end
                ProjectStore.logger.debug "Property '#{arg}' is persisted"
              else
                self[arg] = val
                ProjectStore.logger.warn "Property '#{arg}' is modified but not persisted"
              end

            end
          end

        end
      end

    end

  end
end
